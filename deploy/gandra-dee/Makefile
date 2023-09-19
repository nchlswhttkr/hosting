.PHONY: *

venv := . ../../.venv/bin/activate

export ANSIBLE_CONFIG=../ansible.cfg
export VAULT_TOKEN?=$(shell pass show vault/root-token)

# https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#running-on-macos
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

main:
	@$(venv) && ansible-playbook --inventory ../inventory.py main.yml

backup-plausible:
	@$(venv) && ansible-playbook --inventory ../inventory.py plausible/backup.yml
