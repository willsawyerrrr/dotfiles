#! bash oh-my-bash.module
# code.plugin.sh
# Author: William Sawyer <wmsawyer2609@gmail.com>
#

function code-remote () {
    host="$1"
    path="$2"

    code --folder-uri="vscode-remote://ssh-remote+${host}${path}"
}

