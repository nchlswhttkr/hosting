.PHONY: *

export AWS_ACCESS_KEY_ID=$(shell pass show aws/terraform-backend-access-key)
export AWS_SECRET_ACCESS_KEY=$(shell pass show aws/terraform-backend-secret-key)
export VAULT_TOKEN=$(shell pass show vault/root-token)

apply: init
	@terraform apply

init:
	@terraform init

upgrade:
	@terraform init -upgrade

destroy: init
	@terraform destroy

shell: init
	@${SHELL}
