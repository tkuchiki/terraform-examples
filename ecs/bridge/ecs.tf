resource "aws_ecs_cluster" "dev" {
  name = "ecs-cluster-dev"
}

resource "aws_ecs_service" "dev" {
  name            = "ecs-service-dev"
  cluster         = "${aws_ecs_cluster.dev.id}"
  task_definition = "${aws_ecs_task_definition.dev.arn}"
  desired_count   = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 400
  health_check_grace_period_seconds = 0
  iam_role = "${aws_iam_role.dev_ecs_service.arn}"
  depends_on      = ["aws_iam_role_policy_attachment.dev_ecs_service_policy"]

  load_balancer {
    target_group_arn = "${aws_alb_target_group.dev_ec2.arn}"
    container_name = "api"
    container_port = 8080
  }

  lifecycle {
    ignore_changes = ["task_definition"]
  }
}

resource "aws_ecs_task_definition" "dev" {
  family                = "api-dev"
  container_definitions = <<EOF
[
  {
    "name": "api",
    "memory": 1024,
    "image": "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/your_repo:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "command": ["bundle", "exec", "rails", "s", "-p", "8080", "-b", "0.0.0.0"],
    "environment": [
      { "name": "RAILS_ENV", "value": "development" }
    ]
  }
]

EOF

  lifecycle {
    ignore_changes = ["container_definitions"]
  }
}
