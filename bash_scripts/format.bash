function print_title() {
    typeset spaces
    typeset i=0
    typeset j=0

    if (("$#" < 1)); then
        echo $(red_bold Error:) Argument required
        return 1
    fi

    echo -e ┌───────────────────────────────┐
    for i in "$@"; do
        echo -en │ $i
        ((spaces = 30 - ${#i}))

        for j in $(seq 1 $spaces); do
            echo -en " "
        done
        echo -e │
    done
    echo -e └───────────────────────────────┘
}
# Ex: echo "This is a $(underline test)"
function bold() {
    echo -e "\e[1m$1\e[0m"
}

function red() {
    echo -e "\e[31m$1\e[0m"
}

function italics() {
    echo -e "\e[3m$1\e[0m"
}

function underline() {
    echo -e "\e[4m$1\e[0m"
}

function red_bold() {
    echo -e "\e[1m$(echo -e "\e[31m$1\e[0m")\e[0m"
}