###############################################################################
# AWS Data Sources
###############################################################################
data "aws_availability_zones" "available" {
  state = "available"
}

###############################################################################
# EKS Data Sources
###############################################################################
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}