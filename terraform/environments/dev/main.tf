data "aws_availability_zones" "available" { state = "available" }

resource "aws_vpc" "this" {
  cidr_block = "10.40.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = "${var.project_name}-vpc" }
}
resource "aws_internet_gateway" "this" { vpc_id = aws_vpc.this.id; tags = { Name = "${var.project_name}-igw" } }
resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.40.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = { Name = "${var.project_name}-public-a" }
}
resource "aws_route_table" "public" { vpc_id = aws_vpc.this.id; route { cidr_block = "0.0.0.0/0"; gateway_id = aws_internet_gateway.this.id }; tags = { Name = "${var.project_name}-public-rt" } }
resource "aws_route_table_association" "public_a" { subnet_id = aws_subnet.public_a.id; route_table_id = aws_route_table.public.id }
resource "aws_security_group" "demo" {
  count = var.enable_demo_ec2 ? 1 : 0
  name = "${var.project_name}-demo-sg"
  description = "Restricted demo SSH; do not expose app/admin ports publicly"
  vpc_id = aws_vpc.this.id
  ingress { description = "SSH from approved CIDR only"; from_port = 22; to_port = 22; protocol = "tcp"; cidr_blocks = [var.allowed_ssh_cidr] }
  egress { from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"] }
  tags = { Name = "${var.project_name}-demo-sg" }
}
data "aws_ami" "al2023" {
  count = var.enable_demo_ec2 ? 1 : 0
  most_recent = true
  owners = ["137112412989"]
  filter { name = "name"; values = ["al2023-ami-2023.*-x86_64"] }
  filter { name = "architecture"; values = ["x86_64"] }
}
resource "aws_instance" "demo" {
  count = var.enable_demo_ec2 ? 1 : 0
  ami = data.aws_ami.al2023[0].id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.demo[0].id]
  associate_public_ip_address = true
  metadata_options { http_tokens = "required" }
  root_block_device { encrypted = true; volume_size = 12; volume_type = "gp3" }
  tags = { Name = "${var.project_name}-demo" }
}
