variable "aws_region" {
  description = "AWS Region"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "availability_zone" {
  description = "AWS Availability Zone"
  type        = string
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "key_name" {
  description = "AWS Key Pair Name"
  type        = string
}

variable "ssh_user" {
  description = "SSH Username"
  type        = string
}

variable "master_name" {
  description = "Master EC2 Name"
  type        = string
}
variable "worker_count" {
  description = "Number of Kubernetes worker nodes"
  type        = number
}
variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 30
}
