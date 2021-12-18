Nginx Demo Sample Project
=====

This repo contains a minimum viable deployment of an EKS cluster and RDS with some sane defaults chosen, though far from optimized since this activity was timeboxed. The default settings will deploy an EKS cluster with a single worker node, enough to deploy the demo app, and a small MySQL RDS instance that is reachable by Kubernetes pods, though the demo app does not demonstrate this.

The infrastructure deployment settings can be configured by overriding existing variable values in the [terraform.tfvars](terraform/terraform.tfvars) (barebones example provided), but is not necessary.

The demo app settings can be configured by modifying the [values.yaml](helm/nginx-demo/values.yaml) file, but again, this is not necessary.

##	Deployment Instructions

### Prerequisites
- Helm
- Terraform
- aws-cli configured with access/secret key pair of an admin IAM user

### Deploy AWS resources
```
cd terraform
terraform init
terraform plan    # It should plan to create 51 resources.
terraform apply
```

The `terraform apply` operation will output the EKS cluster name at the end of a successful deployment. Alternatively, use the command below to find the cluster name after the fact.

```
aws eks list-clusters --query 'clusters[]' --output text | grep eks-demo
```

Fetch the kubeconfig and update your local config store using the command below.
```
aws eks update-kubeconfig --name <cluster_name>
```

### Install NGINX demo Helm chart
```
cd ../helm/nginx-demo
kubectl create namespace nginx-demo
kubectl config set-context --current --namespace=nginx-demo
helm install demo .

# Access the load balancer Service's "EXTERNAL-IP" field from the following command to check functionality.
kubectl get svc
```

### Uninstall NGINX demo Helm chart
```
helm uninstall demo
cd ../../terraform
terraform destroy
```

## Additional Questions

### The idea of your directory structure design. How do you keep it DRY?

This application is a bit too simplistic to demonstrate DRY principles so it is mostly flat. Generally speaking, I will structure both Terraform configurations and Helm charts in the manner suggested by the CI/CD tool(s) in use by the team. There isn't usually a layout that works across the board due to many tools being opinionated about how your directories should be laid out.

It's easy to fall into the trap of over-modularizing both Terraform and Helm code, so always a balance between DRY and KISS needs to be considered.

### What are the Terraform module(s) you created or used?

This uses the following modules:
- VPC
- EKS
- Security Groups (specifically MySQL)
- RDS

The community modules, while not flawless, provide efficiency and stability benefits versus creating your own from scratch. And if you find an issue that the community hasn't addressed, you can submit your own PRs to get things fixed relatively quickly.

### Does your design scale up to multiple environments within the same AWS account and multiple AWS accounts and regions?

Yes, you can deploy multiple environment with the same account and region. To specify the region, define the variable "aws_region" in the [terraform.tfvars](terraform/terraform.tfvars) file. If unspecified, it will default to us-west-2.

As for deploying to multiple accounts, if you have profiles set up in your aws-cli config file, you can specify the profile to deploy with by changing the "profile" value in [providers.tf](terraform/providers.tf#L17). Read more about [profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) here.

For either scenario, you will need to take care that you are not deploying multiple clusters using the same Terraform state file (terraform.tfstate(.backup)) since no backends are configured. The easiest way to do this would be to use fresh copies of this repo per cluster deployed to make sure one deployment doesn't clobber another.
