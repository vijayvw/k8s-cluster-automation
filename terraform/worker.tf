resource "aws_instance" "worker" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.worker_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.k8s_instance_profile.name

  count = var.worker_count

  depends_on = [
    aws_instance.master
  ]

  user_data = templatefile("${path.module}/../scripts/worker.sh.tpl", {
    hostname   = "worker-${count.index + 1}"
    aws_region = var.aws_region
  })

  root_block_device {
    volume_size = var.root_volume_size 
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "k8s-worker-${count.index + 1}"
  }
}
