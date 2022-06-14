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
    echo "Setting zsh on"
    zsh='True'
    oh_my_zsh='True'
    materialshell='True'
    zsh_autosuggestions='True'
    zsh_syntax_highlighting='True'
    zshrc='True'
fi
if elementIn "python" "$@"; then
    echo "Setting python on"
    pyenv='True'
    poetry='True'
fi
if elementIn "rust" "$@"; then
    rust='True'
fi
if elementIn "anaconda" "$@"; then
    echo "Setting anaconda on"
    anaconda3='True'
fi
if elementIn "miniconda" "$@"; then
    echo "Setting miniconda on"
    miniconda3='True'
fi
if elementIn "utilities" "$@"; then
    echo "Setting utilities on"
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
    bat='True'
fi
if elementIn 'docker' "$@"; then
    echo "Setting docker on"
    docker='True'
    docker_compose='True'
fi
if elementIn 'jupyter' "$@"; then
    echo "Setting jupyter on"
    jupyter_notebook_remote='True'
    bash_kernel='True'
    ijavascript='True'
fi

source linux_install.sh

