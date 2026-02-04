ARG NODE_VERSION=20
FROM mcr.microsoft.com/devcontainers/javascript-node:${NODE_VERSION}

# -----------------------------
# Base packages and shell setup
# -----------------------------
RUN apt-get update && \
    apt-get install -y \
        curl \
        git \
        sudo \
        zsh \
        tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    echo "Asia/Taipei" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /var/lib/lists/* && \
    echo "node ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# -----------------------------
# Oh My Zsh config for node user
# (Oh My Zsh is pre-installed in the base image)
# -----------------------------
COPY shared/zsh-config/.zshrc /home/node/.zshrc
COPY shared/zsh-config/.p10k.zsh /home/node/.p10k.zsh

# Install Powerlevel10k theme and plugins
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/node/.oh-my-zsh/custom/themes/powerlevel10k && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/node/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/node/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    chown -R node:node \
        /home/node/.zshrc \
        /home/node/.p10k.zsh \
        /home/node/.oh-my-zsh
