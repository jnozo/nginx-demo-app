# Generates a random string to aid in creating unique deployments.
resource "random_id" "name_suffix" {
  byte_length = 4
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = "${var.name}-${random_id.name_suffix.hex}"

  cidr            = var.vpc_cidr
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  azs = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1],
    data.aws_availability_zones.available.names[2],
  ]

  tags = {
    stack = "demo-app"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_version = var.eks_cluster_version
  cluster_name    = "${var.name}-${random_id.name_suffix.hex}"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  # Enabled to create a security group that can be allowed by the RDS security group.
  worker_create_security_group = true

  # Disabled for simplicity.
  manage_aws_auth  = false
  write_kubeconfig = false

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = var.eks_node_group_disk_size
  }

  node_groups = {
    workers = {
      min_capacity     = var.eks_node_group_min_capacity
      max_capacity     = var.eks_node_group_max_capacity
      desired_capacity = var.eks_node_group_desired_capacity

      instance_types = var.eks_node_group_instance_types
      capacity_type  = var.eks_node_group_capacity_type

      update_config = {
        max_unavailable_percentage = var.eks_node_group_max_unavailable_percentage
      }
    }
  }

  tags = {
    stack = "demo-app"
  }
}

module "mysql_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/mysql"
  version = "4.7.0"

  name        = "${var.name}-${random_id.name_suffix.hex}-mysql"
  description = "Security group to allow MySQL traffic within the VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.vpc_cidr]
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "3.4.1"

  identifier = "${var.name}-${random_id.name_suffix.hex}"

  engine               = var.rds_db_engine
  engine_version       = var.rds_db_engine_version
  family               = var.rds_db_family
  major_engine_version = var.rds_db_major_engine_version

  instance_class         = var.rds_instance_class
  allocated_storage      = var.rds_allocated_storage
  vpc_security_group_ids = [module.eks.worker_security_group_id]
  subnet_ids             = module.vpc.private_subnets

  name     = var.rds_db_name
  username = var.rds_admin_user
  password = var.rds_admin_password
  port     = var.rds_port

  maintenance_window = var.rds_maintenance_window
  backup_window      = var.rds_backup_window

  # Set for deployment simplicity.
  iam_database_authentication_enabled = true
  skip_final_snapshot                 = true
  deletion_protection                 = false

  tags = {
    stack = "demo-app"
  }
}
