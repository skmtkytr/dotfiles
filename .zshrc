# zplugの設定
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

source ~/.zplug/init.zsh
# プライベートリポジトリのプラグインも使うのでzplugのgitをssh経由にする
ZPLUG_PROTOCOL=ssh

# peco/percol/fzfなどでフィルタ絞込するためのフレームワーク
zplug "mollifier/anyframe"
# CWべんりスクリプト
zplug "crowdworksjp/cw-cli-tools"
# Make sure to use double quotes
zplug "zsh-users/zsh-history-substring-search"

# Use the package as a command
# And accept glob patterns (e.g., brace, wildcard, ...)
zplug "Jxck/dotfiles", as:command, use:"bin/{histuniq,color}"

# Can manage everything e.g., other person's zshrc
zplug "tcnksm/docker-alias", use:zshrc

# Disable updates using the "frozen" tag
zplug "k4rthik/git-cal", as:command, frozen:1

# Grab binaries from GitHub Releases
# and rename with the "rename-to:" tag
zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf, \
    use:"*darwin*amd64*"

# Supports oh-my-zsh plugins and the like
zplug "plugins/git",   from:oh-my-zsh

# Also prezto
zplug "modules/prompt", from:prezto

# Load if "if" tag returns true
zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"

# Run a command after a plugin is installed/updated
# Provided, it requires to set the variable like the following:
# ZPLUG_SUDO_PASSWORD="********"
zplug "jhawthorn/fzy", \
    as:command, \
    rename-to:fzy, \
    hook-build:"make && sudo make install"

# Supports checking out a specific branch/tag/commit
zplug "b4b4r07/enhancd", at:v1
zplug "mollifier/anyframe", at:4c23cb60

# Can manage gist file just like other packages
zplug "b4b4r07/79ee61f7c140c63d2786", \
    from:gist, \
    as:command, \
    use:get_last_pane_path.sh

# Support bitbucket
zplug "b4b4r07/hello_bitbucket", \
    from:bitbucket, \
    as:command, \
    use:"*.sh"

# Rename a command with the string captured with `use` tag
zplug "b4b4r07/httpstat", \
    as:command, \
    use:'(*).sh', \
    rename-to:'$1'

# Group dependencies
# Load "emoji-cli" if "jq" is installed in this example
zplug "stedolan/jq", \
    from:gh-r, \
    as:command, \
    rename-to:jq
zplug "b4b4r07/emoji-cli", \
    on:"stedolan/jq"
# Note: To specify the order in which packages should be loaded, use the defer
#       tag described in the next section

# Set the priority when loading
# e.g., zsh-syntax-highlighting must be loaded
# after executing compinit command and sourcing other plugins
# (If the defer tag is given 2 or above, run after compinit command)
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Can manage local plugins
zplug "~/.zsh", from:local

# Load theme file
zplug 'dracula/zsh', as:theme

zplug mafredri/zsh-async, from:github
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose


KEYTIMEOUT=0
########################################
# 環境変数
export LANG=ja_JP.UTF-8

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local:$PATH 
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$HOME/Library/Python/2.7/bin:$PATH
export PATH=$HOME/.erlenv/bin:$PATH
export PATH=$HOME/.gem/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
export PKG_CONFIG_PATH=/opt/ImageMagick/lib/pkgconfig
export PATH=$HOME/.local/bin:$PATH

#nvim conf
export XDG_CONFIG_HOME=$HOME/.config

# gem home 
export GEM_HOME=~/.gem

export JAVA_HOME='/usr/libexec/java_home -v 1.8' 
# 色を使用出来るようにする
autoload -Uz colors
colors
 
# vi 風キーバインドにする
bindkey -v
 
# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
 
# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified
 
########################################
# 補完
# 補完機能を有効にする
autoload -U compinit
compinit

# zsh pure 
autoload -U promptinit; promptinit
prompt pure
 
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
 
# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..
 
# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
 
# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
 
 
########################################
# vcs_info
 
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
 
 
########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# dont need "cd" 
setopt auto_cd
 
setopt correct

# beep を無効にする
setopt no_beep
 
# フローコントロールを無効にする
setopt no_flow_control
 
# '#' 以降をコメントとして扱う
setopt interactive_comments
 
# ディレクトリ名だけでcdする
setopt auto_cd
 
# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups
 
# = の後はパス名として補完する
setopt magic_equal_subst
 
# 同時に起動したzshの間でヒストリを共有する
setopt share_history
 
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
 
# ヒストリファイルに保存するとき、すでに重複したコマンドがあったら古い方を削除する
setopt hist_save_nodups
 
# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
 
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
 
# 補完候補が複数あるときに自動的に一覧表示する
setopt auto_menu
 
# 高機能なワイルドカード展開を使用する
setopt extended_glob
 
########################################
# キーバインド
 
# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward
 
########################################
# エイリアス
 
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

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'
 
# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi
 
 
 
########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        ;;
esac
 
# vim:set ft=zsh:
eval "$(rbenv init -)"
if which exenv > /dev/null; then eval "$(exenv init -)"; fi

export PATH="$HOME/.rbenv/shims:$PATH"

### Added by the Bluemix CLI
#source /usr/local/Bluemix/bx/zsh_autocomplete
export PATH="$HOME/.ndenv/bin:$PATH"

### ssh agent
#ssh-add -K ~/.ssh/gitlab
ssh-add -K ~/.ssh/github
ssh-add -K ~/.ssh/id_rsa
ssh-add -K ~/.ssh/pokeme_rsa
#eval "$(erlenv init -)"
#eval "$(ndenv init -)"
eval "$(docker-machine env)"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# pecoing
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

# 初回シェル時のみ tmux実行
if [ $SHLVL = 1 ]; then
  tmux
fi

# cw-cli-toolsの設定
## sshのOSユーザ名を指定して下さい。
## crowdworksjp/chef-repoに投げたプルリのユーザー名と同じです。基本的には `tarou-suzuki` のような形式です。
CW_CLI_TOOLS_SSH_USER=kyotaro-sakamoto

## 認証にaws-vaultを使用する場合は"assumeRole"を指定してください
CW_CLI_TOOLS_AWS_AUTH_TYPE=assumeRole

## aws-vault認証時にYubiKeyでMFAコードを自動挿入したい場合はTokenを一意に抽出できるクエリを指定してください
## YubiKeyに入っているTokenは $ ykman oath list で一覧できます
#CW_CLI_TOOLS_AWS_AUTH_YUBIKEY_QUERY="Amazon Web Services:TarouSUZUKI@cw-custodian"

## AWSのプロファイル名をデフォルトから変更する場合は指定して下さい。
#CW_CLI_TOOLS_AWS_PROFILE_MAIN=main
#CW_CLI_TOOLS_AWS_PROFILE_DEV=dev

## functionを適当なショートカットキーにバインドする場合は以下のように設定します。
zle -N cw-ssh-main-without-proxy
zle -N cw-ssh-dev-without-proxy
zle -N cw-ssh-prod-with-proxy
zle -N cw-ssh-stg-with-proxy
zle -N cw-ssh-dev-with-proxy
zle -N cw-aws-ssm-main
zle -N cw-aws-ssm-dev
bindkey '^rm' cw-ssh-main-without-proxy
bindkey '^re' cw-ssh-dev-without-proxy
bindkey '^rp' cw-ssh-prod-with-proxy
bindkey '^rs' cw-ssh-stg-with-proxy
bindkey '^rd' cw-ssh-dev-with-proxy
bindkey '^ra' cw-aws-ssm-main
bindkey '^rw' cw-aws-ssm-dev


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kyo/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/kyo/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kyo/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/kyo/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
