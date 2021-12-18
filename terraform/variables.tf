###############################################################################
# General
###############################################################################
variable "name" {
  description = "Identifier prefix for all created resources."
  type        = string
  default     = "eks-test"
}

###############################################################################
# AWS
###############################################################################
variable "aws_region" {
  description = "Manage AWS resources in this region."
  type        = string
  default     = "us-west-2"
}

###############################################################################
# VPC
###############################################################################
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnets" {
  description = "Public subnets in the VPC."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
}

variable "vpc_private_subnets" {
  description = "Public subnets in the VPC."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

###############################################################################
# EKS
###############################################################################
variable "eks_cluster_version" {
  description = "Kubernetes control plane version."
  type        = string
  default     = "1.21"
}

variable "eks_node_group_disk_size" {
  description = "Default root disk size for managed worker nodes in GB."
  type        = number
  default     = 50
}

variable "eks_node_group_desired_capacity" {
  description = "Node group ASG desired capacity value."
  type        = number
  default     = 1
}

variable "eks_node_group_min_capacity" {
  description = "Node group ASG minimum capacity value."
  type        = number
  default     = 1
}

variable "eks_node_group_max_capacity" {
  description = "Node group ASG maxiumum capacity value."
  type        = number
  default     = 3
}

variable "eks_node_group_instance_types" {
  description = "Desired instance types."
  type        = list(string)
  default     = ["t3.small"]
}

variable "eks_node_group_capacity_type" {
  description = "ON_DEMAND or SPOT."
  type        = string
  default     = "SPOT"
}

variable "eks_node_group_max_unavailable_percentage" {
  description = "Max percentage of unavailable nodes in the ASG tolerated."
  type        = number
  default     = 50
}

###############################################################################
# RDS
###############################################################################
variable "rds_db_engine" {
  description = "RDS database type."
  type        = string
  default     = "mysql"
}

variable "rds_db_engine_version" {
  description = "RDS database engine version. Refer to AWS documentation for available versions."
  type        = string
  default     = "8.0.27"
}

variable "rds_instance_class" {
  description = "RDS instance type."
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "RDS instance disk size in GB. Minimum 20 GB."
  type        = number
  default     = 20
}

variable "rds_db_name" {
  description = "Database name. Alphanumeric characters only."
  type        = string
  default     = "demoapp"
}

variable "rds_port" {
  description = "Database port."
  type        = number
  default     = 3306
}

variable "rds_admin_user" {
  description = "Database admin username."
  type        = string
  default     = "demoadmin"
  sensitive   = true
}

variable "rds_admin_password" {
  description = "Database admin password."
  type        = string
  default     = "demopass543"
  sensitive   = true
}

variable "rds_maintenance_window" {
  description = "Datetime for RDS to perform automated maintenance."
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "rds_backup_window" {
  description = "Time for RDS to run daily backups."
  type        = string
  default     = "03:00-06:00"
}

variable "rds_db_family" {
  description = "Database family."
  type        = string
  default     = "mysql8.0"
}

variable "rds_db_major_engine_version" {
  description = "Database major engine version."
  type        = string
  default     = "8.0"
}
