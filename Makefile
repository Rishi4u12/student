# Configuration, override port with usage: make PORT=4610
PORT ?= 4600
REPO_NAME ?= student
LOG_FILE = /tmp/jekyll$(PORT).log
HOST ?= 0.0.0.0
# Localhost URL (works when Windows<->WSL localhost forwarding is enabled)
URL = http://localhost:$(PORT)/$(REPO_NAME)/
# Compute WSL IPv4 address (first non-loopback address); fallback to 127.0.0.1 if not found
WSL_IP := $(shell ip -4 addr 2>/dev/null | awk '/inet / && $$NF!="lo" {print $$2}' | cut -d/ -f1 | head -n1)
WINURL = http://$(if $(WSL_IP),$(WSL_IP),127.0.0.1):$(PORT)/$(REPO_NAME)/

SHELL = /bin/bash -c
.SHELLFLAGS = -e # Exceptions will stop make, works on MacOS

# Phony Targets, makefile housekeeping for below definitions
.PHONY: default server csp cspserver issues convert convert-one clean stop reload refresh url open winurl winopen

# List all .ipynb files in the _notebooks directory
NOTEBOOK_FILES := $(shell find _notebooks -name '*.ipynb' 2>/dev/null)
CSP_NOTEBOOK_FILES := $(shell find _notebooks/CSP -name '*.ipynb' 2>/dev/null)

# Specify the target directory for the converted Markdown files
DESTINATION_DIRECTORY = _posts
MARKDOWN_FILES := $(patsubst _notebooks/%.ipynb,$(DESTINATION_DIRECTORY)/%_IPYNB_2_.md,$(NOTEBOOK_FILES))
CSP_MARKDOWN_FILES := $(patsubst _notebooks/CSP/%.ipynb,$(DESTINATION_DIRECTORY)/%_IPYNB_2_.md,$(CSP_NOTEBOOK_FILES))

default: server
	@echo "Terminal logging starting, watching server..."
	@# Launch watcher to trigger per-file conversion when notebooks change
	@nohup bash scripts/watch_jekyll_log.sh $(LOG_FILE) '_notebooks/.*\.ipynb' >/dev/null 2>&1 &
	@# start an infinite loop with timeout to check log status
	@for ((COUNTER = 0; ; COUNTER++)); do \
		if grep -q "Server address:" $(LOG_FILE); then \
			echo "Server started in $$COUNTER seconds"; \
			break; \
		fi; \
		if [ $$COUNTER -eq 60 ]; then \
			echo "Server timed out after $$COUNTER seconds."; \
			echo "Review errors from $(LOG_FILE)."; \
			cat $(LOG_FILE); \
			exit 1; \
		fi; \
		sleep 1; \
	done
	@# outputs startup log, removes last line ($$d) as ctl-c message is not applicable for background process
	@sed '$$d' $(LOG_FILE)

csp: cspserver
	@echo "ONLY COMPILED CSP CONTENT"
	@echo "Terminal logging starting, watching server..."
	@nohup bash scripts/watch_jekyll_log.sh $(LOG_FILE) '_notebooks/CSP/.*\.ipynb' >/dev/null 2>&1 &
	@# start an infinite loop with timeout to check log status
	@for ((COUNTER = 0; ; COUNTER++)); do \
		if grep -q "Server address:" $(LOG_FILE); then \
			echo "Server started in $$COUNTER seconds"; \
			break; \
		fi; \
		if [ $$COUNTER -eq 60 ]; then \
			echo "Server timed out after $$COUNTER seconds."; \
			echo "Review errors from $(LOG_FILE)."; \
			cat $(LOG_FILE); \
			exit 1; \
		fi; \
		sleep 1; \
	done
	@# outputs startup log, removes last line ($$d) as ctl-c message is not applicable for background process
	@sed '$$d' $(LOG_FILE)


# Start the local web server
server: stop
	@echo "Starting server..."
	@nohup bundle exec jekyll serve -H $(HOST) -P $(PORT) > $(LOG_FILE) 2>&1 & \
		PID=$$!; \
		echo "Server PID: $$PID"
	@until [ -f $(LOG_FILE) ]; do sleep 1; done

cspserver: stop
	@echo "Starting server..."
	@nohup bundle exec jekyll serve -H $(HOST) -P $(PORT) > $(LOG_FILE) 2>&1 & \
		PID=$$!; \
		echo "Server PID: $$PID"
	@until [ -f $(LOG_FILE) ]; do sleep 1; done

# Convert .ipynb files to Markdown with front matter (explicit use only)
convert: $(MARKDOWN_FILES)
cspconvert: $(CSP_MARKDOWN_FILES)

# Convert .ipynb files to Markdown with front matter, preserving directory structure (single-file)
$(DESTINATION_DIRECTORY)/%_IPYNB_2_.md: _notebooks/%.ipynb
	@echo "Converting source $< to destination $@"
	@mkdir -p $(@D)
	@python3 -c 'import sys; from scripts.convert_notebooks import convert_single_notebook; convert_single_notebook(sys.argv[1])' "$<"

# Convert one notebook on demand: make convert-one ONE_FILE=path/to/notebook.ipynb
convert-one:
	@if [ -z "$(ONE_FILE)" ]; then echo "Usage: make convert-one ONE_FILE=path/to/notebook.ipynb"; exit 1; fi
	@python3 -c 'import sys; from scripts.convert_notebooks import convert_single_notebook; convert_single_notebook(sys.argv[1])' "$(ONE_FILE)"

# Clean up project derived files, to avoid run issues stop is dependency
clean: stop
	@echo "Cleaning converted IPYNB files..."
	@find _posts -type f -name '*_IPYNB_2_.md' -exec rm {} +
	@echo "Cleaning Github Issue files..."
	@find _posts -type f -name '*_GithubIssue_.md' -exec rm {} +
	@echo "Removing empty directories in _posts..."
	@while [ $$(find _posts -type d -empty | wc -l) -gt 0 ]; do \
		find _posts -type d -empty -exec rmdir {} +; \
	done
	@echo "Removing _site directory..."
	@rm -rf _site


# Stop the server and kill processes
stop:
	@echo "Stopping server..."
	@# kills process running on port $(PORT)
	@@lsof -ti :$(PORT) | xargs kill >/dev/null 2>&1 || true
	@echo "Stopping logging process..."
	@# kills previously running logging processes
	@@ps aux | awk -v log_file=$(LOG_FILE) '$$0 ~ "tail -f " log_file { print $$2 }' | xargs kill >/dev/null 2>&1 || true
	@# removes log
	@rm -f $(LOG_FILE)

# stops the server and reloads it
reload:
	@make stop
	@make

# stops server, cleans it, reloads it
refresh:
	@make stop
	@make clean
	@make

# Print the local URL to access the site
url:
	@echo $(URL)
	@echo "WSL IP URL: $(WINURL)"

# Open the local URL using a platform-appropriate opener (WSL/desktop Linux)
open:
	@echo "Opening $(WINURL)"
	@if command -v wslview >/dev/null 2>&1; then \
		wslview "$(WINURL)"; \
	elif command -v xdg-open >/dev/null 2>&1; then \
		xdg-open "$(WINURL)" >/dev/null 2>&1 || true; \
	else \
		echo "Please open $(WINURL) in your browser."; \
	fi

# Explicit targets for Windows/WSL users
winurl:
	@echo $(WINURL)

winopen:
	@echo "Opening $(WINURL)"
	@if command -v wslview >/dev/null 2>&1; then \
		wslview "$(WINURL)"; \
	else \
		echo "Install wslu (wslview) or open manually: $(WINURL)"; \
	fi
