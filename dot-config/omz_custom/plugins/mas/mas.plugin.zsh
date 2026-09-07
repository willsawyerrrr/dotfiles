#compdef mas

__mas_complete() {
    local -ar non_empty_completions=("${@:#(|:*)}")
    local -ar empty_completions=("${(M)@:#(|:*)}")
    _describe -V '' non_empty_completions -- empty_completions -P $'\'\''
}

__mas_custom_complete() {
    local -a completions
    completions=("${(@f)"$("${command_name}" "${@}" "${command_line[@]}")"}")
    if [[ "${#completions[@]}" -gt 1 ]]; then
        __mas_complete "${completions[@]:0:-1}"
    fi
}

__mas_cursor_index_in_current_word() {
    if [[ -z "${QIPREFIX}${IPREFIX}${PREFIX}" ]]; then
        printf 0
    else
        printf %s "${#${(z)LBUFFER}[-1]}"
    fi
}

_mas() {
    emulate -RL zsh -G
    setopt extendedglob nullglob numericglobsort
    unsetopt aliases banghist

    local -xr SAP_SHELL=zsh
    local -x SAP_SHELL_VERSION
    SAP_SHELL_VERSION="$(builtin emulate zsh -c 'printf %s "${ZSH_VERSION}"')"
    local -r SAP_SHELL_VERSION

    local context state state_descr line
    local -A opt_args

    local -r command_name="${words[1]}"
    local -ar command_line=("${words[@]}")
    local -ir current_word_index="$((CURRENT - 1))"

    local -i ret=1
    local -ar arg_specs=(
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
        '(-): :->command'
        '(-)*:: :->arg'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0
    case "${state}" in
    command)
        local -ar subcommands=(
            'config:Output mas config & related system info'
            'get:Get & install free apps from the App Store'
            'home:Open App Store app pages in the default web browser'
            'install:Install previously gotten apps from the App Store'
            'list:List apps installed from the App Store'
            'lookup:Output app info from the App Store'
            'lucky:Install the first app returned from searching the App Store'
            'open:Open app page in '\''App Store.app'\'''
            'outdated:List pending app updates from the App Store'
            'reset:Reset App Store processes & clear cached App Store downloads'
            'search:Search for apps in the App Store'
            'seller:Open apps'\'' seller pages in the default web browser'
            'signout:Sign out of the App Store'
            'uninstall:Uninstall apps installed from the App Store'
            'update:Update outdated apps installed from the App Store'
            'version:Output version number'
            'help:Show subcommand help information.'
        )
        _describe -V subcommand subcommands && ret=0
        ;;
    arg)
        case "${words[1]}" in
        config|get|home|install|list|lookup|lucky|open|outdated|reset|search|seller|signout|uninstall|update|version|help)
            "_mas_${words[1]}" && ret=0
            ;;
        esac
        ;;
    esac

    return "${ret}"
}

_mas_config() {
    local -i ret=1
    local -ar arg_specs=(
        '--json[Output JSON]'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_get() {
    local -i ret=1
    local -ar arg_specs=(
        '--force[Force reinstall]'
        '--bundle[Process all app IDs as bundle IDs]'
        '*:app-id:'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_home() {
    local -i ret=1
    local -ar arg_specs=(
        '--bundle[Process all app IDs as bundle IDs]'
        '*:app-id:'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_install() {
    local -i ret=1
    local -ar arg_specs=(
        '--force[Force reinstall]'
        '--bundle[Process all app IDs as bundle IDs]'
        '*:app-id:'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_list() {
    local -i ret=1
    local -ar arg_specs=(
        '--json[Output JSON]'
        '--bundle[Process all app IDs as bundle IDs]'
        '*:app-id:'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_lookup() {
    local -i ret=1
    local -ar arg_specs=(
        '--json[Output JSON]'
        '--bundle[Process all app IDs as bundle IDs]'
        '*:app-id:'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_lucky() {
    local -i ret=1
    local -ar arg_specs=(
        '--force[Force reinstall]'
        '*:search-term:'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_open() {
    local -i ret=1
    local -ar arg_specs=(
        '--bundle[Process all app IDs as bundle IDs]'
        ':app-id:'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_outdated() {
    local -i ret=1
    local -ar arg_specs=(
        '--json[Output JSON]'
        '--accurate[Use accurate, slower logic that starts then cancels a download for each queried app, which can exceed download limits & which will open dialogs for undownloadable apps]'
        '--inaccurate[Use inaccurate, faster logic that avoids dialogs]'
        '--check-min-os[Check if macOS can install latest app version]'
        '--no-check-min-os[Check if macOS can install latest app version]'
        '--verbose[Warn about app IDs unknown to the App Store]'
        '--bundle[Process all app IDs as bundle IDs]'
        '*:app-id:'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_reset() {
    local -i ret=1
    local -ar arg_specs=(
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_search() {
    local -i ret=1
    local -ar arg_specs=(
        '--json[Output JSON]'
        '--price[Output the price of each app]'
        '*:search-term:'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_seller() {
    local -i ret=1
    local -ar arg_specs=(
        '--bundle[Process all app IDs as bundle IDs]'
        '*:app-id:'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_signout() {
    local -i ret=1
    local -ar arg_specs=(
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_uninstall() {
    local -i ret=1
    local -ar arg_specs=(
        '--dry-run[Perform dry run]'
        '--all[Uninstall all App Store apps]'
        '--bundle[Process all app IDs as bundle IDs]'
        '*:app-id:'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_update() {
    local -i ret=1
    local -ar arg_specs=(
        '--force[Force reinstall]'
        '--accurate[Use accurate, slower logic that starts then cancels a download for each queried app, which can exceed download limits & which will open dialogs for undownloadable apps]'
        '--inaccurate[Use inaccurate, faster logic that avoids dialogs]'
        '--check-min-os[Check if macOS can install latest app version]'
        '--no-check-min-os[Check if macOS can install latest app version]'
        '--verbose[Warn about app IDs unknown to the App Store]'
        '--bundle[Process all app IDs as bundle IDs]'
        '*:app-id:'
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_version() {
    local -i ret=1
    local -ar arg_specs=(
        '--version[Show the version.]'
        '(-h --help)'{-h,--help}'[Show help information.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

_mas_help() {
    local -i ret=1
    local -ar arg_specs=(
        '*:subcommands:'
        '--version[Show the version.]'
    )
    _arguments -w -s -S : "${arg_specs[@]}" && ret=0

    return "${ret}"
}

if [[ "${funcstack[1]}" = _mas ]]; then
    _mas "${@}"
else
    compdef _mas mas
fi
