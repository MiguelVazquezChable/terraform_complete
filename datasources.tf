data "aws_ami" "ami_ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform_key"
  public_key = file("/home/ec2-user/.ssh/terraform_key.pub")
}
