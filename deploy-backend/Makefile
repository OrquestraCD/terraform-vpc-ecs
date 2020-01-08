export TF_VAR_environment=dev

.PHONY: init

init::
	@terraform init
	@terraform workspace select $(TF_VAR_environment) || terraform workspace new $(TF_VAR_environment)
	@terraform plan
