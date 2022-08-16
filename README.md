# Run Prefect 2.0 in a docker container on Google Compute Engine

This guide will walk you through the process of setting up a Prefect 2.0 agent to run in a docker container on Google Compute Engine.  This provides a low-cost virtual machine for running your flows.

Note that this is different than using Prefect DockerContainer to run a single flow in a docker container.  Here, the agent itself runs in the docker we create here, and local process flows will also run in that docker.

Billing must be enabled for your GCP project.  If you are just experimenting, remember to delete the Compute Engine VM and other resources when you are done.

## Create a Service Account

In the Google Cloud Console, select "IAM & Admin" then "Service Accounts".  At the top, select "CREATE SERVICE ACCOUNT".  We will use the name "gce-prefect-sa".  Then select "CREATE AND CONTINUE". At the next step select the following roles to add: Artifact Registry Writer, Service Account User, and Compute Instance Admin (v1).  Keep track of the service account email address (will look something like gce-prefect-sa@PROJECT-ID.iam.gserviceaccount.com").

Look for your new service account in the table, and select "Manage keys" from the kebab menu at right.  Select "ADD KEY", then "Create New Key".  For key type, select JSON, then "CREATE".  The JSON file should download to your computer.  Keep that safe and we will use it later.  

## Github Action Secrets

IN your GitHub repo, click "Settings" then, under Security, "Secrets", then "Actions".  At the top, click the "New repository secret" to create the following secrets:

- GOOGLE_CLOUD_SA_KEY - Open the JSON key file created above.  Then copy/paste the entire text into the secret.
- GCE_SERVICE_ACCOUNT_EMAIL - the email address for the service account.
- PREFECT_API_KEY - Your API key from Prefect.  Click your profile on the lower left.  Then click "API Keys".  Create a new key.
- PREFECT_ACCOUNT_ID - your Prefect account number. Available in the Prefect URL after you login to the UI. It will be in the form https://app.prefect.cloud/account/[ACCOUNT-ID]/workspace/[WORKSPACE-ID]
- PREFECT_WORKSPACE_ID - See above. This is an ID, not the name of the workspace that displays in the UI.

## Create a Storage bucket, and a Prefect Block with that bucket

Back to the Google Cloud Console, select "Cloud Storage" then "buckets".  At the top, select "CREATE".  We will use the bucket name "prefect-block".  For lowest cost, select Location type "Region" and select the region closest to you geographically.  Select the lowest cost storage class for your usage.  For "Access Control", select "Uniform".  For "Protection tools", select None.  Then "CREATE".

Go to the bucket "PERMISSIONS" tab.  Click on "ADD" and enter the email address for your service account.  Under role, select "Storage Admin", then "SAVE".

Go to your Prefect UI dashboard and select "Blocks" then "Add Block".  Select GCS, then "Add Block".  We will use the name "gcs-block" and add a new GCS block. We will use the name "gcs-block".  For Bucket Path, put in the bucket name (above we used "prefect-block").

For the service account info, open the JSON file we downloaded earlier.  Select and copy all text (CTRL-A then CTRL-C in most environments).  Paste the text into the box (its a small box, so you will not be able to see most of it).  Then select "Create".

Delete the service account JSON on your local machine.

## Create a Google Cloud Artifact Repository

Go back to your Google Cloud console and select "Artifact Registry".  You may need to enable the API if you have not used it before.  Click the plus sign to create a new repository.  We will use the name "prefect-dockers".  Set the format to "docker" and set a region near you.  Use the Google-managed encryption key.  Then click "CREATE".  Once it is created, click the repository then select "SETUP INSTRUCTIONS".  Google will show you the credential helper command in the form like "gcloud auth configure-docker us-east1-docker.pkg.dev".  Note the hostname (the last value, here "us-east1-docker.pkg.dev").

Note that old Artifact Registry images do not expire.  If you are just experimenting with this repo, to avoid costs remember to come back and delete the new Artifact Registry repository that you just created.

## Enable Compute Engine

If you have not used it before with your current project, you'll need to enable the API.  Go to Compute Engine in the Google Cloud console, and select "ENABLE".

The compute engine has a significant monthly cost.  Delete the VM when done using it.

## Update the Github Actions YAML

Open the Github Actions YAML in this repository under `/.github/workflows/deploy-to-gce.yaml`.  Set the environmental variables as needed if you did not use the defaults shown above.

## Push to Github

After the Github Actions complete, it may take a few minutes for the Compute Engine to boot up, run the wrapper_script.sh, and run the flow (remember we are using the cheapest compute engine). To check on the Compute Engine, go to the instance on Google Cloud, click SSH to connect, then run:

```
docker ps -a
docker logs <CONTAINER-ID>
```
If everything seems to be running properly, go to the Prefect dashboard and run the flow.
