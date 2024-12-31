import count_vimplugins_stars/github
import count_vimplugins_stars/io.{
  read_input_file, read_output_file, write_output_file,
} as _
import gleam/dict
import gleam/io
import gleam/list
import gleam/otp/task
import gleam/result
import gleam/string

fn fetch_url(
  url: String,
  already_computed: dict.Dict(String, Int),
  github_token: String,
) -> Result(github.Plugin, String) {
  use plugin <- result.try(github.parse_plugin_url(url))

  let result_from_cache = {
    case dict.get(already_computed, plugin.repo <> "/" <> plugin.owner) {
      Ok(res) -> Ok(github.Plugin(plugin, res))
      Error(_) -> Error(Nil)
    }
  }
  use _ <- result.try_recover(result_from_cache)

  use fetched <- result.try(github.fetch(plugin, github_token))
  Ok(fetched)
}

pub fn do_work(
  input_file: String,
  output_file: String,
  github_token: String,
) -> dict.Dict(String, Int) {
  let plugin_urls = read_input_file(input_file)
  let already_computed =
    result.lazy_unwrap(read_output_file(output_file), fn() {
      panic as { "Output file is damaged: " <> output_file }
    })

  list.sized_chunk(plugin_urls, 10)
  |> list.fold(already_computed, fn(acc, chunk) {
    list.map(chunk, fn(url) {
      task.async(fn() { fetch_url(url, acc, github_token) })
    })
    |> task.try_await_all(60_000)
    |> list.map(fn(x) {
      result.map_error(x, string.inspect)
      |> result.flatten()
    })
    |> list.map(fn(x) {
      case x {
        Ok(pl) -> #(pl.info.owner <> "/" <> pl.info.repo, pl.stars)
        Error(reason) -> {
          io.println_error("Failed to fetch plugin: " <> reason)
          #("ERROR", -1)
        }
      }
    })
    |> dict.from_list()
    |> dict.combine(acc, fn(a, _b) { a })
    |> dict.drop(["ERROR"])
    |> fn(res) {
      let assert Ok(_) = write_output_file(output_file, res)
      res
    }
  })
}
