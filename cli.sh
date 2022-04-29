#! /usr/bin/env bash

sudo='True'

# https://stackoverflow.com/a/8574392
elementIn () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

if elementIn "zsh" "$@"; then
    zsh='True'
    oh_my_zsh='True'
    materialshell='True'
    zsh_autosuggestions='True'
    zsh_syntax_highlighting='True'
    zshrc='True'
elif elementIn "python" "$@"; then
    pyenv='True'
    poetry='True'
elif elementIn "anaconda" "$@"; then
    anaconda3='True'
elif elementIn "miniconda" "$@"; then
    miniconda3='True'
elif elementIn "utilities" "$@"; then
    micro='True'
    fd='True'
    jq='True'
    ag='True'
    ripgrep='True'
    tmux='True'
    oh_my_tmux='True'
    # Comment out because rarely used and prevents non-interactive install
    # fuzzy_file_finder='True'
    xclip='True'
    xsel='True'
    smem='True'
    tree='True'
    gtop='True'
    shellcheck='True'
elif elementIn 'docker' "$@"; then
    docker='True'
    docker_compose='True'
elif elementIn 'jupyter' "$@"; then
    jupyter_notebook_remote='True'
    bash_kernel='True'
    ijavascript='True'
fi

source linux_install.sh

