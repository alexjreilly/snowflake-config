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

# Import Airflow pools from airflow_pools.json into Composer
.PHONY: deploy-airflow-pools
deploy-airflow-pools:

# Import Airflow pools using airflow_pools.json
# airflow_pools.json copied to the GCS bucket (data/config/airflow_pools.json) by Terraform
	@echo "Importing Airflow pools..."
	@gcloud composer environments run $$(terraform output -raw COMPOSER_environment_id) pool -- -i /home/airflow/gcs/data/config/airflow_pools.json

# Patch the Airflow scheduler to run on a separate node pool
# Gives more resources to the scheduler without starving other workloads running on the node
# Allows us to choose a different machine type for the scheduler as for the Airflow workers
# Because the scheduler is put under heavy load during DAGs with many tasks
.PHONY: deploy-patch-scheduler
deploy-patch-scheduler:
# set up kubeconfig so we can run kubectl commands to patch
	@echo "Setting up credentials for the Composer Kubernetes cluster..."
	@gcloud container clusters get-credentials --zone=us-east4-a $$(terraform output -raw COMPOSER_gke_cluster_shortname) --project $$(terraform output -raw COMPOSER_project_id)
# patch airflow scheduler to run in separate node pool
# (change nodeSelector field to from 'default-pool' to 'scheduler-pool')
	@echo "Patching the Airflow scheduler to run in a separate node pool..."
	@kubectl patch deployment airflow-scheduler -n $$(kubectl get ns -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}'| grep composer) --patch "$$(cat $(CURDIR)/scheduler-patch.yml)"
# We need the composer-fluentd-daemon to run on the scheduler-pool as well
# By default it is only set to run on the default-pool
# check if composer-fluentd-daemon has a nodepool specified
# if yes, remove nodeSelector
	@echo "Checking if composer-fluentd-daemon (logging agent) is set to run on all nodes..."
	@if kubectl get ds composer-fluentd-daemon -o jsonpath='{.spec.template.spec.nodeSelector}' | grep -q 'cloud.google.com/gke-nodepool'; then \
		echo "composer-fluentd-daemon not set to run on Airflow scheduler node. Patching..."; \
		kubectl patch ds composer-fluentd-daemon --type='json' -p='[{"op": "remove", "path": "/spec/template/spec/nodeSelector"}]'; \
	fi
	@echo "Done"

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
