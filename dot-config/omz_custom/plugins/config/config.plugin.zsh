function config() {
    config_path="${XDG_CONFIG_HOME}/$1"
    if [[ ! -e ${config_path} ]]; then
        echo "App config not found at ${config_path}"
    fi

    cd "${config_path}"

    dir_entries=$(ls -A "${config_path}")
    num_entries=$(echo "${dir_entries}" | wc -l)
    if [[ num_entries -eq 1 ]]; then
      config_path="${config_path}/${dir_entries}"
    fi

    $EDITOR "${config_path}"
}

function _config() {
    compadd $(ls "${XDG_CONFIG_HOME}")
}
compdef _config config
