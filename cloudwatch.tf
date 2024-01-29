resource "aws_cloudwatch_log_group" "testing" {
  name              = "/ecs/testing"
  retention_in_days = 60
}
