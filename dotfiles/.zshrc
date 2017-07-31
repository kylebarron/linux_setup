# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/opt/node/bin:$PATH"
export PATH="/opt/julia/bin:$PATH"
export PATH="/opt/anaconda/bin:$PATH"
export PATH="/usr/local/cuda-8.0/bin:$PATH"
export PATH="/opt/forti:$PATH"
#export PATH="/opt/stata15:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-8.0/lib64:LD_LIBRARY_PATH"
export PATH="$PATH:/opt/st3"
export PATH="/opt/stata/:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=/home/kyle/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="materialshell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colored-man-pages extract copydir copyfile tmux web-search zsh-wakatime)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
eval "$(hub alias -s)"
alias ssh-google="ssh kyle@104.196.112.154"
alias ssh-reverse="ssh -f -N -T -R22222:localhost:22 -R8787:localhost:8787 -R8888:localhost:8888 kyle@104.196.112.154"
alias vpn-nber="cd /opt/forti && forti_cli --server vpn.nber.org:10443 --vpnuser barronk"
alias nber-vpn="cd /opt/forti && forti_cli --server vpn.nber.org:10443 --vpnuser barronk"
alias forti=vpn-nber
alias scale-hdmi="xrandr --output HDMI-0 --scale 1.65x1.65"
alias scale-dvi="xrandr --output DVI-I-1 --scale 1.65x1.65"
alias hdmi-scale="xrandr --output HDMI-0 --scale 1.65x1.65"
alias dp-normal="xrandr --output DP-2 --rotate normal"
alias dp-rotate="xrandr --output DP-2 --rotate left"
alias rotate-dp="xrandr --output DP-2 --rotate left"
alias normal-dp="xrandr --output DP-2 --rotate normal"
alias stata="/opt/stata/xstata"

function ssh-mit() {
    ssh ${1} barronk@eosloan.mit.edu
}
function ssh-local() {
    ssh ${1} kyle@192.168.0.41
}
function ssh-home() {
    ssh ${1} kyle@kylebarron.ddns.net
}
function ssh-nber() {
    ssh ${2} barronk@${1}.nber.org
}

function mdu() {
    du -h $1 --apparent-size --max-depth=1
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload bashcompinit
bashcompinit
eval "$(pandoc --bash-completion)"

eval $(thefuck --alias)


source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
