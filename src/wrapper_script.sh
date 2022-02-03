#!/bin/bash

# Environment variables must be present:
# PREFECT_CLOUD_API_KEY
# PREFECT_WORKSPACE

echo 'Logging in to Prefect Cloud'
prefect cloud login --key $PREFECT_CLOUD_API_KEY -w $PREFECT_WORKSPACE

# Use default local storage
echo 'Resetting storage to local'
prefect storage reset-default

echo 'Deploying flow'
prefect deployment create my_flow.py

echo 'Creating work-queue'
prefect work-queue create my_queue

echo 'Starting prefect agent'
prefect agent start my_queue

