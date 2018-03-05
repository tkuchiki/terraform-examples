resource "aws_instance" "dev" {
  ami                         = "YOUR_AMI_ID"
  availability_zone           = "${data.aws_availability_zones.available.names[1]}"
  ebs_optimized               = false
  instance_type               = "t2.medium"
  monitoring                  = false
  key_name                    = "your-key"
  subnet_id                   = "${var.subnet_id_1}"
  vpc_security_group_ids      = ["${aws_security_group.dev_ec2.id}"]
  associate_public_ip_address = true
  source_dest_check           = true

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER="ecs-cluster-dev" > /etc/ecs/ecs.config
EOF
  
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
  }
}
