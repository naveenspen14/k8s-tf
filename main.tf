##### AIRASIA Outposts main.tf

terraform {
  required_version = "~> v1.0.1"
}

module "vpc" {
  source            = "./modules/vpc"
  outposts_cluster_name = "airasiacloud"
  public_subnet_zone = var.public_subnet_zone
}

module "security_group" {
  source            = "./modules/security_group"
  aws_worker_sg    = var.aws_worker_sg
  aws_master_sg    = var.aws_master_sg
  aws_keyname          = var.aws_keyname
  outposts_cluster_name = "airasiacloud"
  ami-id               = var.ami-id
  instance_type     = var.instance_type
  public_subnet_zone = var.public_subnet_zone
  access_key      = var.access_key
  secret_key      = var.secret_key
  aws_keyfile         = file(var.aws_keyfile)
  vpc_id          = module.vpc.vpc_id 
}

module "iam" {
  source            = "./modules/iam"
}


module "k8s_master" {
  source            = "./modules/k8s_master"
  master_count             = var.master_count
  master_name       = var.master_name
  aws_keyname          = var.aws_keyname
  ec2_user              = var.ec2_user
  outposts_cluster_name = "airasiacloud"
  ami-id               = var.ami-id
  instance_type     = var.instance_type
  iam_master_role = var.iam_master_role
  iam_role = module.iam.master_iam_name 
  public_subnet_zone = var.public_subnet_zone
  access_key      = var.access_key
  secret_key      = var.secret_key
  aws_keyfile         = var.aws_keyfile
  vpc_security_group_ids  = [module.security_group.master_security_id]
  public_subnet    = module.vpc.public_subnet
  keyfile          = var.aws_keyfile
}

module "k8s_worker" {
  source            = "./modules/k8s_worker"
  worker_count             = var.worker_count
  master_count             = var.master_count
  worker_name       = var.worker_name
  aws_keyname          = var.aws_keyname
  ec2_user              = var.ec2_user
  outposts_cluster_name = "airasiacloud"
  ami-id               = var.ami-id
  instance_type     = var.instance_type
  iam_worker_role = var.iam_worker_role
  iam_role = module.iam.worker_iam_name 
  public_subnet_zone = var.public_subnet_zone
  access_key      = var.access_key
  secret_key      = var.secret_key
  aws_keyfile         = var.aws_keyfile
  vpc_security_group_ids  = [module.security_group.worker_security_id]
  public_subnet    = module.vpc.public_subnet
  expected_join_cmd        = module.k8s_master.join_command
  master_public_ip = module.k8s_master.master_publicip[0]
}


module "k8s_haproxy" {
  source            = "./modules/k8s_haproxy"
  lb_count             = var.lb_count
  aws_keyname          = var.aws_keyname
  ec2_user              = var.ec2_user
  outposts_cluster_name = "airasiacloud"
  ami-id               = var.ami-id
  instance_type     = var.instance_type
  iam_worker_role = var.iam_worker_role
  iam_role = module.iam.worker_iam_name 
  public_subnet_zone = var.public_subnet_zone
  access_key      = var.access_key
  secret_key     = var.secret_key
  aws_keyfile         = file(var.aws_keyfile)
  vpc_security_group_ids  = [module.security_group.worker_security_id]
  public_subnet    = module.vpc.public_subnet
}

