#! /usr/bin/env bash

sudo='True'

if [[ $1 == 'zsh' ]]; then
    zsh='True'
    oh_my_zsh='True'
    materialshell='True'
    zsh_autosuggestions='True'
    zsh_syntax_highlighting='True'
    zshrc='True'
elif [[ $1 == 'anaconda' ]]; then
    anaconda3='True'
elif [[ $1 == 'miniconda' ]]; then
    miniconda3='True'
elif [[ $1 == 'utilities' ]]; then
    micro='True'
    fd='True'
    jq='True'
    ag='True'
    ripgrep='True'
    tmux='True'
    oh_my_tmux='True'
    fuzzy_file_finder='True'
    xclip='True'
    xsel='True'
    yapf='True'
    smem='True'
    tree='True'
    gtop='True'
    shellcheck='True'
elif [[ $1 == 'docker' ]]; then
    docker='True'
    docker_compose='True'
elif [[ $1 == 'jupyter' ]]; then
    jupyter_notebook_remote='True'
    bash_kernel='True'
    ijavascript='True'
fi

source linux_install.sh

