set KEYTIMEOUT 0
########################################
# 環境変数
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

set -x PATH /usr/local/bin $PATH
set -x PATH /usr/local $PATH 
set -x PATH $HOME/.anyenv/bin $PATH
set -x PATH $HOME/.gem/bin $PATH
set -x PATH $HOME/.cargo/bin $PATH

set -x GOPATH $HOME/go
set -x GOROOT /usr/local/opt/go/libexec
set -x PATH $GOROOT/bin $GOPATH/bin $PATH
set -x PKG_CONFIG_PATH /usr/local/opt/imagemagick@6/lib/pkgconfig
set -x PATH $HOME/.local/bin $PATH

eval (direnv hook fish)

#nvim conf
set -x XDG_CONFIG_HOME $HOME/.config
set -x EDITOR nvim

# gem home 
set -x GEM_HOME ~/.gem

set -x JAVA_HOME '/usr/libexec/java_home -v 1.8' 
# vi 風キーバインドにする
fish_vi_key_bindings
# vi modeではなんか[I]みたいなの出るからオーバーライド
function fish_mode_prompt 
end
function fish_default_mode_prompt
end

# *env init 
status --is-interactive; and source (anyenv init -|psub)
status --is-interactive; and source (pyenv init -|psub)
goenv init - | source
set -x PATH $HOME/.rbenv/shims $PATH
rbenv rehash >/dev/null ^&1
# (rbenv init - | psub)

### Added by the Bluemix CLI
#source /usr/local/Bluemix/bx/zsh_autocomplete

### ssh agent
# ssh-add -K ~/.ssh/gitlab
# ssh-add -K ~/.ssh/github
# ssh-add -K ~/.ssh/id_rsa
# ssh-add -K ~/.ssh/pokeme_rsa
set -x PYENV_ROOT $HOME/.pyenv
# set -x PGDATA /usr/local/var/postgres

# 初回シェル時のみ tmux実行
bass ~/.config/fish/functions/tmux.bash.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kyo/Downloads/google-cloud-sdk/path.fish.inc' ]
  source '/Users/kyo/Downloads/google-cloud-sdk/path.fish.inc'
end
