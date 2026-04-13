function get-app-id() {
  app_name=$1
  codesign -dv ${app_name} 2>&1 | grep '^Identifier=' | awk -F '=' '{ print $2 }'
}

function _get-app-id() {
    compadd $(ls /Applications/ ~/Applications/)
}
compdef _get-app-id get-app-id
