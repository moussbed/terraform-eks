provider "kubernetes" {
  load_config_file= "false"
  host = data.aws_eks_cluster.myapp_cluster.endpoint
  token = data.aws_eks_cluster_auth.myapp_cluster_auth.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp_cluster_auth.certificate_authority[0].data)
  
}
variable "cluster_name" {}
variable "cluster_version" { default = "1.21"}
variable "environment" {}
variable "app_name" {}

data "aws_eks_cluster" "myapp_cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "myapp_cluster_auth" {
  name = module.eks.cluster_id
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.5.0"
  # insert the 12 required variables here
  cluster_name =var.cluster_name
  cluster_version =var.cluster_version

  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id= module.myapp-vpc.vpc_id

  tags ={
      environment : var.environment
      application: var.app_name
  }


  # Worker nodes configuration
  eks_managed_node_groups = {
    "default" = {
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 2
      desired_size   = 2
      disk_size      = 50
      subnet_ids = module.myapp-vpc.private_subnets
      placement = {}
    }
}
  
}

