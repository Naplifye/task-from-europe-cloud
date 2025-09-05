variable "project_id" {
  description = "The project ID to host the cluster in"
  default     = "capable-hangout-470415-c7"
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "nodeapp-cluster"
}

variable "env_name" {
  description = "The environment for the GKE cluster"
  default     = "dev"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "zone" {
  description = "The zone to host the cluster in"
  default     = "us-central1-a"
}

variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "network"
}

variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
  default     = "subnet"
}

variable "machine_type" {
  description = "The machine type instance to use"
  default     = "e2-medium"
}