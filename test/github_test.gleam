import count_vimplugins_stars/github
import gleeunit/should

pub fn parse_plugin_url_ok_test() {
  github.parse_plugin_url("https://github.com/aaa/bbb")
  |> should.be_ok()
  |> should.equal(github.PluginInfo("aaa", "bbb"))
}

pub fn parse_plugin_url_ok_trailing_slash_test() {
  github.parse_plugin_url("https://github.com/aaa/bbb/")
  |> should.be_ok()
  |> should.equal(github.PluginInfo("aaa", "bbb"))
}

pub fn parse_plugin_url_error_not_gh_test() {
  github.parse_plugin_url("https://gitlab.com/aaa/bbb")
  |> should.be_error()
  |> should.equal("https://gitlab.com/aaa/bbb: not a gh repo")
}

pub fn parse_plugin_url_error_too_few_test() {
  github.parse_plugin_url("https://github.com/aaa")
  |> should.be_error()
  |> should.equal(
    "https://github.com/aaa: too few/too many elements after split",
  )
}

pub fn parse_plugin_url_error_too_many_test() {
  github.parse_plugin_url("https://github.com/aaa/bbb/ccc")
  |> should.be_error()
  |> should.equal(
    "https://github.com/aaa/bbb/ccc: too few/too many elements after split",
  )
}

// pub fn fetch_test() {
//   let assert Ok(github_token) = envoy.get("GITHUB_TOKEN")
//   github.fetch(github.PluginInfo("NixOS", "nixpkgs"), github_token)
// }

pub fn parse_response_test() {
  let info = github.PluginInfo("NixOS", "nixpkgs")
  github.parse_response(
    "{\"data\":{\"repository\":{\"stargazerCount\":18694}}}",
    info,
  )
  |> should.be_ok()
  |> should.equal(github.Plugin(info, 18_694))
}

pub fn parse_response_error_test() {
  let info = github.PluginInfo("NixOS", "nixpkgs")
  github.parse_response("{\"status\":\"400\"}", info)
  |> should.be_error()
  |> should.equal(
    "UnexpectedFormat([DecodeError(\"field\", \"nothing\", [\"data\"])])",
  )
}
