output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_id" { value = aws_subnet.public_a.id }
output "demo_instance_public_ip" { value = try(aws_instance.demo[0].public_ip, null) }
