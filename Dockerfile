FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/home/claude \
    CARGO_HOME=/home/claude/.cargo \
    RUSTUP_HOME=/home/claude/.rustup \
    PATH="/home/claude/.cargo/bin:/home/claude/.local/bin:${PATH}" \
    UV_SYSTEM_PYTHON=1 \
    PYTHONUNBUFFERED=1 \
    GH_CONFIG_DIR=/config/gh \
    GIT_CONFIG_GLOBAL=/config/git/config

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    gnupg \
    gosu \
    openssh-client \
    python3 \
    python3-venv \
    python3-pip \
    python-is-python3 \
    build-essential \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI and Compose plugin (for sibling container mode)
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" \
       | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /etc/apt/keyrings/hashicorp-archive-keyring.gpg \
    && chmod a+r /etc/apt/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
       | tee /etc/apt/sources.list.d/hashicorp.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends terraform \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user and directories
RUN useradd -m -s /bin/bash -u 1000 claude \
    && groupadd -f docker \
    && usermod -aG docker claude \
    && mkdir -p /config/gh /config/git /home/claude/.claude /home/claude/.config/claude /workspace \
    && echo "{}" > /home/claude/.claude.json \
    && chown -R claude:claude /config /home/claude /workspace

# Stage project skills for syncing into the volume at startup
COPY --chown=claude:claude .claude/skills/ /opt/claude-skills/

# Add entrypoint for Docker socket permission handling
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER claude

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --profile minimal --default-toolchain stable \
    && . "$HOME/.cargo/env" \
    && rustup component add clippy rustfmt

# Install uv (Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash

WORKDIR /workspace

ENTRYPOINT ["entrypoint.sh"]
CMD ["bash"]
