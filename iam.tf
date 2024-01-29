data "aws_iam_policy" "ecs_task_execution-testing_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_execution-testing" {
#  source_json = data.aws_iam_policy.ecs_task_execution-testing_role_policy.policy

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "kms:Decrypt",
      "secretsmanager:GetSecretValue",
      "logs:CreateLogStream",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "cloudwatch:*",
      "xray:*"
    ]
    resources = ["*"]
  }
}

module "ecs_task_execution-testing_role" {
  source     = "./modules/iam_role"
  name       = "cstaskexecution-1"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution-testing.json
}

data "aws_iam_policy_document" "ecs_task" {
  statement {
    actions = [
      "ec2:Describe*",
      "autoscaling:Describe*",
      "ec2:CreateTags",
      "appmesh:*",
      "xray:*"
    ]
    resources = ["*"]
  }
}

module "ecs_task_role" {
  source     = "./modules/iam_role"
  name       = "ecstask"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task.json
}
