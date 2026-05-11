function get-app-id() {
  app_name=$1
  codesign -dv ${app_name} 2>&1 | grep '^Identifier=' | awk -F '=' '{ print $2 }'
}

function _get-app-id() {
    local -a apps
    # Glob qualifier (N) = NULL_GLOB: silently skip a dir if it has no matches.
    apps=( /Applications/*.app(N) ~/Applications/*.app(N) )
    # -M passes match specifications that loosen how the typed text matches candidates:
    #   l:|=*              any chars may appear to the LEFT of the typed text
    #                      (so `Slack` matches `/Applications/Slack.app`)
    #   m:{a-zA-Z}={A-Za-z}  case-insensitive letter matching
    # -a apps   take completions from the `apps` array (preserves spaces in names)
    compadd -M 'l:|=* m:{a-zA-Z}={A-Za-z}' -a apps
}
compdef _get-app-id get-app-id
