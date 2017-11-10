set KEYTIMEOUT 0
########################################
# 環境変数
set -x LANG ja_JP.UTF-8

set -x PATH /usr/local/bin $PATH
set -x PATH /usr/local $PATH 
set -x PATH $HOME/.erlenv/bin $PATH
set -x PATH $HOME/.gem/bin $PATH
set -x PATH $HOME/.cargo/bin $PATH
set -x GOPATH $HOME/go
set -x GOROOT /usr/local/opt/go/libexec
set -x PATH $GOROOT/bin $GOPATH/bin $PATH
set -x PKG_CONFIG_PATH /opt/ImageMagick/lib/pkgconfig
set -x PATH $HOME/.local/bin $PATH

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

# *env init 
docker-machine env | source
set -gx EXENV_ROOT #path
set -gx RBENV_ROOT #path

set -x PATH $HOME/.rbenv/shims $PATH

### Added by the Bluemix CLI
#source /usr/local/Bluemix/bx/zsh_autocomplete

### ssh agent
# ssh-add -K ~/.ssh/gitlab
# ssh-add -K ~/.ssh/github
# ssh-add -K ~/.ssh/id_rsa
# ssh-add -K ~/.ssh/pokeme_rsa
set -x PYENV_ROOT $HOME/.pyenv

# 初回シェル時のみ tmux実行
bass ~/.config/fish/functions/tmux.bash.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kyo/Downloads/google-cloud-sdk/path.fish.inc' ]
  source '/Users/kyo/Downloads/google-cloud-sdk/path.fish.inc'
end
