[
  {
    "name": "web",
    "image": "${nginx_image}",
    "essential": true,
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/testing",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "app"
      }
    },
    "dependsOn": [
      {
        "containerName": "envoy",
        "condition": "HEALTHY"
      }
    ]    
  },
  {
    "name": "envoy",
    "image": "840364872350.dkr.ecr.ap-northeast-1.amazonaws.com/aws-appmesh-envoy:v1.19.1.0-prod",
    "user": "1337",
    "essential": true,
    "ulimits": [
      {
        "name": "nofile",
        "hardLimit": 15000,
        "softLimit": 15000
      }
    ],
    "portMappings": [
      {
        "containerPort": 9901,
        "hostPort": 9901,
        "protocol": "tcp"
      },
      {
        "containerPort": 15000,
        "hostPort": 15000,
        "protocol": "tcp"
      },
      {
        "containerPort": 15001,
        "hostPort": 15001,
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "APPMESH_VIRTUAL_NODE_NAME",
        "value": "${appmesh_virtual_node_name}"
      },
      {
        "name": "ENVOY_LOG_LEVEL",
        "value": "info"
      },
      {
        "name": "APPMESH_XDS_ENDPOINT",
        "value": ""
      },
      {
        "name": "ENABLE_ENVOY_XRAY_TRACING",
        "value": "1"
      },
      {
        "name": "ENABLE_ENVOY_STATS_TAGS",
        "value": "1"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/testing",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "envoy"
      }
    },
    "healthCheck": {
      "command": [
        "CMD-SHELL",
        "curl -s http://localhost:9901/server_info | grep state | grep -q LIVE"
      ],
      "interval" : 5,
      "retries" : 3,
      "startPeriod" : 10,
      "timeout" : 2
    }
  },
  {
    "name": "xray-daemon",
    "image": "public.ecr.aws/xray/aws-xray-daemon:3.x",
    "user": "1337",
    "essential": true,
    "portMappings": [
      {
        "hostPort": 2000,
        "containerPort": 2000,
        "protocol": "udp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/testing",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "xray"
      }
    }
  } 
]
