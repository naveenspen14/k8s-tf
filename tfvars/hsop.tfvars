access_key = ""
secret_key = ""
aws_keyname = ""
aws_keyfile = ""
ec2_user = "ubuntu"
region = "us-west-2"
public_subnet_zone = "us-west-2a"
vpc_cidr_block = "172.21.0.0/16"
vpc_name = ""
aws_ig_name = "airasia_igw" 
aws_master_sg = "SG1"
aws_worker_sg = "SG2"
private_subnet_cidr_block = "172.21.21.0/24"
private_route_table_cidr = "0.0.0.0/0"
public_subnet_cidr = "172.21.22.0/24"
ami-id = "ami-090717c950a5c34d3"
instance_type = "m5.large"
iam_worker_role = "airasia-role-worker-01"
iam_master_role = "airasia-role-master-01"
master_count = "1"
master_name = "test_master"
worker_name = "test_worker"
worker_count = "1"
lb_count = "0"
minio_count = "0"
outposts_cluster_name = "airasiacloud"