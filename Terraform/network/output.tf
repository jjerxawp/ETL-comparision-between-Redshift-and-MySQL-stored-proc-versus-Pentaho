output "asm3_security_group_sct" {
  value = aws_security_group.asm3_sct.id
}

output "asm3_security_group_redshift" {
  value = aws_security_group.asm3_5439.id
}

output "asm3_vpc_id" {
  value = aws_vpc.asm3_vpc.id
}

output "asm3_subnet_id" {
  value = aws_subnet.public.id
}