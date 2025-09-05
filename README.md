# task-from-europe-cloud

Task:
We would like you to construct an autoscaling solution on GKE for the node application.
The requirements for this task are as follows:
1. MongoDB replica set installed on 3 instances (not GKE) - master, slave, arbiter
2. Nodeapp code should be updated to use the replica set instead of a single server
3. Nodeapp should be deployed on GKE with autoscaling and should scale from 2 to 10 pods.
4. Nodeapp should be exposed with an ingress with HTTP and HTTPS (a self-signed certificate can be used for HTTPS)

Please make sure to document the whole process and if you get stuck at any moment and have questions, feel free to ask
You can find the relevant files - at https://drive.google.com/drive/folders/1lNV7FNjYppSwABaJoczgRq95bI8w7wRB?usp=share_link
Please use the GCP project using your own Gmail account with the 300$ free credit- https://cloud.google.com/free

Notes:
- Avoid using Marketplace & GKE autopilot.
- Please use e2-medium instances for mongo and for gke.

No need in "heavy" instances.
Time limit: 7 calendar days

# Tasks 1 by 1:

	Requirments: use e2-medium instances and not GKE
	Avoid: Marketplace & GKE autopilot.

## Overview
We'll be downloading components and creating credentials so we can connect to GCP via Terraform
## Step 1: Download Terraform, Google SDK, Kubectl via brew
<details>
  <summary>google sdk install</summary>

```
brew install --cask gcloud-cli
```

</details>

<details>
  <summary>terraform install</summary>

```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

</details>

<details>
  <summary>kubectl install</summary>

```
brew install kubernetes-cli
```

</details>

## Step 2: Setup google sdk
<details><summary>setup google sdk </summary>

```
 gcloud init
```

 Follow prompts in browser
 
 Pick cloud project to use: 
 [1] capable-hangout-470415-c7


```
 gcloud auth application-default login
```
Follow prompts in browser
</details>

## Step 3: Create Service Account for Terraform
 
<details><summary>create service account for terraform</summary>

```
gcloud iam service-accounts create terraform
gcloud projects add-iam-policy-binding capable-hangout-470415-c7 --member="serviceAccount:terraform@capable-hangout-470415-c7.iam.gserviceaccount.com" --role=roles/editor
gcloud iam service-accounts add-iam-policy-binding terraform@capable-hangout-470415-c7.iam.gserviceaccount.com --member="user:scyoube1@gmail.com" --role=roles/iam.serviceAccountUser
```
</details>

## Step 4: Install auth plugins for google, so it can connect to gke cluster

<details>
  <summary>auth plugins install</summary>

```
gcloud components install gke-gcloud-auth-plugin
```

</details>

## Overview
Next step is to connect via Terrform to GCP and provision our infrastrucure

## Step 1: Clone the repo task-from-europe-cloud

<details>
  <summary>clone the repo</summary>

```
git clone https://github.com/Naplifye/task-from-europe-cloud.git
```

</details>

## Step 2: change directory to task-from-europe-cloud

<details>
  <summary>change directory</summary>

```
cd task-from-europe-cloud
```

</details>

## Step 3: Create infrastructure via Terraform

<details>
  <summary>terraform commands</summary>

Init Terraform

```
terraform init
```
Plan the infrastrucure

```
terraform plan
```
Apply the infrastrucure
```
terraform apply
```

</details>

## Step 4: After terraform is ready you will have output similar to the one shown below, this means we are ready with provisioning of our infrastructure in GCP

<details>
  <summary>terraform output</summary>

```
cluster_name = "nodeapp-cluster-dev"
gke_public_up = [
  "34.49.58.137",
]
mongodb_public_ip = {
  "mongodb" = "35.192.197.245"
}
```

</details>

## Overview
Next step is to connect via Ansible to provision our VM infrastrucure just made by Terraform in GCP

## Step 1: Copy the ssh keys in terraform folder .ssh to ansible-playbook folder ssh-keys, so we can connect via Ansible to mongodb VM to provision it

<details>
  <summary>cp ssh keys</summary>

From the root of the directory
```
cp terraform/.ssh/google_compute_engine ansible-playbook/ssh-keys/ 
```

</details>

## Step 2: Change IP address for mongodb VM in ```ansible-playbook/inventory/mongodb.yml``` to the one from Terraform output mongodb_public_ip that was shown after terraform apply, so Ansible can connect via ssh

## Step 3: Your GCP user in VMs will differ, for example mine is scyoube1, you will have a different one so change files to your name:

<details>
  <summary>files to change</summary>

Change remote_user to your username
```
vim ansible-playbook/ansible.cfg

```
Copy mongodb files to remote server and Run docker-compose up must be changed
```
vim ansible-playbook/mongodb-deploy.yml 

```

</details>

## Step 4: Run ansible playbook from directory ansible-playbook to provision mongodb VM

<details>
  <summary>ansible-playbook</summary>

```
cd ansible-playbook

```

```
ansible-playbook -i inventory/mongodb.yml mongodb-deploy.yml 

```

</details>

## Overview
Next step is to connect via Ansible to provision our GKE infrastrucure just made by Terraform in GCP

## Step 1: Get credentials for the GKE cluster we created via ansible
<details>
  <summary>gke credentials</summary>

```
gcloud container clusters get-credentials nodeapp-cluster-dev --region us-central1

```

</details>

## Step 2: In order for the cluster to connect to the backend (mongodb VM) we have to change IP addresses in the playbook ansible-playbook/nodeapp-deploy.yml to the output of terraform apply for mongodb_public_ip

<details>
  <summary>edit files</summary>

Look for lines MONGODB_MASTER,MONGODB_SLAVE,MONGODB_ARBITER and change the ip to the output of terraform apply for mongodb_public_ip
```
vim ansible-playbook/nodeapp-deploy.yml 

```

</details>

## Step 3: Run ansible playbook from directory ansible-playbook to provision GKE cluster everything is done from the ```local machine```

<details>
  <summary>ansible-playbook</summary>

```
cd ansible-playbook

```

```
ansible-playbook nodeapp-deploy.yml 

```
</details>

## Finished
If everything is good we should see something on the ip provided by terraform for static_ip_gke, if we don't know it we can check via:

<details>
  <summary>check ip</summary>

```
kubectl get ingress ingress -n nodeapp-dev
```
</details>


## Example: https://34.95.107.164




