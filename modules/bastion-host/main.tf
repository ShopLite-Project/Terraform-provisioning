data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_security_group" "bastion" {
  name        = "${var.tags["Environment"]}-${var.tags["Project"]}-${var.config.instance_name}-sg"
  description = "Security group for bastion host"
  vpc_id      = var.network.vpc_id

  ingress {
    description = "SSH access to bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.config.allowed_ssh_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-${var.tags["Project"]}-${var.config.instance_name}-sg"
  })
}

resource "aws_iam_role" "bastion" {
  name = "${var.tags["Environment"]}-${var.tags["Project"]}-${var.config.instance_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "readonly_ec2" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.tags["Environment"]}-${var.tags["Project"]}-${var.config.instance_name}-profile"
  role = aws_iam_role.bastion.name
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.config.instance_type
  key_name                    = var.config.key_name
  subnet_id                   = var.config.create_on_public_subnet ? var.network.public_subnet_ids[0] : var.network.private_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = var.config.create_on_public_subnet
  iam_instance_profile        = aws_iam_instance_profile.bastion.name
  disable_api_termination     = var.config.enable_termination_protection

  root_block_device {
    volume_size = var.config.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-${var.tags["Project"]}-${var.config.instance_name}"
  })
}
