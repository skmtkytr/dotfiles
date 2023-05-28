########################################
# VIM
if test -f $HOME'/.ghq/github.com/neovim/neovim/build/bin/nvim'
  alias nvim=$HOME'/.ghq/github.com/neovim/neovim/build/bin/nvim'
end

alias vim='nvim'
alias view='nvim -R'
# aliases

alias find='fd '
alias ls='exa '
alias la='ls -a'
alias ll='ls -l'
 
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
 
alias mkdir='mkdir -p'

alias gcp='git cherry-pick '

alias unset='set --erase'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

alias ctags="`brew --prefix`/bin/ctags"

# git alias
alias gpl='git pull '
alias gco='git checkout '
alias gcm='git commit '
alias glog='git log '
alias gst='git status '


######################################
## peco
set -x FILTER peco

function peco
  command peco --layout=bottom-up $argv
end

