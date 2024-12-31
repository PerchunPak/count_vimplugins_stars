import count_vimplugins_stars/io.{read_file}
import gleeunit/should
import simplifile
import temporary

pub fn read_file_ok_test() {
  use file <- temporary.create(temporary.file())
  let assert Ok(_) = simplifile.write("Hello, world!", to: file)

  read_file(file)
  |> should.be_ok()
  |> should.equal("Hello, world!")
}

pub fn read_file_error_test() {
  use file <- temporary.create(temporary.file())
  let assert Ok(_) = simplifile.delete(file)

  read_file(file)
  |> should.be_error()
  |> should.equal("Error reading file " <> file <> ", error: Enoent")
}

pub fn read_input_file_test() {
  use file <- temporary.create(temporary.file())
  let assert Ok(_) =
    simplifile.write(
      "repo,branch,alias\n"
        <> "https://github.com/euclidianAce/BetterLua.vim/,,\n"
        <> "https://github.com/vim-scripts/BufOnly.vim/,,\n"
        <> "https://github.com/jackMort/ChatGPT.nvim/,,\n",
      to: file,
    )

  read_input_file(file)
  |> should.equal([
    "https://github.com/euclidianAce/BetterLua.vim/",
    "https://github.com/vim-scripts/BufOnly.vim/",
    "https://github.com/jackMort/ChatGPT.nvim/",
  ])
}
