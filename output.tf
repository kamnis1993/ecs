output "ecs_cluster_testing_name" {
  value = aws_ecs_cluster.testing.name
}

output "ecs_service_testing1_name" {
  value = aws_ecs_service.testing1.name
}

output "ecs_service_testing2_name" {
  value = aws_ecs_service.testing2.name
}
