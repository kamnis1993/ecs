resource "aws_appmesh_mesh" "testing" {
  name = "testomg"
}

resource "aws_appmesh_virtual_gateway" "testing" {
  name      = "testing"
  mesh_name = aws_appmesh_mesh.testing.name

  spec {
    listener {
      port_mapping {
        port     = 9080
        protocol = "http"
      }
    }
  }
}

resource "aws_appmesh_gateway_route" "testing" {
  name                 = "testing"
  mesh_name            = aws_appmesh_mesh.testing.name
  virtual_gateway_name = aws_appmesh_virtual_gateway.testing.name

  spec {
    http_route {
      action {
        target {
          virtual_service {
            virtual_service_name = aws_appmesh_virtual_service.testing.name
          }
        }
      }

      match {
        prefix = "/"
      }
    }
  }
}

resource "aws_appmesh_virtual_service" "testing" {
  name      = "exmaple"
  mesh_name = aws_appmesh_mesh.testing.id

  spec {
    provider {
      virtual_router {
        virtual_router_name = aws_appmesh_virtual_router.testing.name
      }
    }
  }
}

resource "aws_appmesh_virtual_router" "testing" {
  name      = "testing"
  mesh_name = aws_appmesh_mesh.testing.id

  spec {
    listener {
      port_mapping {
        port     = 80
        protocol = "http"
      }
    }
  }
}

resource "aws_appmesh_route" "testing" {
  name                = "testing"
  mesh_name           = aws_appmesh_mesh.testing.id
  virtual_router_name = aws_appmesh_virtual_router.testing.name

  spec {
    http_route {
      match {
        prefix = "/"
      }

      action {
        weighted_target {
          virtual_node = aws_appmesh_virtual_node.testing1.name
          weight       = 95
        }

        weighted_target {
          virtual_node = aws_appmesh_virtual_node.testing2.name
          weight       = 5
        }
      }
    }
  }
}

resource "aws_appmesh_virtual_node" "testing1" {
  name      = "testing1"
  mesh_name = aws_appmesh_mesh.testing.id

  spec {
    listener {
      port_mapping {
        port     = 80
        protocol = "http"
      }
      health_check {
        protocol            = "http"
        path                = "/"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout_millis      = 2000
        interval_millis     = 5000
      }
    }

    service_discovery {
      aws_cloud_map {
        namespace_name = aws_service_discovery_private_dns_namespace.testing.name
        service_name   = "testing1"
      }
    }

    logging {
      access_log {
        file {
          path = "/dev/stdout"
        }
      }
    }
  }
}

resource "aws_appmesh_virtual_node" "testing2" {
  name      = "testing2"
  mesh_name = aws_appmesh_mesh.testing.id

  spec {
    listener {
      port_mapping {
        port     = 80
        protocol = "http"
      }
      health_check {
        protocol            = "http"
        path                = "/"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout_millis      = 2000
        interval_millis     = 5000
      }
    }

    service_discovery {
      aws_cloud_map {
        namespace_name = aws_service_discovery_private_dns_namespace.testing.name
        service_name   = "testing2"
      }
    }

    logging {
      access_log {
        file {
          path = "/dev/stdout"
        }
      }
    }
  }
}

