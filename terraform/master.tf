resource "aws_instance" "master" {
  ami                    = var.ami_id
  key_name               = var.key_name
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.master_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.k8s_instance_profile.name

  user_data = templatefile("${path.module}/../scripts/master.sh.tpl", {
    hostname   = var.master_name
    aws_region = var.aws_region
    ssh_user   = var.ssh_user
  })

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = var.master_name
  }
}
