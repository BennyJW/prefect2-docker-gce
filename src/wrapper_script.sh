#!/bin/bash

# Environment variables must be present:
# PREFECT_API_KEY
# PREFECT_API_URL

echo 'Deploying flow'
prefect deployment apply 'my_data_flow-deployment.yaml'

echo 'Starting prefect agent'
prefect agent start -t test

