alias clear-pycache="find -name __pycache__ -exec rm -rf {} +"

alias jq="jq --color-output --indent 4"

alias less="less --raw-control-chars"

alias py="python3"

alias ps="ps -fu$USER"

alias r="R --no-save --quiet"

alias cvenv="python -m venv .venv"
alias freeze="pip freeze > requirements.txt"
alias venv="source .venv/bin/activate"
