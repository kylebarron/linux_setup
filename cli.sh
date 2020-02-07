#! /usr/bin/env bash

sudo='True'

if [[ $1 == 'zsh' ]]; then
    zsh='True'
    oh-my-zsh='True'
    materialshell='True'
    zsh-autosuggestions='True'
    zsh-syntax-highlighting='True'
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
    fuzzy-file-finder='True'
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
    jupyter-notebook-remote='True'
    bash-kernel='True'
    ijavascript='True'
fi

source linux_install.sh

