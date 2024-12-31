import argv
import count_vimplugins_stars/cmd.{cmd}
import gleam/io
import gleam/string.{uppercase}
import glint

pub fn main() {
  // create a new glint instance
  glint.new()
  // with an app name of "hello", this is used when printing help text
  |> glint.with_name("count_vimplugins_stars")
  // with pretty help enabled, using the built-in colours
  |> glint.pretty_help(glint.default_pretty_help())
  // with a root command that executes the `hello` function
  |> glint.add(at: [], do: cmd())
  // execute given arguments from stdin
  |> glint.run(argv.load().arguments)
}
