.PHONY: *

export AWS_ACCESS_KEY_ID=$(shell pass show aws/admin-access-key)
export AWS_SECRET_ACCESS_KEY=$(shell pass show aws/admin-secret-key)

apply: init
	@terraform apply

init:
	@terraform init

upgrade:
	@terraform init -upgrade	

destroy: init
	@terraform destroy
