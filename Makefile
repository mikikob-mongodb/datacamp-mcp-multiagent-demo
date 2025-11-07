# --- Minimal Makefile ---

PY      ?= python3
VENV    ?= .venv
ACT     = . $(VENV)/bin/activate;
PORT    ?= 7860

.PHONY: setup run lint format clean clean-all kill-ports help

# Show available commands
help:
	@echo "📋 Available commands:"
	@echo "  make setup      - Create venv and install dependencies"
	@echo "  make run        - Run the application"
	@echo "  make lint       - Check code for issues"
	@echo "  make format     - Auto-fix and format code"
	@echo "  make clean      - Remove cache files"
	@echo "  make clean-all  - Remove cache files AND venv"
	@echo "  make kill-ports - Kill processes on port $(PORT)"
	@echo ""
	@echo "⚠️  After 'make clean-all', run 'deactivate' to exit the venv"

# Kill any processes using the app port
kill-ports:
	@echo "🔪 Killing processes on port $(PORT)..."
	@lsof -ti:$(PORT) | xargs kill -9 2>/dev/null || echo "✅ Port $(PORT) is free"

# create venv + install deps (app + dev linters/formatters)
setup: kill-ports
	@if [ -d "$(VENV)" ]; then \
		echo "⚠️  Virtual environment already exists. Run 'make clean-all' first if you want a fresh install."; \
		exit 1; \
	fi
	@echo "🔧 Creating virtual environment..."
	$(PY) -m venv $(VENV)
	@echo "📦 Installing packages..."
	$(ACT) pip install -U pip
	$(ACT) pip install python-dotenv pydantic pydantic-settings \
		langchain langchain-core langchain-openai langchain-community \
		langgraph langgraph-checkpoint-mongodb \
		mcp langchain-mcp-adapters \
		pymongo openai tiktoken \
		gradio fastapi uvicorn requests
	$(ACT) pip install ruff black isort
	@echo "✅ Setup complete! Run 'source $(VENV)/bin/activate' to activate."

# run the app (kills port first)
run: kill-ports
	@if [ ! -d "$(VENV)" ]; then \
		echo "❌ Virtual environment not found. Run 'make setup' first."; \
		exit 1; \
	fi
	$(ACT) $(PY) -m promotion_tycoon.main

# lint only (report issues)
lint:
	$(ACT) ruff check .

# auto-fix + format
format:
	$(ACT) ruff check --fix .
	$(ACT) isort .
	$(ACT) black .

# remove caches & build junk
clean:
	@echo "🧹 Cleaning cache files..."
	rm -rf __pycache__ */__pycache__ .pytest_cache .ruff_cache .mypy_cache .coverage .gradio outputs
	@echo "✅ Cache cleaned"

# full clean including venv
clean-all: clean
	@echo "🗑️  Removing virtual environment..."
	rm -rf $(VENV)
	@echo "✅ Full clean complete"
	@echo "⚠️  Run 'deactivate' in your shell to exit the venv"