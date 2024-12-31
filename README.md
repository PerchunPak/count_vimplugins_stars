# count_vimplugins_stars

Count stars of all Vim plugins in nixpkgs. Just a one time script, see the
result in `result.json`.

Regenerate results:
```sh
GITHUB_TOKEN=(rbw get 'GitHub CLI token') gleam run -- ~/dev/nixpkgs/master/pkgs/applications/editors/vim/plugins/vim-plugin-names out
jq 'to_entries | sort_by(.value) | reverse | from_entries' out > result.json
```

Run tests:
```sh
gleam test
```
