## Gerrit infra

variable "env_prefix" {
  description = "Prefix for resource names"
  default = ""
}

variable "master_vm_size" {
  description = "VM Size"
  default = "Standard_DS2_v2"
}

variable "data_disk_size_gb" {
  description = "Size of the disk containing Gerrit data (instanciated for each VM)"
  default = 512
}

variable "load_balancer" {
  description = "Provide a load balancer between master VM(s) and external interface or not"
  default = true
}

variable "master_nb" {
  description = "Total number of node in the highly-available cluster (so far, only 2 supported)"
  default = 1
}

variable "dev_vm" {
  description = "Provide a dev VM that gives access to the internal network"
  default = false
}

variable "config_url" {
  description = "Repository URL for this git module"
  default = "https://github.com/swi-infra/terraform-swi-gerrit.git"
}

variable "is_public" {
  description = "If true, load balancer is public, otherwise it is private"
  default = true
}

variable "gerrit_hostname" {
  description = "Hostname used to access the service"
}

## Azure

variable "resource_group" {
  description = "The name of the resource group in which to create the virtual network."
  default     = "gerrit-dev"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "westus"
}

variable "platform_update_domain_count" {
  default = "5"
}

variable "platform_fault_domain_count" {
  default = "3"
}

variable "virtual_network_name" {
  description = "The name for the virtual network."
  default     = "gerrit-network"
}

variable "subnet" {
  description = "The subnet used to host Gerrit servers"
  default = "gerrit-subnet"
}

variable "subnet_id" {
  description = "The subnet ID used to host Gerrit servers"
  default = "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/gerrit-subnet"
}

## VMs OS

variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
  default     = "CoreOS"
}

variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "CoreOS"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
  default     = "Stable"
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "administrator user name"
  default     = "core"
}

variable "admin_ssh_key" {
  description = "administrator ssh key"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAy4b4mjWHuN8Ckb9RL7/JQloGSwo5AQQTi2XgLJb1SOZSYggTro4GJbLi42+sUieCxNBWanpuUTuSdde7bcreSSp/S1m3ldtYeA/L+wfQErKsbJwhMtCWU2oU9WZKPUXkYVCPhe9dLnAbGc792RwFrsJTtWudqNC9dLqNuSAvZWiYuMzurWit1uyvFcR6eyNNSRa73riA5c//LHOA9PmRZup3QZUDfDJ8+buLzXfXfG9dzB0s9KAhNBZFYJb4UvpF2Vb2ArIZ2la9XNKIcMrSviLJCKn3tJh7CUyg4WwwdSZWMuBuYAcYbJDsmBskHfO22CATjqCfprm/LnceIzK6bw=="
}

## Gerrit env

variable "gerrit_ui" {
  description = "Gerrit UI default type"
  default     = "POLYGERRIT"
}

variable "gerrit_auth_type" {
  description = "Gerrit authentication type"
  default     = "OpenID_SSO"
}

# GitHub

variable "gerrit_oauth_github_client_id" {
  description = "GitHub client id"
  default     = ""
}

variable "gerrit_oauth_github_client_secret" {
  description = "GitHub client secret"
  default     = ""
}

# Office365

variable "gerrit_oauth_office365_client_id" {
  description = "Office365 client id"
  default     = ""
}

variable "gerrit_oauth_office365_client_secret" {
  description = "Office365 client secret"
  default     = ""
}

# Google

variable "gerrit_oauth_google_client_id" {
  description = "Google client id"
  default     = ""
}

variable "gerrit_oauth_google_client_secret" {
  description = "Google client secret"
  default     = ""
}

# BitBucket

variable "gerrit_oauth_bitbucket_client_id" {
  description = "BitBucket client id"
  default     = ""
}

variable "gerrit_oauth_bitbucket_client_secret" {
  description = "BitBucket client secret"
  default     = ""
}

# GitLab

variable "gerrit_oauth_gitlab_client_id" {
  description = "GitLab client id"
  default     = ""
}

variable "gerrit_oauth_gitlab_client_secret" {
  description = "GitLab client secret"
  default     = ""
}

# AirVantage

variable "gerrit_oauth_airvantage_client_id" {
  description = "airvantage client id"
  default     = ""
}

variable "gerrit_oauth_airvantage_client_secret" {
  description = "airvantage client secret"
  default     = ""
}

