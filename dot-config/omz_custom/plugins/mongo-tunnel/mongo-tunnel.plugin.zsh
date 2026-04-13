function _mongo-tunnel() {
    compadd $(ls "${XDG_CONFIG_HOME}/mongo-tunnel/")
}
compdef _mongo-tunnel mongo-tunnel
