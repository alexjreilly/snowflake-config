# Warn when if an undefined variable is used mainly to catch misspelled variables
MAKEFLAGS += --warn-undefined-variables

# This disables the bewildering array of built in rules to automatically build
# Yacc grammars out of your data if you accidentally add the wrong file suffix.
# Rules: https://www.gnu.org/software/make/manual/html_node/Catalogue-of-Rules.html
MAKEFLAGS += --no-builtin-rules

# Force Makefile to use Bash over Sh.
SHELL := /bin/bash

# The -c flag is in the default value of .SHELLFLAGS and we must preserve it,
# because it is how make passes the script to be executed to bash.
.SHELLFLAGS := -o errexit -o errtrace -o pipefail -o nounset -c

# Cancel out as not needed here.
.SUFFIXES:

# If no target is provided default to help.
.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "==========================================================="
	@echo "Data Platform - Infrastructure"
	@echo ""
	@echo "List of available recipes:"
	@echo "--------------------------"
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2> /dev/null \
		| awk -v RS= -F: '/^# File/,/^# Finished Make data base/ \
		{if ($$1 !~ "^[#.]") {print $$1}}' \
			| sort \
				| egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo "==========================================================="

#------------------------------
# Deploy
#------------------------------

.PHONY: deploy
deploy:
# deploy infrastructure with Terraform
	@echo "Deploying environment with Terraform..."
	@terraform apply
# Import Airflow pools from airflow_pools.json into Composer
	@$(MAKE) deploy-airflow-pools
# Patch the Airflow scheduler to run on a separate node pool
	@$(MAKE) deploy-patch-scheduler
	@echo "Done"
