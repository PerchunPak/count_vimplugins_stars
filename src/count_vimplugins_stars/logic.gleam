import count_vimplugins_stars/io.{read_file} as _
import gleam/list
import gleam/string
import gsv

pub fn read_input_file(input_file: String) {
  let assert Ok(input) = read_file(input_file)
  let assert Ok(rows) =
    string.drop_start(input, string.length("repo,branch,alias\n"))
    |> gsv.to_lists()

  use row <- list.map(rows)

  case row {
    [repo, ..] -> repo
    _ -> panic
  }
}
