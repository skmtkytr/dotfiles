set KEYTIMEOUT 0
# if status is-interactive
#     eval (/opt/homebrew/bin/brew shellenv)
# end

# brew
set -gx HOMEBREW_BUNDLE_FILE $HOME/.config/Brewfile
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_ARM /opt/homebrew
set -gx HOMEBREW_X86_64 /usr/local
fish_add_path $HOMEBREW_ARM/bin
fish_add_path $HOMEBREW_X86_64/bin

fish_add_path /usr/local/bin
fish_add_path /usr/local
fish_add_path /usr/.local/bin
fish_add_path /var/lib/snapd/snap/bin

set -x SHELL $(which fish)
# go
set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin

# deno
fish_add_path $HOME/.deno/bin

# rust
fish_add_path $HOME/.cargo/bin

fish_add_path /opt/homebrew/opt/llvm@15/bin

fish_add_path /opt/homebrew/opt/protobuf@3/bin
set -gx LDFLAGS "-L/opt/homebrew/opt/protobuf@3/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/protobuf@3/include"

# Secretive
set SSH_SECRETIVE_SSH_SOCK $HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
test -e $SSH_SECRETIVE_SSH_SOCK && set -x SSH_AUTH_SOCK $SSH_SECRETIVE_SSH_SOCK

# set -x PKG_CONFIG_PATH /usr/local/opt/imagemagick@6/lib/pkgconfig
#set -x SDKROOT (xcrun --sdk macosx --show-sdk-path)

#set -x PATH (brew --prefix)/opt/openssl/bin $PATH
#set -x LDFLAGS /usr/local/opt/openssl/lib $LDFLAGS
#set -x CPPFLAGS /usr/local/opt/openssl/include $CPPFLAGS
#set -x PKG_CONFIG_PATH /usr/local/opt/openssl/lib/pkgconfig $PKG_CONFIG_PATH
# set -gx LDFLAGS -L/opt/homebrew/opt/llvm@15/lib
# set -gx CPPFLAGS -I/opt/homebrew/opt/llvm@15/include

# mise
fish_add_path ~/.local/share/mise/shims

# set -x JAVA_HOME '/usr/libexec/java_home -v 1.8'
# vi 風キーバインドにする
fish_vi_key_bindings
# vi modeではなんか[I]みたいなの出るからオーバーライド
function fish_mode_prompt
end
function fish_default_mode_prompt
end

# *env init 
# status --is-interactive; and source (pyenv init -|psub)
# status --is-interactive; and source (goenv init -|psub)

### Added by the Bluemix CLI
#source /usr/local/Bluemix/bx/zsh_autocomplete

### ssh agent
# if test -b ~/.ssh/gitlab
#     ssh-add ~/.ssh/gitlab >/dev/null ^&1
# end
#
# if test -b ~/.ssh/id_rsa
#     ssh-add ~/.ssh/id_rsa >/dev/null ^&1
# end
#
# if test -b ~/.ssh/id_ed25519
#     ssh-add --apple-use-keychain ~/.ssh/id_ed25519 >/dev/null ^&1
# end
# set -x PGDATA /usr/local/var/postgres

# 初回シェル時のみ tmux実行
# bass ~/.config/fish/functions/tmux.bash.sh
