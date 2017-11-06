########################################
# aliases
 
alias la='ls -a'
alias ll='ls -l'
 
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
 
alias mkdir='mkdir -p'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

alias ctags="`brew --prefix`/bin/ctags"
alias tmux-copy='tmux save-buffer - | reattach-to-user-namespace pbcopy'

######################################
## peco
set -x FILTER peco

function peco
  command peco --layout=bottom-up $argv
end

