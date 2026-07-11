# ============================================================
# Master Security Group
# ============================================================

resource "aws_security_group" "master_sg" {
  name        = "master-sg"
  description = "Security group for Kubernetes master node"
  vpc_id      = aws_vpc.k8s_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  # Kubernetes API (kubectl from your laptop)
  ingress {
    description = "Kubernetes API"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  # Kubernetes API (workers -> master)
  ingress {
    description = "Workers to API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
  }

  # Kubelet
  ingress {
    description = "Kubelet"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
  }

  # etcd Client
  ingress {
    description = "etcd Client"
    from_port   = 2379
    to_port     = 2379
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
  }

  # etcd Peer
  ingress {
    description = "etcd Peer"
    from_port   = 2380
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
  }

  # Weave TCP
  ingress {
    from_port   = 6783
    to_port     = 6783
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
  }

  # Weave UDP
  ingress {
    from_port   = 6783
    to_port     = 6783
    protocol    = "udp"
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
  }

  # Weave Data
  ingress {
    from_port   = 6784
    to_port     = 6784
    protocol    = "udp"
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
  }

  # HTTP (NGINX Ingress)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  # HTTPS (NGINX Ingress)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }
}

# ============================================================
# Worker Security Group
# ============================================================

resource "aws_security_group" "worker_sg" {
  name        = "worker-sg"
  description = "Security group for Kubernetes worker nodes"
  vpc_id      = aws_vpc.k8s_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  # Kubelet
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
  }

  # Weave TCP
  ingress {
    from_port   = 6783
    to_port     = 6783
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
  }

  # Weave UDP
  ingress {
    from_port   = 6783
    to_port     = 6783
    protocol    = "udp"
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
  }

  # Weave Data
  ingress {
    from_port   = 6784
    to_port     = 6784
    protocol    = "udp"
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
  }

  # HTTP (only if Ingress Controller runs on workers)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  # HTTPS (only if Ingress Controller runs on workers)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }
  # NodePort Services
  ingress {
    description = "Kubernetes NodePort Services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
}
