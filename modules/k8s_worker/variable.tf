
variable "access_key" {}
variable "secret_key" {}
variable "aws_keyfile" {}
variable "aws_keyname" {}
variable "public_subnet_zone" {}
variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type = string
  default = "airasia_auotmation_vpc2"

}

variable "aws_ig_name" {
  type = string
  default = "aws_ig_name"
}

variable "aws_master_sg" {
  type = string
  default = "airasia_master_sg"
}

variable "aws_worker_sg" {
  type = string
  default = "airasia_worker_sg"
}


variable "private_subnet_cidr_block" { 
  type = string
  default = "10.0.1.0/24"
}


variable "private_route_table_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "public_subnet_cidr" {
  type = string
  default = "10.0.0.0/24"
}


variable "ami-id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "iam_worker_role" {
  type = string
}


variable "worker_count" {}

variable "outposts_cluster_name" {
  type = string
  default = "airasiaclouds"
}

variable "ec2_user" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list
}
variable "public_subnet" {}

variable "expected_join_cmd" {
  type        = string
  description = "Command executed at worker to join worker to Kubernetes master"
}
variable "master_public_ip" {
  type        = string
}

variable "master_count" {}
variable "iam_role" {}
variable "worker_name" {}
