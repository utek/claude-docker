#!/bin/bash
set -e

# Sync baked-in skills from staging directory into the volume-mounted config
if [ -d /opt/claude-skills ] && [ "$(ls -A /opt/claude-skills 2>/dev/null)" ]; then
    mkdir -p /home/claude/.claude/skills
    cp -a /opt/claude-skills/. /home/claude/.claude/skills/
    chown -R claude:claude /home/claude/.claude/skills
fi

# Fix Docker socket permissions so the claude user can use sibling containers
if [ -S /var/run/docker.sock ]; then
    DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
    if [ "$DOCKER_GID" != "0" ]; then
        groupmod -g "$DOCKER_GID" docker 2>/dev/null || true
    else
        chgrp docker /var/run/docker.sock 2>/dev/null || true
    fi
    usermod -aG docker claude 2>/dev/null || true
fi

# Drop to claude user and exec the command
exec gosu claude "$@"
