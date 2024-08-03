resource "aws_iam_role" "ec2_multirole" {
  name = "ec2_multirole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "ec2_multirole"
    Task = "pcc-aws-proj2"
  }
}

resource "aws_iam_role_policy_attachment" "s3fullaccess_attachment" {
  role       = aws_iam_role.ec2_multirole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "buildadminaccess_attachment" {
  role       = aws_iam_role.ec2_multirole.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}

resource "aws_iam_role_policy_attachment" "commitaccess_attachment" {
  role       = aws_iam_role.ec2_multirole.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

resource "aws_iam_role_policy_attachment" "deployaccess_attachment" {
  role       = aws_iam_role.ec2_multirole.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}

resource "aws_iam_role_policy_attachment" "pipelineaccess_attachment" {
  role       = aws_iam_role.ec2_multirole.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatchaccess_attachment" {
  role       = aws_iam_role.ec2_multirole.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_instance_profile" "ec2_multirole_profile" {
  name       = "ec2_multirole_profile"
  role       = aws_iam_role.ec2_multirole.name
}

##-------------------------------------------------------
output "ec2_role" {
  value = aws_iam_role.ec2_multirole
}

output "ec2_role_profile" {
  value = aws_iam_instance_profile.ec2_multirole_profile
}
