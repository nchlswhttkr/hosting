.PHONY: *

venv := . ../.venv/bin/activate

export VAULT_TOKEN=$(shell pass show vault/root-token)

install:
	@$(venv) && python -m pip install --requirement requirements.txt
	@$(venv) && ansible-galaxy --quiet collection install --requirement ansible-requirements.yml

inventory:
	@$(venv) && ./inventory.py --list | jq

deploy:
	@$(venv) && ansible-playbook --inventory inventory.py deploy.yml

backup-plausible:
	@$(venv) && ansible-playbook --inventory inventory.py backup-plausible.yml --extra-vars "date='$$(date -u "+%Y-%m-%d %H:%M:%S")'"