FROM mcr.microsoft.com/devcontainers/base:ubuntu

LABEL org.opencontainers.image.source="https://github.com/skmtkytr/dotfiles"
LABEL org.opencontainers.image.description="Mono-local devcontainer for skmtkytr/dotfiles (chezmoi-native)"

ARG DEBIAN_FRONTEND=noninteractive
ARG EZA_VERSION=0.23.4
ARG UDEV_GOTHIC_VERSION=2.2.0

# System packages + Neovim + Fish + GitHub CLI
RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common gpg-agent \
    && add-apt-repository ppa:neovim-ppa/unstable -y \
    && add-apt-repository ppa:fish-shell/release-4 -y \
    && mkdir -p /usr/share/keyrings \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | tee /usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | tee /etc/apt/sources.list.d/github-cli.list >/dev/null \
    && apt-get update && apt-get install -y --no-install-recommends \
        build-essential libssl-dev libyaml-dev libreadline-dev zlib1g-dev \
        libncurses5-dev libffi-dev libgdbm-dev cmake \
        xclip git-lfs curl wget unzip jq \
        lua5.4 luarocks tmux socat psmisc fontconfig \
        neovim fish gh \
    && rm -rf /var/lib/apt/lists/*

# chezmoi (system-wide; survives the ~/.local/share/mise volume mount)
RUN curl -sfL https://get.chezmoi.io | sh -s -- -b /usr/local/bin

# UDEV Gothic NF font
RUN curl -fsSL "https://github.com/yuru7/udev-gothic/releases/download/v${UDEV_GOTHIC_VERSION}/UDEVGothic_NF_v${UDEV_GOTHIC_VERSION}.zip" \
        -o /tmp/udev-gothic.zip \
    && mkdir -p /usr/local/share/fonts/udev-gothic \
    && unzip -q /tmp/udev-gothic.zip -d /tmp/udev-gothic \
    && mv /tmp/udev-gothic/*/*.ttf /usr/local/share/fonts/udev-gothic/ \
    && fc-cache -f /usr/local/share/fonts/udev-gothic \
    && rm -rf /tmp/udev-gothic /tmp/udev-gothic.zip

# eza (ls replacement)
RUN curl -fsSL "https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_$(uname -m)-unknown-linux-gnu.tar.gz" \
    | tar xz -C /usr/local/bin/

# tmux-mem-cpu-load (status bar)
RUN git clone --branch v3.8.2 --depth 1 https://github.com/thewtex/tmux-mem-cpu-load.git /tmp/tmux-mem-cpu-load \
    && cd /tmp/tmux-mem-cpu-load \
    && cmake . && make && make install \
    && rm -rf /tmp/tmux-mem-cpu-load

# Set fish as default shell for vscode user
RUN chsh -s /usr/bin/fish vscode

# vscode user: install mise (binary at ~/.local/bin/mise; tools live in ~/.local/share/mise volume)
USER vscode
RUN curl https://mise.run | sh

USER root
