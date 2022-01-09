####### Master 

resource "aws_instance" "masterhost" {
  count = var.master_count
  instance_type = var.instance_type
  ami = var.ami-id
  subnet_id = var.public_subnet
  vpc_security_group_ids  = var.vpc_security_group_ids
#  iam_instance_profile = var.iam_master_role
  iam_instance_profile = var.iam_role

  lifecycle {
    create_before_destroy = true
  }
  key_name = var.aws_keyname
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  ebs_optimized = false
  tags = {
    "Name" = "${var.master_name}-${count.index}"
    "Description" = "HA Master Host"
    "Owner" = "AIRASIA"
    "kubernetes.io/cluster/${var.outposts_cluster_name}" = "owned"

  }

 provisioner "file" {
    # copying all files from conf/ folder
    #source      = "./master_k8s.sh" # my local code
    source      = "scripts/"
    destination = "/home/ubuntu/"                      # remote server

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.aws_keyfile)
      agent = false
      timeout = "5m"
      host = "${self.public_ip}"
    }
  }

 provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file (var.aws_keyfile)
      agent = false
      timeout = "5m"
      host = "${self.public_ip}"
    }

    inline = [
      "chmod +x master_k8s.sh",
      "sleep 7",
      "bash /home/ubuntu/master_k8s.sh > /home/ubuntu/master_k8s.log",
      "sleep 120",
    ]
  }

}

data "external" "join_cmd" {
  program = ["python", "${path.module}/../../scripts/exdata.py"]

  query = {
    host = aws_instance.masterhost.*.public_ip[0]
    privatekey = "/root/airasia-automation_outposts.pem"
    #privatekey = ${aws_keyfile}
    user = "ubuntu" 
    #user = var.ec2_user
  }
  depends_on = [aws_instance.masterhost]
}

###### Downloading kubeconf file from master node ########

resource "null_resource" "download_kubeconfig_file" {
  provisioner "local-exec" {
    command = <<-EOF
    alias scp='scp -q -i ${var.aws_keyfile} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
    scp ubuntu@${aws_instance.masterhost.*.public_ip[0]}:/home/ubuntu/.kube/config /root/outpost_kubeconf >/dev/null
    EOF
  }
  depends_on = [aws_instance.masterhost]
}
