import count_vimplugins_stars/logic.{do_work}
import count_vimplugins_stars/print_results
import envoy
import gleam/dict
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

  let assert Ok(github_token) = envoy.get("GITHUB_TOKEN")
  let results = do_work(input_file, output_file, github_token)
  print_results.print_results(dict.values(results))
  Nil
}
