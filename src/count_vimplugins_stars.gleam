import argv
import count_vimplugins_stars/cmd.{cmd}
import glint

pub fn main() {
  glint.new()
  |> glint.with_name("count_vimplugins_stars")
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: [], do: cmd())
  |> glint.run(argv.load().arguments)
}
