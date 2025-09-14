# CRUD App Development Makefile
# Provides convenient commands for development, testing, and deployment

.PHONY: help install dev test lint format build deploy clean

# Default target
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Installation
install: ## Install all dependencies
	@echo "Installing API dependencies..."
	cd api && npm install
	@echo "Installing Flutter dependencies..."
	cd app && flutter pub get
	@echo "All dependencies installed!"

install-api: ## Install API dependencies only
	cd api && npm install

install-app: ## Install Flutter app dependencies only
	cd app && flutter pub get

# Development
dev: ## Start development servers
	@echo "Starting development environment..."
	@echo "API will be available at http://localhost:3000"
	@echo "Flutter app can be run with: make run-app"
	cd api && npm run dev

dev-api: ## Start API development server only
	cd api && npm run dev

run-app: ## Run Flutter app (requires device/emulator)
	cd app && flutter run

# Testing
test: ## Run all tests
	@echo "Running API tests..."
	cd api && npm test
	@echo "Running Flutter tests..."
	cd app && flutter test

test-api: ## Run API tests only
	cd api && npm test

test-app: ## Run Flutter tests only
	cd app && flutter test

test-watch: ## Run tests in watch mode
	cd api && npm run test:watch

# Code Quality
lint: ## Run linting for all projects
	@echo "Linting API..."
	cd api && npm run lint
	@echo "Linting Flutter app..."
	cd app && flutter analyze

lint-api: ## Lint API code only
	cd api && npm run lint

lint-app: ## Lint Flutter app only
	cd app && flutter analyze

format: ## Format all code
	@echo "Formatting API code..."
	cd api && npm run format
	@echo "Formatting Flutter app..."
	cd app && dart format .

format-api: ## Format API code only
	cd api && npm run format

format-app: ## Format Flutter app only
	cd app && dart format .

# Building
build: ## Build all projects
	@echo "Building API..."
	cd api && npm run build
	@echo "Building Flutter app..."
	cd app && flutter build apk

build-api: ## Build API only
	cd api && npm run build

build-app: ## Build Flutter app only
	cd app && flutter build apk

# Deployment
deploy: ## Deploy to staging
	@echo "Deploying to staging..."
	cd api && npm run deploy:staging

deploy-prod: ## Deploy to production
	@echo "Deploying to production..."
	cd api && npm run deploy:prod

# Health Checks
health: ## Check API health
	cd api && npm run health

# Cleanup
clean: ## Clean all build artifacts and dependencies
	@echo "Cleaning API..."
	cd api && rm -rf node_modules package-lock.json
	@echo "Cleaning Flutter app..."
	cd app && flutter clean
	@echo "Cleanup complete!"

clean-api: ## Clean API only
	cd api && rm -rf node_modules package-lock.json

clean-app: ## Clean Flutter app only
	cd app && flutter clean

# Setup
setup: install ## Complete project setup
	@echo "Setting up environment..."
	@if [ ! -f api/.env ]; then cp api/env.example api/.env; echo "Created .env file from template"; fi
	@echo "Setup complete! Don't forget to configure your .env file."

# Documentation
docs: ## Generate API documentation
	@echo "API documentation available at http://localhost:3000/api-docs"
	@echo "Start the API server with 'make dev-api' to view docs"

# CI/CD helpers
ci-test: ## Run tests for CI environment
	cd api && npm run test:ci
	cd app && flutter test

ci-lint: ## Run linting for CI environment
	cd api && npm run lint
	cd app && flutter analyze

ci-build: ## Build for CI environment
	cd api && npm run build
	cd app && flutter build apk --release

