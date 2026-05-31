# Aliases + abbreviations, ported from fish config/abbrs_aliases.fish.
# `abbr -S` = session abbreviation (defined each startup, fish-abbr style).
# Only the daily-driver subset is ported; flesh out the rest as needed.

# Silence zsh-abbr's "Added the ... abbreviation" output on every startup.
ABBR_QUIET=1

# --- aliases -----------------------------------------------------------------
alias vim=nvim
alias view='nvim -R'
alias find='fd'
alias ls='eza --icons'
alias sudo='sudo '                                  # keep aliases after sudo
command -v pbcopy >/dev/null 2>&1 || alias pbcopy='xclip -selection clipboard'

# --- editor / misc -----------------------------------------------------------
abbr -S o=open
abbr -S v=nvim
abbr -S nv=nvim
abbr -S clr=clear
abbr -S top=btop
abbr -S py=python
abbr -S t=tmux
abbr -S lg=lazygit
abbr -S lzd=lazydocker
abbr -S ll='ls -hl'
abbr -S la='ls -hlA'
abbr -S lt='ls --tree'
abbr -S mkd='mkdir -p'
abbr -S 'rm'='rm -i'
abbr -S cp='cp -i'
abbr -S mv='mv -i'
abbr -S rf='rm -rf'
abbr -S cdr='cd $(git rev-parse --show-toplevel)'

# --- git ---------------------------------------------------------------------
abbr -S g=git
abbr -S ga='git add'
abbr -S 'ga.'='git add .'
abbr -S gaa='git add --all'
abbr -S gco='git checkout'
abbr -S gcn='git commit -n'
abbr -S gcm='git commit -m'
abbr -S gcl='git clone'
abbr -S gst='git status'
abbr -S gp='git push'
abbr -S gpo='git push origin'
abbr -S gpl='git pull'
abbr -S gf='git fetch'
abbr -S gsw='git switch'
abbr -S gg='ghq get'

# --- docker ------------------------------------------------------------------
abbr -S do='docker container'
abbr -S dop='docker container ps'
abbr -S dor='docker container run --rm'
abbr -S dox='docker container exec -it'
abbr -S dc='docker compose'
abbr -S dcu='docker compose up'
abbr -S dcub='docker compose up --build'
abbr -S dcd='docker compose down'
abbr -S dcr='docker compose restart'

# --- zk (zettelkasten) -------------------------------------------------------
abbr -S zn='zk new'
abbr -S zl='zk edit --interactive'
abbr -S zg='zk list --interactive'
