# Run Prefect 2.0 in a docker container on Google Compute Engine

Steps for setting this up. After setup, push the code to your github repository and the Github Action will automatically run.

## Google Cloud Service Account

Should have at least the following roles: Artifact Registry Writer, Service Account User, and Compute Instance Admin (v1).

## Create a Google Cloud Storage bucket, and a Prefect GCS Block

Create a bucket in GCS. Go to bucket permissions and add Storage Admin Access for the Service Account created above.

Go to the Prefect UI and add a new GCS block. Give your block a name.  Put in the service account keyfile as a JSON string.  Copy the name into the YAML under PREFECT_GCS_BLOCK_NAME.

## Google Cloud Artifact Repository

Create a new repository called "prefect-dockers" (or set a different name in the YAML). Set the format to "docker" and set a region. Once it is created, click SETUP INSTRUCTIONS to get the hostname of your repository (should be something like "us-east1-docker.pkg.dev"). Set that hostname in the YAML under GCP_ARTIFACT_REPOSITORY_HOSTNAME.

## Github Action Secrets

Create these secrets in Github:

- GOOGLE_CLOUD_SA_KEY - See above regarding the necessary roles. Create the JSON key, then copy/paste the entire text into the secret.
- GCE_SERVICE_ACCOUNT_EMAIL - the email address for the service account
- PREFECT_API_KEY - your API key from Prefect
- PREFECT_ACCOUNT_ID - your Prefect account number. Available in the Prefect URL after you login to the UI. It will be in the form https://app.prefect.cloud/account/[ACCOUNT-ID]/workspace/[WORKSPACE-ID]
- PREFECT_WORKSPACE_ID - See above. This is an ID, not the name of the workspace that displays in the UI.

## Push to Github

After the Github Actions complete, it may take a few minutes for the Compute Engine to fire up and run the wrapper_script.sh to deploy the flow. To check on the Compute Engine, go to the VM instances on Google Cloud, click SSH to connect, then run:

```
docker ps -a
docker logs <CONTAINER-ID>
```
