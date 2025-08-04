# On Windows this can be symlinked from an elevated prompt with
# cmd //c "mklink C:\Users\<user_dir>\.inputrc C:\Users\<git_checkout>\dotfiles\.inputrc"

alias gs='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdm='git diff origin/master...@'
alias gdmno='git diff --name-only origin/master...@'
alias gdni='git diff --no-index --'
alias gdu='git diff @{u}'
alias gcm='git checkout master'
alias gdmnopy='git diff --name-only --diff-filter=ACM origin/master...@ | grep ".py$"'
alias gfom='git fetch origin master:master'
alias ll='ls -Alh --color=auto --show-control-chars'
alias gau='git add -u'
alias gaa='git add -A'
alias gf='git fetch'
alias gp='git push'
alias gpu='git push -u origin HEAD'
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gb='git rev-parse --abbrev-ref HEAD'
alias gbc='gb | tee clip'
alias gsb='git-select-branch'
alias cd..='cd ..'
alias cc='git rev-parse HEAD'
alias cc='git rev-parse --short HEAD'
alias on='conda activate'
alias off='conda deactivate'
alias c='cargo'
alias cr='cargo run'
alias crr='cargo run --release'
alias crd='cargo run --debug'
alias cb='cargo build'
alias cbr='cargo build --release'
alias cbd='cargo build --debug'
alias rg5='rg -C5'
alias rgg='rg -C5'
# Consider looking for mamba and then defaulting to micromamba
alias mm=micromamba
# alias rr=rustrover64
alias cargodeps='cargo metadata --no-deps | jq ".packages[] | {name, description}"'


export PATH=~/.local/bin:$PATH
export EDITOR=vim

# History operations - largely taken from https://www.thomaslaurenson.com/blog/2018-07-02/better-bash-history/
HISTTIMEFORMAT='%F %T '
HISTFILESIZE=-1
HISTSIZE=-1
HISTCONTROL=ignoredups
# Configure BASH to append (rather than overwrite the history):
shopt -s histappend
# Attempt to save all lines of a multiple-line command in the same entry
shopt -s cmdhist
# After each command, append to the history file and reread it, testing the convenience of -c -r
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$"\n"}history -a"
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$"\n"}history -a; history -c; history -r"

echoerr() { printf "%s\n" "$*" >&2; }

check_bin() {
    if ! command -v "$1" &> /dev/null
    then
        echoerr "Warning, couldn't find: $1"
    fi
}


# This is done here rather than further up because it gives a chance for bash_local to use defined functions
[[ -f ~/.bash_local ]] && source ~/.bash_local

# cd to git checkouts. This looks at a variable that can be set by .bash_local
# Also slightly odd behaviour for paths with capitals in Windows
if [[ "$OSTYPE" == "msys" ]]; then
    CDG=${CDG:-~/Documents/GitHub}
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    CDG=${CDG:-~/git}
fi

## Clipboard
#if [[ "$OSTYPE" == "msys" ]]; then
    #v = /dev/clipboard
#elif [[ "$OSTYPE" == "linux" ]]; then
    ## TODO
    #v = /dev/clipboard
#fi

cdg () {
    local target_dir=$CDG

    if [[ $# -ne 0 ]]; then
        target_dir="${target_dir}/${1}"
    fi

    if [[ -d "$target_dir" ]]; then
        cd "$target_dir"
    else
        echo "Unrecognised dir: $target_dir"
    fi
}

# Completion code from https://stackoverflow.com/a/57426783
# Note that this isn't guaranteed to work with whacky filenames, spaces etc
# TODO: This does something weird when there are no matches
_cdg_completions() {
    ( cd $CDG; printf "%s/\n" "$2"* )
} && complete -o nospace -C _cdg_completions cdg


rg() {
    if [[ -t 1 ]]; then
        command rg -p "$@" | less -RFX
    else
        command rg "$@"
    fi
}

github-https() {
    "git remote set-url origin https://github.com/$(git remote get-url origin | sed 's/https:\/\/github.com\///' | sed 's/git@github.com://')"
}

github-ssh() {
    "git remote set-url origin git@github.com:$(    git remote get-url origin | sed 's/https:\/\/github.com\///' | sed 's/git@github.com://')"
}

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    eval "$(starship init bash)"
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

check_bin bat
check_bin fd
check_bin rg
check_bin conda
check_bin jq
check_bin xh
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash --disable-up-arrow)"
