#!/bin/bash
# This script sets up hard links for configuration files and 
# soft links for configuration folders.

main() {
    # Note: for proper linking, paths should be absolute. 
    root_dir=$(pwd)
    check_dir_setup

    # Setup post-merge so that this script is run after each merge
    echo "./install.sh" > .git/hooks/post-merge
    chmod +x .git/hooks/post-merge

    # Create Hard links
    mkdir -p ~/.trash
    create_hard_link $root_dir/bashrc $HOME/.bashrc
    create_hard_link $root_dir/profile $HOME/.profile
    create_hard_link $root_dir/gitconfig $HOME/.gitconfig
    create_hard_link $root_dir/inputrc $HOME/.inputrc
    create_hard_link $root_dir/vimrc $HOME/.vimrc

    # Create soft links.
    create_symbolic_link $root_dir/vim $HOME/.vim 
}

function del() {
    trash_tag=$(date "+%y-%m-%d-%H-%M-%S")
    for file in "$@"; do
        mv "$file" ~/.trash/$trash_tag-$(basename -- $file) 2> /dev/null
    done
}

function create_hard_link() {
    del "$2"
    ln "$1" "$2"
}

function create_symbolic_link() {
    del "$2"
    ln -s "$1" "$2"
}

function check_dir_setup() {
    dir=$(pwd)
    if [[ $dir != "$HOME/.term_settings" ]]; then 
        echo "Error: Project must be located at $HOME/.term_settings and the install script should be run from the project's root directory"
        exit
    fi
}

main "$@"
