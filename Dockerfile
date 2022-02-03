# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.10-slim

# Re scope of ARG/ENV variables:
# https://docs.docker.com/engine/reference/builder/#using-arg-variables
ARG PREFECT_CLOUD_API_KEY
ENV PREFECT_CLOUD_API_KEY=$PREFECT_CLOUD_API_KEY

ARG PREFECT_WORKSPACE
ENV PREFECT_WORKSPACE=$PREFECT_WORKSPACE

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
