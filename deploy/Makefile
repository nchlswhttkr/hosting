.PHONY: *

venv := . .venv/bin/activate

install:
	@python3 -m venv .venv
	@$(venv) && python -m pip install --requirement requirements.txt
	@$(venv) && ansible-galaxy collection install --requirement ansible-requirements.yml