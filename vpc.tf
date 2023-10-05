module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"
  
  name = "TEJE_VPC"
  cidr = "10.0.0.0/16"

  azs = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"] #Recommended for Nodes
  public_subnets = ["10.0.4.0/24", "10.0.6.0/24"] #Necessary for Load Balancer
  map_public_ip_on_launch = true
  
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true #Required
  enable_dns_support = true #Required

  public_subnet_tags = {
    "kubernetes.io/cluster/$(var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = 1 #Necessary for load balancer
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/$(var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1 #Necessary for Load Balancer
  }
}