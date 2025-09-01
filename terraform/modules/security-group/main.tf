resource "aws_security_group" "eks_node_sg" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all traffic within node group"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Allow EKS control plane to connect to nodes"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.eks_control_plane_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
