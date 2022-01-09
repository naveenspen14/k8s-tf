
####### worker 

resource "aws_instance" "workerhost" {
  count = var.worker_count
  instance_type = var.instance_type
  ami = var.ami-id 
  subnet_id = var.public_subnet
  vpc_security_group_ids  = var.vpc_security_group_ids
#  iam_instance_profile = var.iam_worker_role
  iam_instance_profile = var.iam_role
  
  # we should take it as input parameter - no need to automate 
  # incase if someone want to import from their own keys
  key_name = var.aws_keyname

  lifecycle {
    create_before_destroy = true
  }  
  ebs_optimized = false
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }
  tags = {
    "Name" = "${var.worker_name}-${count.index}"
    "Description" = "HA worker Host"
    "Owner" = "AIRASIA"
    "kubernetes.io/cluster/${var.outposts_cluster_name}" = "owned"

  }

 provisioner "file" {
    # copying all files from conf/ folder
    source      = "scripts/" # my local code
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
      private_key = file(var.aws_keyfile)
      agent = false
      timeout = "5m"
      host = "${self.public_ip}"
    }

    inline = [
      "chmod +x worker_k8s.sh",
      "sleep 7",
      "bash /home/ubuntu/worker_k8s.sh > /home/ubuntu/worker_k8s.log",
      "sleep 180",
      "FINAL_JOIN_CMD=$(echo sudo ${var.expected_join_cmd})",
      "echo $FINAL_JOIN_CMD > /home/ubuntu/final_join_cmd.txt",
      "eval $FINAL_JOIN_CMD",
    ]

  }
}

resource "null_resource" "csi_lb_install" {
  
  count = var.master_count

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.aws_keyfile)
      agent = false
      timeout = "5m"
      host = var.master_public_ip
    }

    inline = [
      "kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/release-1.13/pkg/crd/manifests/csinodeinfo.yaml",
      "sleep 30",
      "kubectl apply -k github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-0.10",
      "sleep 30",
      "kubectl apply -f /home/ubuntu/storage-class.yaml",
      "sleep 10",
      "kubectl apply -f /home/ubuntu/cert-manager.yaml",
      "sleep 30",
    ]
  }
  depends_on = [aws_instance.workerhost]
}
