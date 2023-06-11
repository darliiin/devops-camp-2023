.PHONY: all _dev _staging _prod

.DEFAULT_GOAL := help

# ----------------------------------------------------------------------------
# Local Variables
#
# ============================================================================
include .makerc

help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "⚡ \033[34m%-30s\033[0m %s\n", $$1, $$2}'

# ----------------------------------------------------------------------------
# Terraform helpers
#
# ============================================================================

# if you want to suppress the header, for example if you want to pipe into jq you can:
# QUIET=1 make _staging aws_secrets SECRET=CLIENT-staging-api-backend-secret | jq -r ".redis_db"
_environment: _validate
ifndef QUIET
	$(call header, EXEC ❱❱ ${MAKECMDGOALS} [${ENVIRONMENT} env])
endif


_validate:
ifndef ALLOWED_IP
	@echo "❗ You are not working through a VPN or outside of valid IPs to run terraform commands"
	@echo "❗ Your IP: ${MY_IP}"
	@echo "❗ List of approved IPs: ${ALLOWED_IPS}"
	@exit 1
endif
# ifndef AWS_REGION
# 	@echo "❗ You need to set AWS_DEFAULT_REGION var"
# 	@exit 1
# endif
	@if test "$(ENVIRONMENT)" = "" ; then \
		echo "ENVIRONMENT var is not set"; \
		exit 1; \
	fi
	@if ! test "$(EXPECTED_AWS_ACCOUNT_ID)" = "$(AWS_ACCOUNT_ID)" ; then \
		echo "❗ You're in a wrong AWS Account. You're expected to be in $(EXPECTED_AWS_ACCOUNT_ID) for $(PROJECT) $(ENVIRONMENT) environment"; \
		echo "❗ However you're in $(AWS_ACCOUNT_ID). Please adjust your aws-vault and ~/.aws/config" ; \
		exit 1; \
	fi

_dev: ## setup dev env (use: make _dev plan)
	@echo -n
	$(eval export EXPECTED_AWS_ACCOUNT_ID="707417709577")
	$(eval export ENVIRONMENT=dev)
	$(eval export DOMAIN=${ENVIRONMENT}.${DOMAIN})

_staging: ## setup staging env (use: make _staging plan)
	@echo -n
	$(eval export EXPECTED_AWS_ACCOUNT_ID="707417709577")
	$(eval export ENVIRONMENT=staging)
	$(eval export DOMAIN=${ENVIRONMENT}.${DOMAIN})

_prod: ## setup prod env (use: make _prod plan)
	@echo -n
	$(eval export EXPECTED_AWS_ACCOUNT_ID="707417709577")
	$(eval export ENVIRONMENT=prod)
	$(eval export DOMAIN=${DOMAIN})


# ----------------------------------------------------------------------------
# Terraform Commands
#
# ============================================================================

init: _environment ## terraform init against environment (use: make _staging init)
	terraform -chdir=terraform/${ENVIRONMENT} init -upgrade

plan: _environment ## terraform plan against environment (use: make _staging plan)
	terraform -chdir=terraform/${ENVIRONMENT} \
		plan -var-file=${ENVIRONMENT}.tfvars ${ARGS}

validate: _environment ## terraform validate against environment (use: make _staging validate)
	terraform -chdir=terraform/${ENVIRONMENT} \
		validate

apply: _environment ## terraform apply against environment (use: make _staging apply or make _staging apply ARGS="-target module.NAME....")
	terraform -chdir=terraform/${ENVIRONMENT} \
		apply -var-file=${ENVIRONMENT}.tfvars ${ARGS}

console: _environment ## terraform console against environment (use: make _staging console)
	terraform -chdir=terraform/${ENVIRONMENT} \
		console -var-file=${ENVIRONMENT}.tfvars

refresh: _environment ## terraform refresh against environment (use: make _staging refresh)
	terraform -chdir=terraform/${ENVIRONMENT} \
		refresh -var-file=${ENVIRONMENT}.tfvars

output: ## terraform refresh against environment (use: make _staging output ARGS="-json" | jq .git.value)
	@terraform -chdir=terraform/${ENVIRONMENT} \
		output $(ARGS)

providers: _environment ## terraform get a list of providers against environment (use: make _staging providers)
	terraform -chdir=terraform/${ENVIRONMENT} \
		providers

state: _environment ## terraform get sate list against environment (use: make _staging state)
	terraform -chdir=terraform/${ENVIRONMENT} \
		state list

rm: _environment ## terraform rm state (use: make _staging rm TARGET=module.NAME.resource.NAME)
	terraform -chdir=terraform/${ENVIRONMENT} \
		state rm '$(TARGET)'

destroy: ## terraform destroy (use: make _staging destroy TARGET=module.NAME.resource.NAME)
	@if test "$(TARGET)" = "" ; then \
		terraform -chdir=terraform/${ENVIRONMENT} \
			destroy -var-file=${ENVIRONMENT}.tfvars; \
		exit 0; \
	else \
		terraform -chdir=terraform/${ENVIRONMENT} \
			destroy -var-file=${ENVIRONMENT}.tfvars --target='$(TARGET)'; \
		exit 0; \
	fi

import: ## terraform import (use: make _staging import TARGET=terraform_resource_path VALUE=value)
	terraform -chdir=terraform/${ENVIRONMENT} \
		import -var-file=${ENVIRONMENT}.tfvars $(TARGET) ${VALUE}

fmt: _environment ## terraform code format (use: make _staging fmt)
	terraform fmt -recursive .

versions: _environment ## versions info (for github bug tickets) (use: make _staging versions)
	terraform -version
	@terraform -chdir=terraform/${ENVIRONMENT} \
		providers -version

tfcloud: _environment ## Open Terraform Cloud Workspace (use: make _staging tfcloud)
	xdg-open https://app.terraform.io/app/${TF_ORG}/workspaces/aws-infra-${ENVIRONMENT} > /dev/null 2>&1
