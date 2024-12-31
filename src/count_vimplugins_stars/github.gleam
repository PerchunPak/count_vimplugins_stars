import gleam/dynamic.{field}
import gleam/hackney
import gleam/http
import gleam/http/request
import gleam/json
import gleam/result
import gleam/string

pub type PluginInfo {
  PluginInfo(owner: String, repo: String)
}

pub type Plugin {
  Plugin(info: PluginInfo, stars: Int)
}

pub fn parse_plugin_url(url: String) -> Result(PluginInfo, String) {
  case string.starts_with(url, "https://github.com/") {
    True -> {
      let strip = string.drop_start(url, string.length("https://github.com/"))
      let strip2 = {
        case string.ends_with(strip, "/") {
          True -> string.drop_end(strip, 1)
          False -> strip
        }
      }

      case string.split(strip2, "/") {
        [owner, repo] -> Ok(PluginInfo(owner, repo))
        _ -> Error("too few/too many elements after split")
      }
    }
    False -> Error("not a gh repo")
  }
}

pub fn fetch(plugin: PluginInfo, github_token: String) -> Result(Plugin, String) {
  let assert Ok(request) = request.to("https://api.github.com/graphql")

  let query =
    "{\n"
    <> "  repository(owner: \""
    <> plugin.owner
    <> "\", name: \""
    <> plugin.repo
    <> "\") {\n"
    <> "    stargazerCount\n"
    <> "  }\n"
    <> "}"
  let body = "{ \"query\": " <> string.inspect(query) <> " }"

  let assert Ok(response) =
    request
    |> request.set_method(http.Post)
    |> request.set_header("Authorization", "bearer " <> github_token)
    |> request.set_body(body)
    |> hackney.send

  parse_response(response.body, plugin)
}

pub fn parse_response(
  response: String,
  info: PluginInfo,
) -> Result(Plugin, String) {
  let decoder = {
    use stars <-
      dynamic.decode1(_, field(
        "data",
        field("repository", field("stargazerCount", dynamic.int)),
      ))
    Plugin(info, stars)
  }

  json.decode(response, decoder)
  |> result.map_error(string.inspect)
}
