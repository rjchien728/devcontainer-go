ARG GO_VERSION=1.24
FROM mcr.microsoft.com/devcontainers/go:${GO_VERSION}

ARG PROTOC_GEN_GO_VERSION=v1.33.0
ARG PROTOC_GEN_GO_GRPC_VERSION=v1.4.0
ARG GOPLS_VERSION=v0.19.1
ARG MOCKERY_VERSION=v2.37.1
ARG GOVULNCHECK_VERSION=v1.1.0

# Base packages and shell setup
RUN apt-get update && \
    apt-get install -y \
        unzip \
        curl \
        git \
        protobuf-compiler \
        iputils-ping \
        socat \
        netcat-openbsd \
        sudo \
        zsh && \
    rm -rf /var/lib/apt/lists/* && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd && \
    if [ ! -d "/root/.oh-my-zsh" ]; then \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended ; \
    else \
        echo "Oh My Zsh already exists. Skipping installation."; \
    fi && \
    chsh -s $(which zsh) vscode

# Go tools and plugins
RUN go install golang.org/x/tools/gopls@${GOPLS_VERSION} && \
    go install github.com/vektra/mockery/v2@${MOCKERY_VERSION} && \
    go install golang.org/x/vuln/cmd/govulncheck@${GOVULNCHECK_VERSION} && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@${PROTOC_GEN_GO_VERSION} && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GO_GRPC_VERSION}

# Cache fix and post-start hook
RUN mkdir -p /go/pkg/mod /go/pkg/sumdb && chmod -R 777 /go/pkg

COPY ./post-start-cmd.sh /usr/local/bin/post-start-cmd.sh
RUN chmod +x /usr/local/bin/post-start-cmd.sh