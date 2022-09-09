resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc_proyecto_terraform"
  }
}

resource "aws_subnet" "subred_publica" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"


  tags = {
    Name = "subred_publica"
  }
}

resource "aws_internet_gateway" "igw_test_vpc" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "igw_terraform"
  }
}

resource "aws_route_table" "rt_terraform" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "rt_terraform"
  }
}

resource "aws_route" "route_terraform" {
  route_table_id         = aws_route_table.rt_terraform.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_test_vpc.id
}

resource "aws_route_table_association" "rt_ass_terraform" {
  subnet_id      = aws_subnet.subred_publica.id
  route_table_id = aws_route_table.rt_terraform.id
}

resource "aws_security_group" "terraform_sg" {
  name        = "terraform_sg"
  description = "grupo de seguridad para instancias de subnet publico"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform_sg"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ami_ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "mi_primera_instancia"
  }

  key_name               = aws_key_pair.terraform_key.id
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]
  subnet_id              = aws_subnet.subred_publica.id
  user_data              = file("userdata.tpl")


  root_block_device {
    volume_size = 10
  }
}

