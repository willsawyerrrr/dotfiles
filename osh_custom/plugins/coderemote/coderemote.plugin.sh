#! bash oh-my-bash.module
# coderemote.plugin.sh
# Author: William Sawyer <wmsawyer2609@gmail.com>
#

function coderemote() {
    host="$1"
    path="$2"

    code --folder-uri="vscode-remote://ssh-remote+${host}${path}"
}
