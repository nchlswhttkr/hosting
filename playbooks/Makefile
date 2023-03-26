.PHONY: *

venv := . ../.venv/bin/activate

export VAULT_TOKEN?=$(shell pass show vault/root-token)

# https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#running-on-macos
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

install:
	@$(venv) && python -m pip install --requirement requirements.txt
	@$(venv) && ansible-galaxy collection install --requirement ansible-requirements.yml

inventory:
	@$(venv) && ./inventory.py --list | jq

deploy:
	@$(venv) && ansible-playbook --inventory inventory.py deploy.yml

backup-plausible:
	@$(venv) && ansible-playbook --inventory inventory.py backup-plausible.yml --extra-vars "date_path='$$(date -u "+%Y/%m/%d/%H:%M:%S")'"