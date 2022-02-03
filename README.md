# Run Prefect 2.0 in a docker container on Google Compute Engine
Steps for setting this up.  After setup, push the code to your github repository and the Github Action will automatically run.

## Google Cloud Service Account
Should have at least the following roles: Artifact Registry Writer, Service Account User, and Compute Instance Admin.

## Google Cloud Artifact Repository
Create a new repository called "prefect-dockers" (or set a different name in .github/workflows/deploy-to-gce.yaml).  Set the format to "docker".  Once it is created, click SETUP INSTRUCTIONS to get the hostname of your repository (should be something like "us-east1-docker.pkg.dev").  Set that hostname in the YAML under GCP_ARTIFACT_REPOSITORY_HOSTNAME.

## Google Compute Engine
You'll need to specify a docker container when you create the Compute Engine.  The easiest way around this is to run the Github Action once to create the docker image.  The flow will fail since there is no Compute Engine to push to.  Then go to your Artifact Registry and get the URI for the docker image and use it to create the Compute Engine, then run the Action again.

Create a new compute Engine instance named "prefect-docker-instance" (or set a different name in the YAML).  Use the smallest machine (e.g., e2-micro) and remember to delete later to avoid charges.  Set the service accout to the one created above.  Click Deploy Container and enter the URI of a docker image (see above, this will be updated every time the Action runs).  Allow HTTPS traffic.  Set the value GCE_INSTANCE_ZONE in the YAML to the zone of your compute engine.

## Github Action Secrets
Create these secrets in Github:
* GOOGLE_CLOUD_SA_KEY - Create the JSON key, then copy/paste the entire text into the secret.
* PREFECT_CLOUD_API_KEY - your API key from the prefect.io
* PREFECT_WORKSPACE - the name of your Prefect workspace in the form <account/workspace_name>

