#! bash oh-my-bash.module
# coderemote.plugin.sh
# Author: William Sawyer <wmsawyer2609@gmail.com>
#

function coderemote() {
    host="$1"
    path="$2"

    code --folder-uri="vscode-remote://ssh-remote+${host}${path}"
}

function codecontainer() {
    wslPath="$1"

    windowsPath="$(wslpath -w ${wslPath})"

    # Convert to continuous hex string
    hexPath="$(echo ${windowsPath} | xxd -plain -c0)"

    mountPoint="$(devcontainer read-configuration)"

    code --folder-uri "vscode-remote://dev-container+${hexPath}${mountPoint}"
}
