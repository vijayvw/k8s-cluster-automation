resource "aws_ssm_parameter" "kubeadm_join" {
  name        = "/k8s/join-command"
  description = "Kubernetes worker join command"
  type        = "String"
  value       = "pending"

  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name = "kubeadm-join-command"
  }
}
