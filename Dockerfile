# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.10-slim

# Re scope of ARG/ENV variables:
# https://docs.docker.com/engine/reference/builder/#using-arg-variables
ARG PREFECT_API_KEY
ENV PREFECT_API_KEY=$PREFECT_API_KEY

ARG PREFECT_ACCOUNT_ID
ENV PREFECT_ACCOUNT_ID=$PREFECT_ACCOUNT_ID

ARG PREFECT_WORKSPACE_ID
ENV PREFECT_WORKSPACE_ID=$PREFECT_WORKSPACE_ID

ENV PREFECT_API_URL="https://api.prefect.cloud/api/accounts/$PREFECT_ACCOUNT_ID/workspaces/$PREFECT_WORKSPACE_ID"

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY src/. ./
RUN chmod +x ./wrapper_script.sh

# Install production dependencies.
# Note running pip as root gives a warning
RUN pip install --upgrade pip --no-cache-dir
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["./wrapper_script.sh"]
