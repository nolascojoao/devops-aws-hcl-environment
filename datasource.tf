data "aws_ami" "server_ami" {
    most_recent = true
    owners = ["137112412989"]

    filter {
      name = "name"
      values = ["al2023-ami-2023.6.20241212.0-kernel-*"]
    }
}