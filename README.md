# Claude Code Docker Environment

This repository provides a Docker image and Compose configuration for running Claude Code with Rust tooling, Python tooling, Git, and the GitHub CLI.

## Requirements
- Docker Desktop or Docker Engine with Docker Compose v2.

## Quick Start
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

## Security Considerations

- Never commit your API key to version control
- Use environment variables for sensitive data
- Regularly update the Docker image to get security patches
- The container runs as a non-root user for improved security

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

