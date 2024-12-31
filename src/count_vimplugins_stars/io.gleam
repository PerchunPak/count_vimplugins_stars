import gleam/list
import gleam/string
import gleam/string
import gsv
import simplifile

fn convert_file_error_to_string(error: simplifile.FileError) -> String {
  case error {
    simplifile.Unknown(text) -> text
    text -> string.inspect(text)
  }
}

pub fn read_file(path: String) -> Result(String, String) {
  let res = simplifile.read(path)

  case res {
    Ok(text) -> Ok(text)
    Error(error) ->
      Error(
        "Error reading file "
        <> path
        <> ", error: "
        <> convert_file_error_to_string(error),
      )
  }
}

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
