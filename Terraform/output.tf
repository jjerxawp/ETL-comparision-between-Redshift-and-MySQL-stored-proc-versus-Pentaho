
output "redshift_endpoint" {
  value = aws_redshift_cluster.asm3_redshift_cluster.endpoint
}

output "redshift_dns" {
  value = aws_redshift_cluster.asm3_redshift_cluster.dns_name
}

output "redshift_port" {
  value = aws_redshift_cluster.asm3_redshift_cluster.port
}

output "master_username" {
  value = var.master_username
}

output "master_password" {
  value = var.master_password
}

# output "asm3_redshift_serverless_endpoint_dns" {
#   value = aws_redshiftserverless_endpoint_access.asm3_redshift_serverless_endpoint.address
# }

# output "asm3_redshift_serverless_endpoint_port" {
#   value = aws_redshiftserverless_endpoint_access.asm3_redshift_serverless_endpoint.port
# }

output "s3_bucket_id" {
  value = module.s3.s3_id
}



