.DEFAULT_GOAL := full

.PHONY: init
init:
	terraform init

.PHONY: plan
plan:
	terraform plan -var-file="config.tfvars"

.PHONY: print
print:
	terraform output

.PHONY: create
create:
	terraform apply -var-file="config.tfvars"

.PHONY: destroy
destroy:
	terraform destroy -var-file="config.tfvars"
