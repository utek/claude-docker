.PHONY: claude-cloud claude-ollama build stop-cloud stop-ollama help

# Extract extra arguments passed after the target name.
# Usage: make claude-ollama -- /path/to/project --model gpt-oss:latest
ifneq (,$(filter claude-cloud claude-ollama,$(firstword $(MAKECMDGOALS))))
  _RAW_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # If first arg doesn't start with '-', treat it as WORKSPACE_DIR
  _FIRST_ARG := $(firstword $(_RAW_ARGS))
  ifneq (,$(filter-out -%,$(_FIRST_ARG)))
    WORKSPACE_DIR := $(_FIRST_ARG)
    ARGS := $(wordlist 2,$(words $(_RAW_ARGS)),$(_RAW_ARGS))
  else
    ARGS := $(_RAW_ARGS)
  endif
endif

CLOUD_COMPOSE  := -f claude.yml
OLLAMA_COMPOSE := -f docker-compose.yml
CLOUD_SERVICE  := claude-code-cloud
OLLAMA_SERVICE := claude-code

# Default workspace is current directory, can be overridden with WORKSPACE_DIR
WORKSPACE_DIR ?= $(PWD)

help: ## Show available commands
	@echo "Usage:"
	@echo "  make claude-cloud              Run Claude Code with Anthropic cloud API"
	@echo "  make claude-ollama             Run Claude Code with Ollama"
	@echo "  make claude-cloud  -- [PATH] [ARGS]   Run with custom workspace path and args"
	@echo "  make claude-ollama -- [PATH] [ARGS]   Run with custom workspace path and args"
	@echo "  make build                     Build the Docker image"
	@echo "  make stop-cloud                Stop cloud containers"
	@echo "  make stop-ollama               Stop Ollama containers"
	@echo ""
	@echo "Environment Variables:"
	@echo "  WORKSPACE_DIR                  Path to mount as /workspace (default: current directory)"
	@echo ""
	@echo "Examples:"
	@echo "  make claude-ollama -- ~/my-project"
	@echo "  make claude-cloud  -- ~/my-project --model claude-sonnet-4-5-20250929"
	@echo "  make claude-ollama -- --model gpt-oss:latest"
	@echo "  WORKSPACE_DIR=~/project make claude-ollama"

build: ## Build the Docker image
	docker compose $(CLOUD_COMPOSE) build

claude-cloud: ## Run Claude Code with Anthropic cloud API
	docker compose $(CLOUD_COMPOSE) run --rm -v $(WORKSPACE_DIR):/workspace -w /workspace $(CLOUD_SERVICE) claude $(ARGS)

claude-ollama: ## Run Claude Code with Ollama
	docker compose $(OLLAMA_COMPOSE) run --rm -v $(WORKSPACE_DIR):/workspace -w /workspace $(OLLAMA_SERVICE) claude $(ARGS)

stop-cloud: ## Stop cloud containers
	docker compose $(CLOUD_COMPOSE) down

stop-ollama: ## Stop Ollama containers
	docker compose $(OLLAMA_COMPOSE) down

# Catch-all: silently ignore extra arguments passed after --
%:
	@:
