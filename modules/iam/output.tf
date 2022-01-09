output "master_iam_name" {
value = aws_iam_instance_profile.master_profile.name
}

output "worker_iam_name" {
value = aws_iam_instance_profile.worker_profile.name
}
