import gleam/dict
import gleam/dynamic
import gleam/json
import gleam/list
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

pub fn read_input_file(input_file: String) -> List(String) {
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

pub fn read_output_file(
  output_file: String,
) -> Result(dict.Dict(String, Int), json.DecodeError) {
  let output = {
    case read_file(output_file) {
      Ok(res) -> res
      Error(_) -> "{}"
    }
  }
  let decoder = dynamic.dict(dynamic.string, dynamic.int)

  json.decode(output, decoder)
}

pub fn write_output_file(
  output_file: String,
  to_write: dict.Dict(String, Int),
) -> Result(Nil, simplifile.FileError) {
  let as_str =
    dict.to_list(to_write)
    |> list.map(fn(x) {
      let #(k, v) = x
      #(k, json.int(v))
    })
    |> json.object
    |> json.to_string

  let assert Ok(_) = simplifile.write(as_str, to: output_file)
}
