resource "aws_service_discovery_private_dns_namespace" "testing" {
  name        = "testing.internal"
  description = "testing"
  vpc         = module.vpc.vpc_id
}

resource "aws_service_discovery_service" "testinggw" {
  name = "testinggw"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.testing.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "testing1" {
  name = "testing1"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.testing.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "testing2" {
  name = "testing2"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.testing.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

