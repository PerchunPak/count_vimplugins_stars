import gleam/string
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
