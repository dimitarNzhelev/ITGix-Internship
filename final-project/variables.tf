variable "SSH_PUBLIC_KEY" {
  description = "Public SSH key for OpenVPN instance to access other instances"
  type        = string
}

variable "SSH_PRIVATE_KEY" {
  description = "Private SSH key for OpenVPN instance to access other instances"
  type        = string
}

variable "ITGIX_PRIVATE_KEY" {
  description = "Private ITGIX SSH key for instances"
  type        = string
}

variable "gitlab_instance_url" {
  description = "GitLab instance URL"
  type        = string
}

variable "registration_token" {
  description = "GitLab Runner registration token"
  type        = string
}

variable "gitlab_runner_description" {
  description = "GitLab Runner description"
  type        = string
}