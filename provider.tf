# aws provider 

#Set aws_access_key_id, aws_secret_access_key and region as ENV variables

provider "aws"{
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region 
}
