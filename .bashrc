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
alias cd..='cd ..'
alias cc='git rev-parse HEAD'
alias cc='git rev-parse --short HEAD'
alias on='conda activate'
alias off='conda deactivate'

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

check_bin bat
check_bin fd
check_bin rg
check_bin conda
