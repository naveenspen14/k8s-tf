resource "aws_iam_role" "outpost_master_role" {
  name               = "outpost-master-role"
  assume_role_policy = "${file("${path.module}/policies/assumerolepolicy.json")}"
}

resource "aws_iam_role" "outpost_worker_role" {
  name               = "outpost-worker-role"
  assume_role_policy = "${file("${path.module}/policies/assumerolepolicy.json")}"
}

resource "aws_iam_policy" "outpost_master_policy" {
  name        = "outpost-master-policy"
  description = "A test policy"
  policy      = "${file("${path.module}/policies/outpost_master_policy.json")}"
}

resource "aws_iam_policy" "outpost_worker_policy" {
  name        = "outpost-worker-policy"
  description = "A test policy"
  policy      = "${file("${path.module}/policies/outpost_worker_policy.json")}"
}

resource "aws_iam_policy_attachment" "master-attach" {
  name       = "master-attachment"
  roles      = ["${aws_iam_role.outpost_master_role.name}"]
  policy_arn = "${aws_iam_policy.outpost_master_policy.arn}"
}

resource "aws_iam_policy_attachment" "worker-attach" {
  name       = "worker-attachment"
  roles      = ["${aws_iam_role.outpost_worker_role.name}"]
  policy_arn = "${aws_iam_policy.outpost_worker_policy.arn}"
}


resource "aws_iam_instance_profile" "master_profile" {
  name  = "master_profile"
  role = aws_iam_role.outpost_master_role.name
}

resource "aws_iam_instance_profile" "worker_profile" {
  name  = "worker_profile"
  role = aws_iam_role.outpost_worker_role.name
}
