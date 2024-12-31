import count_vimplugins_stars/logic.{read_input_file}
import gleam/io
import glint

pub fn cmd() -> glint.Command(Nil) {
  use <- glint.command_help(
    "Counts amount of stars for all Vim plugins in nixpkgs",
  )
  use input_file_arg <- glint.named_arg("input_file")
  use output_file_arg <- glint.named_arg("output_file")
  use <- glint.unnamed_args(glint.EqArgs(0))
  use named_args, _unnamed, _flags <- glint.command()

  let input_file = input_file_arg(named_args)
  let output_file = output_file_arg(named_args)

  let plugin_urls = read_input_file(input_file)

  io.debug(plugin_urls)
  Nil
}
