resource "aws_ecs_cluster" "testing" {
  name = "testing"
}

resource "aws_ecs_task_definition" "testinggw" {
  family                   = "testinggw"
  cpu                      = "8192"
  memory                   = "16384"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = module.ecs_task_role.iam_role_arn
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
  container_definitions    = data.template_file.container_definition_testinggw.rendered
}

resource "aws_ecs_service" "testinggw" {
  name                              = "testinggw"
  cluster                           = aws_ecs_cluster.testing.arn
  task_definition                   = aws_ecs_task_definition.testinggw.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.nginx.id]

    subnets = module.vpc.private_subnets
  }

  service_registries {
    registry_arn = aws_service_discovery_service.testinggw.arn
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.testing.arn
    container_name   = "envoy"
    container_port   = 9080
  }
}

data "template_file" "container_definition_testinggw" {
  template = file("./container_definitions/testinggw.tpl")
  vars = {
    appmesh_virtual_node_name = "mesh/${aws_appmesh_mesh.testing.name}/virtualGateway/${aws_appmesh_virtual_gateway.testing.name}"
  }
}

resource "aws_ecs_task_definition" "testing1" {
  family                   = "testing1"
  cpu                      = "8192"
  memory                   = "16384"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = module.ecs_task_role.iam_role_arn
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
  container_definitions    = data.template_file.container_definition_testing1.rendered

  proxy_configuration {
    type           = "APPMESH"
    container_name = "envoy"
    properties = {
      AppPorts         = 80
      EgressIgnoredIPs = "169.254.170.2,169.254.169.254"
      IgnoredUID       = "1337"
      ProxyEgressPort  = 15001
      ProxyIngressPort = 15000
    }
  }
}

resource "aws_ecs_service" "testing1" {
  name             = "testing1"
  cluster          = aws_ecs_cluster.testing.arn
  task_definition  = aws_ecs_task_definition.testing1.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.nginx.id]

    subnets = module.vpc.private_subnets
  }

  service_registries {
    registry_arn = aws_service_discovery_service.testing1.arn
  }
}

data "template_file" "container_definition_testing1" {
  template = file("./container_definitions/testing.tpl")
  vars = {
    nginx_image               = "public.ecr.aws/nginx/nginx:stable-perl"
    appmesh_virtual_node_name = "mesh/${aws_appmesh_mesh.testing.name}/virtualNode/${aws_appmesh_virtual_node.testing.name}"
  }
}

resource "aws_ecs_task_definition" "testing2" {
  family                   = "testing2"
  cpu                      = "8192"
  memory                   = "16384"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = module.ecs_task_role.iam_role_arn
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
  container_definitions    = data.template_file.container_definition_testing2.rendered

  proxy_configuration {
    type           = "APPMESH"
    container_name = "envoy"
    properties = {
      AppPorts         = 80
      EgressIgnoredIPs = "169.254.170.2,169.254.169.254"
      IgnoredUID       = "1337"
      ProxyEgressPort  = 15001
      ProxyIngressPort = 15000
    }
  }
}

resource "aws_ecs_service" "testing2" {
  name             = "testing2"
  cluster          = aws_ecs_cluster.testing.arn
  task_definition  = aws_ecs_task_definition.testing2.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.nginx.id]

    subnets = module.vpc.private_subnets
  }

  service_registries {
    registry_arn = aws_service_discovery_service.testing2.arn
  }
}

data "template_file" "container_definition_testing2" {
  template = file("./container_definitions/testing.tpl")
  vars = {
    nginx_image               = "public.ecr.aws/nginx/nginx:stable-perl"
    appmesh_virtual_node_name = "mesh/${aws_appmesh_mesh.testing.name}/virtualNode/${aws_appmesh_virtual_node.testing.name}"
  }
}

resource "aws_security_group" "nginx" {
  name        = "testingnginx-sg"
  description = "nginx security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
