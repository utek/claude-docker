# Claude Code Docker Environment

This repository provides a Docker image and Compose configuration for running Claude Code with Rust tooling, Python tooling, Git, and the GitHub CLI.

## Requirements
- Docker Desktop or Docker Engine with Docker Compose v2.

## Quick Start

### Using Make (Recommended)

The Makefile provides convenient shortcuts for common operations:

```bash
# Build the Docker image
make build

# Run Claude Code with Anthropic Cloud API
make claude-cloud

# Run Claude Code with Ollama (local models)
make claude-ollama

# Open a bash shell in the container
make bash-cloud
make bash-ollama

# Stop containers
make stop-cloud
make stop-ollama

# Show help
make help
```

### Using Docker Compose Directly

```bash
# Build the Docker image
docker compose build

# Start the container in detached mode
docker compose up -d

# Run a quick test
docker compose exec claude-code claude "Summarize the repo"

# Access the container shell
docker compose exec claude-code bash
```

## Makefile Commands

The included Makefile simplifies common tasks with the following commands:

| Command | Description |
|---------|-------------|
| `make build` | Build the Docker image |
| `make claude-cloud` | Run Claude Code with Anthropic cloud API |
| `make claude-ollama` | Run Claude Code with Ollama (local models) |
| `make bash-cloud` | Open a bash shell (cloud image) |
| `make bash-ollama` | Open a bash shell (Ollama image) |
| `make stop-cloud` | Stop cloud API containers |
| `make stop-ollama` | Stop Ollama containers |
| `make help` | Show available commands |

### Passing Extra Arguments

You can pass additional arguments to Claude Code using `--`:

```bash
# Specify a model for Ollama
make claude-ollama -- --model gpt-oss:latest

# Specify a model for cloud API
make claude-cloud -- --model claude-sonnet-4-5-20250929

```

### Custom Workspace Directory

By default, the Makefile mounts the current directory (`$PWD`) as `/workspace`. You can override this with the `WORKSPACE_DIR` environment variable:

```bash
# Use a specific project directory
WORKSPACE_DIR=~/projects/my-app make claude-ollama

# Work with a different project while keeping your current shell location
WORKSPACE_DIR=~/another-project make claude-cloud -- "Summarize the code"

# Analyze a project in your home directory
WORKSPACE_DIR=~/git/my-repo make claude-cloud -- "Review the README"
```

| Environment Variable | Default | Description |
|---------------------|---------|-------------|
| `WORKSPACE_DIR` | `$(PWD)` | Path to mount as `/workspace` inside the container |
### Using Docker Compose Directly (Alternative)

If you need more control over volume mounting, use `docker compose run` directly:

```bash
# Mount a specific directory to /workspace
docker compose run --rm -v ~/project:/workspace claude-code claude "Analyze this code"

# Mount with a working directory change
docker compose run --rm -v ~/project:/workspace -w /workspace claude-code claude "Summarize the repo"

# Mount SSH keys and a custom workspace
docker compose run --rm -v ~/.ssh:/root/.ssh:ro -v ~/project:/workspace claude-code
```

## Configuration

### Environment Variables

The environment variables are configured in `docker-compose.yml`. Here's what each variable does:

- `ANTHROPIC_API_KEY`: Your Claude API key (required when using the Anthropic API)
- `ANTHROPIC_BASE_URL`: The API endpoint URL (default: http://host.docker.internal:11434) for local/compatible endpoints
- `GITHUB_TOKEN`: GitHub personal access token for GitHub CLI (optional)
- `GH_CONFIG_DIR`: Directory for GitHub CLI configuration
- `GIT_CONFIG_GLOBAL`: Global Git configuration file location

### Setting Up Your API Key

1. **macOS/Linux**:
   ```bash
   export ANTHROPIC_API_KEY="your-key-here"
   ```

2. **Windows (PowerShell)**:
   ```powershell
   setx ANTHROPIC_API_KEY "your-key-here"
   ```

3. **In docker-compose.yml** (not recommended for security):
   ```yaml
   environment:
     ANTHROPIC_API_KEY: "your-key-here"
   ```

## Claude Code Setup

1. Set your Claude API key before starting the container
2. Claude Code is preinstalled during the image build
3. Run Claude Code directly with Compose:
   ```bash
docker compose exec claude-code claude "your prompt"
```
Claude Code configuration is persisted in the `claude-xdg-config` volume at `/home/claude/.config/claude` and the `.claude.json` bind mount at `/home/claude/.claude.json`.

## Python Dependencies

Python packages are installed during the image build. To add new packages:

1. Add to the Dockerfile:
   ```dockerfile
   RUN pip install package-name
   ```
2. Rebuild the image:
   ```bash
   docker compose build
   ```

## Customization

To customize the environment:

1. **Add custom Python packages**: Modify the Dockerfile to include them in the installation process
2. **Add additional system tools**: Add packages in the apt-get install section of the Dockerfile
3. **Configure environment variables**: Modify the `docker-compose.yml` file

## Git Configuration

Run these inside the container to persist Git identity in the `git-config` volume:
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

## GitHub CLI Configuration

Authenticate and configure GitHub CLI inside the container:
```bash
gh auth login
gh auth setup-git
gh auth status
```
Credentials are stored in the `gh-config` volume.

## Optional: SSH Keys

If you need SSH-based Git access, mount your SSH directory when starting a shell:
```bash
docker compose run --rm -v ~/.ssh:/root/.ssh:ro claude-code
```

## Usage Examples

### Running Claude Code
```bash
# Execute a command directly
docker compose exec claude-code claude "What is the weather like today?"

# Start an interactive shell
docker compose exec claude-code bash

# Run Claude Code with a file
docker compose exec claude-code claude "Analyze this code" < /path/to/file.py
```

### Volume Mounting
To persist data or access local files:
```bash
docker compose run --rm -v $(pwd):/workspace claude-code
```

### Running Commands in Container
```bash
# Run a command in the container
docker compose exec claude-code ls -la

# Run a Python script
docker compose exec claude-code python3 script.py

# Run a shell command
docker compose exec claude-code echo "Hello World"
```

## Docker Sibling Mode

This container runs in **Docker sibling mode**, meaning it can launch and manage Docker containers on the host's Docker daemon. This is achieved by mounting the host's Docker socket (`/var/run/docker.sock`) into the container, rather than running a Docker daemon inside the container (Docker-in-Docker).

### How It Works

- The Docker CLI and Compose plugin are installed inside the container
- The host's Docker socket is bind-mounted into the container
- An entrypoint script automatically detects the socket's group ownership and adjusts permissions so the `claude` user can access it
- Any `docker` or `docker compose` commands run inside the container will execute on the **host's** Docker daemon

### Windows Docker Desktop

This setup is designed for Windows Docker Desktop, which exposes the Docker socket at `/var/run/docker.sock` inside the WSL2 VM. No additional configuration is needed — Docker Desktop handles the socket exposure automatically.

### Volume Mount Path Caveat

When running `docker` commands from inside this container to launch sibling containers, **volume mount paths refer to the host filesystem**, not the container filesystem. For example:

```bash
# Inside the container, this mounts /workspace from the HOST, not from this container
docker run -v /workspace:/app some-image
```

To mount a directory that exists inside this container into a sibling container, you need to use the corresponding host path. You can set `HOST_WORKSPACE_DIR` to help with this:

```bash
# In your host shell (PowerShell)
$env:HOST_WORKSPACE_DIR = "C:\Users\you\project"

# Inside the container, use the host path for sibling mounts
docker run -v "$HOST_WORKSPACE_DIR:/app" some-image
```

### Disabling Docker Sibling Mode

If you don't need Docker sibling mode, remove or comment out the Docker socket volume mount from `docker-compose.yml` and `claude.yml`:

```yaml
# - /var/run/docker.sock:/var/run/docker.sock
```

## Security Considerations

- Never commit your API key to version control
- Use environment variables for sensitive data
- Regularly update the Docker image to get security patches
- The container runs as a non-root user for improved security (the entrypoint starts as root only to fix Docker socket permissions, then drops to the `claude` user)
- **Docker socket access**: Mounting the Docker socket grants the container the ability to manage all containers on the host. Only use this in trusted environments

## Multi-stage Build

The Docker image uses a multi-stage build process to:
- Reduce final image size
- Minimize attack surface by including only necessary runtime dependencies
- Separate build-time dependencies from runtime dependencies
- Improve security by not including build tools in the final image
- The container runs as a non-root user for improved security

## Health Checks

The container includes health checks to monitor its status. You can check the health status with:
```bash
docker compose ps
```

The health check verifies that Claude Code is properly installed and functional by running `claude --version`.

## Troubleshooting

### API Key Issues
If Claude Code fails to authenticate:
1. Verify your ANTHROPIC_API_KEY is set correctly
2. Check that the key has proper permissions
3. Ensure you're using the correct API endpoint

### Container Issues
If the container fails to start:
1. Check Docker logs: `docker compose logs`
2. Verify Docker is running properly
3. Ensure sufficient system resources are available

### Common Issues and Solutions

**Issue**: "Permission denied" when running commands
- Solution: Make sure the container is running with proper permissions

**Issue**: Network connectivity problems
- Solution: Verify your network settings and ensure the base URL is accessible

**Issue**: Container keeps restarting
- Solution: Check the logs with `docker compose logs` for detailed error information

## Development Workflow

### Setting up a Development Environment

1. Build the image:
   ```bash
   docker compose build
   ```

2. Start the container:
   ```bash
   docker compose up -d
   ```

3. Enter the container:
   ```bash
   docker compose exec claude-code bash
   ```

4. Test Claude Code:
   ```bash
   docker compose exec claude-code claude "Hello, Claude!"
   ```

### Shell Customizations

The container includes useful shell customizations:

- **Aliases**: Common commands like `ll`, `gs`, `py`, `d`, etc. with helpful shortcuts
- **Functions**: Useful functions like `cdc` (change directory and show path) and `mkcd` (create directory and change to it)
- **Prompt**: Enhanced prompt showing current directory
- **Help System**: Type `claude-help` to see all available aliases and functions

To customize your shell experience, edit `~/.bashrc` inside the container.

### Working with Your Local Code

To work with code from your local machine:

1. Mount your workspace:
   ```bash
   docker compose run --rm -v $(pwd):/workspace claude-code
   ```

2. Navigate to your code:
   ```bash
   cd /workspace
   ```

3. Run your development tasks:
   ```bash
   docker compose exec claude-code claude "Analyze this Python code" < your_file.py
   ```

## Performance Tips

- Use `docker compose up -d` to run containers in detached mode
- Build images with `--no-cache` flag when making significant changes
- Monitor resource usage with `docker stats`
- Clean up unused containers periodically with `docker system prune`

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

