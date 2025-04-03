output "server_ips" {
  description = "Public IP addresses"
  value       = [for server in aws_instance.servers : server.public_ip]
}
