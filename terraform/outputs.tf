output "master_public_ip" {
  description = "Public IP of the Kubernetes master node"
  value       = aws_instance.master.public_ip
}

output "worker_public_ips" {
  value = {
    for i, instance in aws_instance.worker :
    "k8s-worker-${i + 1}" => instance.public_ip
  }
}
output "worker_private_ips" {
  description = "Private IP addresses of the Kubernetes worker nodes"

  value = {
    for i, instance in aws_instance.worker :
    "k8s-worker-${i + 1}" => instance.private_ip
  }
}
