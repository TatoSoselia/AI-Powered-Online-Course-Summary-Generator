# 🚀 AI-Powered Online Course Summary Generator - Makefile
# 
# This Makefile provides convenient commands for development, deployment,
# and maintenance of the AI Course Summarizer application.
#
# Usage: make <command> [options]
# Example: make help, make build, make run

# =============================================================================
# VARIABLES & CONFIGURATION
# =============================================================================

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
WHITE := \033[0;37m
BOLD := \033[1m
RESET := \033[0m

# Docker Compose service names
SERVICE_NAME := fastapi
DB_SERVICE := postgres
REDIS_SERVICE := redis
CELERY_SERVICE := celery

# Default values
DOCKER_COMPOSE := docker compose
PYTHON := python3
PIP := pip3

# =============================================================================
# PHONY TARGETS
# =============================================================================

.PHONY: help build build-no-cache run stop clean logs
.PHONY: migrate migrations install_pre_commit run_pre_commit
.PHONY: status restart shell test lint format
.PHONY: setup dev prod

# =============================================================================
# HELP & DOCUMENTATION
# =============================================================================

help: ## 📖 Show this help message
	@echo "$(BOLD)$(CYAN)🚀 AI-Powered Online Course Summary Generator$(RESET)"
	@echo "$(YELLOW)Available commands:$(RESET)"
	@echo ""
	@echo "$(BOLD)$(GREEN)🏗️  BUILD & DEPLOYMENT$(RESET)"
	@echo "  $(CYAN)build$(RESET)                 - Build Docker images with cache"
	@echo "  $(CYAN)build-no-cache$(RESET)        - Build Docker images without cache"
	@echo "  $(CYAN)run$(RESET)                   - Start all services in development mode"
	@echo "  $(CYAN)stop$(RESET)                  - Stop all running services"
	@echo "  $(CYAN)restart$(RESET)               - Restart all services"
	@echo "  $(CYAN)clean$(RESET)                 - Remove containers, networks, and volumes"
	@echo ""
	@echo "$(BOLD)$(GREEN)🗄️  DATABASE OPERATIONS$(RESET)"
	@echo "  $(CYAN)migrate$(RESET)               - Apply database migrations"
	@echo "  $(CYAN)migrations$(RESET)            - Generate new migration (use: make migrations name=\"description\")"
	@echo ""
	@echo "$(BOLD)$(GREEN)🛠️  DEVELOPMENT TOOLS$(RESET)"
	@echo "  $(CYAN)install_pre_commit$(RESET)    - Install pre-commit hooks"
	@echo "  $(CYAN)run_pre_commit$(RESET)        - Run code quality checks"
	@echo "  $(CYAN)lint$(RESET)                  - Run linting checks"
	@echo "  $(CYAN)format$(RESET)                - Format code with Black and isort"
	@echo "  $(CYAN)shell$(RESET)                 - Open shell in FastAPI container"
	@echo ""
	@echo "$(BOLD)$(GREEN)📊 MONITORING & DEBUGGING$(RESET)"
	@echo "  $(CYAN)status$(RESET)                - Show service status"
	@echo "  $(CYAN)logs$(RESET)                  - Show logs from all services"
	@echo "  $(CYAN)logs-app$(RESET)              - Show FastAPI application logs"
	@echo "  $(CYAN)logs-db$(RESET)               - Show database logs"
	@echo "  $(CYAN)logs-redis$(RESET)            - Show Redis logs"
	@echo "  $(CYAN)logs-celery$(RESET)           - Show Celery worker logs"
	@echo ""
	@echo "$(BOLD)$(GREEN)⚡ QUICK SETUP$(RESET)"
	@echo "  $(CYAN)setup$(RESET)                 - Complete initial setup (build + migrate + install hooks)"
	@echo "  $(CYAN)dev$(RESET)                   - Start development environment"
	@echo "  $(CYAN)prod$(RESET)                  - Start production environment"
	@echo ""
	@echo "$(YELLOW)Examples:$(RESET)"
	@echo "  $(WHITE)make help$(RESET)                    # Show this help"
	@echo "  $(WHITE)make setup$(RESET)                   # Complete initial setup"
	@echo "  $(WHITE)make migrations name=\"add user table\"$(RESET)  # Create new migration"
	@echo "  $(WHITE)make logs-app$(RESET)                # View application logs"
	@echo ""

# =============================================================================
# BUILD & DEPLOYMENT
# =============================================================================

build: ## 🏗️ Build Docker images with cache
	@echo "$(BOLD)$(GREEN)🔨 Building Docker images with cache...$(RESET)"
	@$(DOCKER_COMPOSE) build
	@echo "$(BOLD)$(GREEN)✅ Build completed successfully!$(RESET)"

build-no-cache: ## 🏗️ Build Docker images without cache
	@echo "$(BOLD)$(YELLOW)🔨 Building Docker images without cache...$(RESET)"
	@$(DOCKER_COMPOSE) build --no-cache
	@echo "$(BOLD)$(GREEN)✅ Build completed successfully!$(RESET)"

run: ## 🚀 Start all services in development mode
	@echo "$(BOLD)$(GREEN)🚀 Starting AI Course Summarizer services...$(RESET)"
	@echo "$(CYAN)📱 FastAPI App:$(RESET) http://localhost:8000"
	@echo "$(CYAN)📚 API Docs:$(RESET) http://localhost:8000/docs"
	@echo "$(CYAN)🔍 Health Check:$(RESET) http://localhost:8000/"
	@echo "$(YELLOW)Press Ctrl+C to stop services$(RESET)"
	@$(DOCKER_COMPOSE) up

run-detached: ## 🚀 Start all services in background
	@echo "$(BOLD)$(GREEN)🚀 Starting AI Course Summarizer services in background...$(RESET)"
	@$(DOCKER_COMPOSE) up -d
	@echo "$(BOLD)$(GREEN)✅ Services started!$(RESET)"
	@echo "$(CYAN)📱 FastAPI App:$(RESET) http://localhost:8000"
	@echo "$(CYAN)📚 API Docs:$(RESET) http://localhost:8000/docs"

stop: ## 🛑 Stop all running services
	@echo "$(BOLD)$(YELLOW)🛑 Stopping all services...$(RESET)"
	@$(DOCKER_COMPOSE) down
	@echo "$(BOLD)$(GREEN)✅ All services stopped!$(RESET)"

restart: stop run-detached ## 🔄 Restart all services
	@echo "$(BOLD)$(GREEN)✅ Services restarted!$(RESET)"

clean: ## 🧹 Remove containers, networks, and volumes
	@echo "$(BOLD)$(RED)🧹 Cleaning up Docker resources...$(RESET)"
	@echo "$(YELLOW)⚠️  This will remove all containers, networks, and volumes!$(RESET)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		$(DOCKER_COMPOSE) down -v --remove-orphans; \
		docker system prune -f; \
		echo "$(BOLD)$(GREEN)✅ Cleanup completed!$(RESET)"; \
	else \
		echo "$(YELLOW)❌ Cleanup cancelled.$(RESET)"; \
	fi

# =============================================================================
# DATABASE OPERATIONS
# =============================================================================

migrate: ## 🗄️ Apply database migrations
	@echo "$(BOLD)$(GREEN)🗄️  Applying database migrations...$(RESET)"
	@$(DOCKER_COMPOSE) run --rm $(SERVICE_NAME) alembic upgrade head
	@echo "$(BOLD)$(GREEN)✅ Migrations applied successfully!$(RESET)"

migrations: ## 🗄️ Generate new migration (use: make migrations name="description")
	@if [ -z "$(name)" ]; then \
		echo "$(BOLD)$(RED)❌ Error: Migration name is required!$(RESET)"; \
		echo "$(YELLOW)Usage: make migrations name=\"your migration description\"$(RESET)"; \
		exit 1; \
	fi
	@echo "$(BOLD)$(GREEN)🗄️  Generating migration: $(name)$(RESET)"
	@$(DOCKER_COMPOSE) run --rm $(SERVICE_NAME) alembic revision --autogenerate -m "$(name)"
	@echo "$(BOLD)$(GREEN)✅ Migration generated successfully!$(RESET)"

# =============================================================================
# DEVELOPMENT TOOLS
# =============================================================================

install_pre_commit: ## 🛠️ Install pre-commit hooks
	@echo "$(BOLD)$(GREEN)🛠️  Installing pre-commit hooks...$(RESET)"
	@$(PIP) install pre-commit
	@pre-commit install
	@pre-commit autoupdate
	@echo "$(BOLD)$(GREEN)✅ Pre-commit hooks installed successfully!$(RESET)"

run_pre_commit: ## 🛠️ Run code quality checks
	@echo "$(BOLD)$(GREEN)🛠️  Running pre-commit hooks...$(RESET)"
	@pre-commit run --all-files
	@echo "$(BOLD)$(GREEN)✅ Code quality checks completed!$(RESET)"

lint: ## 🔍 Run linting checks
	@echo "$(BOLD)$(GREEN)🔍 Running linting checks...$(RESET)"
	@$(DOCKER_COMPOSE) run --rm $(SERVICE_NAME) flake8 app/
	@echo "$(BOLD)$(GREEN)✅ Linting completed!$(RESET)"

format: ## 🎨 Format code with Black and isort
	@echo "$(BOLD)$(GREEN)🎨 Formatting code...$(RESET)"
	@$(DOCKER_COMPOSE) run --rm $(SERVICE_NAME) black app/
	@$(DOCKER_COMPOSE) run --rm $(SERVICE_NAME) isort app/
	@echo "$(BOLD)$(GREEN)✅ Code formatting completed!$(RESET)"

shell: ## 🐚 Open shell in FastAPI container
	@echo "$(BOLD)$(GREEN)🐚 Opening shell in FastAPI container...$(RESET)"
	@$(DOCKER_COMPOSE) exec $(SERVICE_NAME) /bin/bash

# =============================================================================
# MONITORING & DEBUGGING
# =============================================================================

status: ## 📊 Show service status
	@echo "$(BOLD)$(GREEN)📊 Service Status:$(RESET)"
	@$(DOCKER_COMPOSE) ps
	@echo ""
	@echo "$(BOLD)$(CYAN)🌐 Application URLs:$(RESET)"
	@echo "  $(CYAN)FastAPI App:$(RESET) http://localhost:8000"
	@echo "  $(CYAN)API Docs:$(RESET) http://localhost:8000/docs"
	@echo "  $(CYAN)Health Check:$(RESET) http://localhost:8000/"

logs: ## 📋 Show logs from all services
	@echo "$(BOLD)$(GREEN)📋 Showing logs from all services...$(RESET)"
	@$(DOCKER_COMPOSE) logs -f

logs-app: ## 📋 Show FastAPI application logs
	@echo "$(BOLD)$(GREEN)📋 Showing FastAPI application logs...$(RESET)"
	@$(DOCKER_COMPOSE) logs -f $(SERVICE_NAME)

logs-db: ## 📋 Show database logs
	@echo "$(BOLD)$(GREEN)📋 Showing database logs...$(RESET)"
	@$(DOCKER_COMPOSE) logs -f $(DB_SERVICE)

logs-redis: ## 📋 Show Redis logs
	@echo "$(BOLD)$(GREEN)📋 Showing Redis logs...$(RESET)"
	@$(DOCKER_COMPOSE) logs -f $(REDIS_SERVICE)

logs-celery: ## 📋 Show Celery worker logs
	@echo "$(BOLD)$(GREEN)📋 Showing Celery worker logs...$(RESET)"
	@$(DOCKER_COMPOSE) logs -f $(CELERY_SERVICE)

# =============================================================================
# QUICK SETUP
# =============================================================================

setup: build migrate install_pre_commit ## ⚡ Complete initial setup
	@echo "$(BOLD)$(GREEN)🎉 Setup completed successfully!$(RESET)"
	@echo "$(CYAN)📱 FastAPI App:$(RESET) http://localhost:8000"
	@echo "$(CYAN)📚 API Docs:$(RESET) http://localhost:8000/docs"
	@echo "$(YELLOW)💡 Run 'make run' to start the services$(RESET)"

dev: setup run-detached ## 🚀 Start development environment
	@echo "$(BOLD)$(GREEN)🎉 Development environment ready!$(RESET)"

prod: ## 🚀 Start production environment
	@echo "$(BOLD)$(GREEN)🚀 Starting production environment...$(RESET)"
	@echo "$(YELLOW)⚠️  Make sure to set production environment variables!$(RESET)"
	@$(DOCKER_COMPOSE) -f docker-compose.prod.yml up -d
	@echo "$(BOLD)$(GREEN)✅ Production services started!$(RESET)"

# =============================================================================
# UTILITY TARGETS
# =============================================================================

test: ## 🧪 Run tests (placeholder for future implementation)
	@echo "$(BOLD)$(YELLOW)🧪 Tests not implemented yet.$(RESET)"
	@echo "$(CYAN)💡 Add your test commands here.$(RESET)"

version: ## 📋 Show version information
	@echo "$(BOLD)$(CYAN)🚀 AI-Powered Online Course Summary Generator$(RESET)"
	@echo "$(CYAN)Version:$(RESET) 1.0.0"
	@echo "$(CYAN)Python:$(RESET) 3.11+"
	@echo "$(CYAN)FastAPI:$(RESET) 0.115+"
	@echo "$(CYAN)Docker:$(RESET) $(shell docker --version 2>/dev/null | cut -d' ' -f3 | cut -d',' -f1 || echo 'Not installed')"

# =============================================================================
# DEFAULT TARGET
# =============================================================================

.DEFAULT_GOAL := help