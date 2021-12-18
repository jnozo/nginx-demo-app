output "cluster_name" {
  description = "EKS cluster name/ID"
  value       = module.eks.cluster_id
}