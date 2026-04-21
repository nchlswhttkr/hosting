.PHONY: *

venv := . .venv/bin/activate

init:
	@uv sync

inventory:
	@uv run inventory.py --list

upgrade:
	@uv sync --upgrade

clean:
	rm -rf .venv
