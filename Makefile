.PHONY: claude-cloud claude-ollama build stop-cloud stop-ollama help

# Extract extra arguments passed after the target name.
# Usage: make claude-ollama -- --model gpt-oss:latest
ifneq (,$(filter claude-cloud claude-ollama,$(firstword $(MAKECMDGOALS))))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
endif

CLOUD_COMPOSE  := -f claude.yml
OLLAMA_COMPOSE := -f docker-compose.yml

CLOUD_SERVICE  := claude-code-cloud
OLLAMA_SERVICE := claude-code

help: ## Show available commands
	@echo "Usage:"
	@echo "  make claude-cloud              Run Claude Code with Anthropic cloud API"
	@echo "  make claude-ollama             Run Claude Code with Ollama"
	@echo "  make claude-cloud  -- [ARGS]   Pass extra arguments to claude (cloud)"
	@echo "  make claude-ollama -- [ARGS]   Pass extra arguments to claude (ollama)"
	@echo "  make build                     Build the Docker image"
	@echo "  make stop-cloud                Stop cloud containers"
	@echo "  make stop-ollama               Stop Ollama containers"
	@echo ""
	@echo "Examples:"
	@echo "  make claude-ollama -- --model gpt-oss:latest"
	@echo "  make claude-cloud  -- --model claude-sonnet-4-5-20250929"

build: ## Build the Docker image
	docker compose $(CLOUD_COMPOSE) build

claude-cloud: ## Run Claude Code with Anthropic cloud API
	docker compose $(CLOUD_COMPOSE) up -d
	docker compose $(CLOUD_COMPOSE) exec $(CLOUD_SERVICE) claude $(ARGS)

claude-ollama: ## Run Claude Code with Ollama
	docker compose $(OLLAMA_COMPOSE) up -d
	docker compose $(OLLAMA_COMPOSE) exec $(OLLAMA_SERVICE) claude $(ARGS)

stop-cloud: ## Stop cloud containers
	docker compose $(CLOUD_COMPOSE) down

stop-ollama: ## Stop Ollama containers
	docker compose $(OLLAMA_COMPOSE) down

# Catch-all: silently ignore extra arguments passed after --
%:
	@:
