data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
resource "aws_security_group" "bastion" {
  name        = "${var.name}-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from whitelisted IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  # Outbound internet access for updates and Session Manager
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-sg"
  })
}

resource "aws_iam_role" "bastion_role" {
  count = var.enable_session_manager ? 1 : 0
  name  = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}
resource "aws_iam_role_policy_attachment" "session_manager" {
  count      = var.enable_session_manager ? 1 : 0
  role       = aws_iam_role.bastion_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile for Session Manager
resource "aws_iam_instance_profile" "bastion_profile" {
  count = var.enable_session_manager ? 1 : 0
  name  = "${var.name}-profile"
  role  = aws_iam_role.bastion_role[0].name

  tags = var.tags
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id             = var.subnet_id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  
  associate_public_ip_address = true
  
  iam_instance_profile = var.enable_session_manager ? aws_iam_instance_profile.bastion_profile[0].name : null
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {}))

  tags = merge(var.tags, {
    Name = var.name
  })
}