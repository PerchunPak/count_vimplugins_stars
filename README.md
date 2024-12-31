# count_vimplugins_stars

Count stars of all Vim plugins in nixpkgs. Just a one time script, see the
result in `result.json`.

Regenerate results:
```sh
GITHUB_TOKEN=(rbw get 'GitHub CLI token') gleam run -- ~/dev/nixpkgs/master/pkgs/applications/editors/vim/plugins/vim-plugin-names out
# => over 10k: 19
# => over 1k : 290 (309)
# => over 100: 772 (1081)
# => over 10 : 388 (1471)
# => other   : 102
# => total   : 1579
jq 'to_entries | sort_by(.value) | reverse | from_entries' out > result.json
```

Run tests:
```sh
gleam test
```
