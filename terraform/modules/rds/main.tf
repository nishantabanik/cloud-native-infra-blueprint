resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.cluster_identifier}-subnet-group"
  })
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "${var.cluster_identifier}-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = var.allowed_cidr_blocks
    security_groups = var.allowed_security_groups
    description     = "Allow MySQL access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_identifier}-sg"
  })
}

resource "random_password" "master_pwd" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "rds_secret" {
  name                    = "${var.cluster_identifier}-secret"
  recovery_window_in_days = 7
  kms_key_id              = var.kms_key_id
  description             = "Master password for ${var.cluster_identifier}"

  tags = var.tags
}

resource "aws_iam_role" "rds_monitoring_role" {
  name_prefix = "${var.cluster_identifier}-monitor-role-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attachment" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = var.cluster_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = random_password.master_pwd.result
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  storage_encrypted       = true
  kms_key_id              = var.kms_key_id
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
  monitoring_interval     = 60
  monitoring_role_arn     = aws_iam_role.rds_monitoring_role.arn
  deletion_protection     = true
  skip_final_snapshot     = false
  final_snapshot_identifier = "${var.cluster_identifier}-final-snapshot"

  tags = merge(var.tags, {
    Name = var.cluster_identifier
  })

  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count               = var.instance_count
  identifier          = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  instance_class      = var.instance_class
  engine              = aws_rds_cluster.aurora_cluster.engine
  engine_version      = aws_rds_cluster.aurora_cluster.engine_version
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn

  tags = merge(var.tags, {
    Name = "${var.cluster_identifier}-${count.index + 1}"
  })
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = var.master_username
    password = random_password.master_pwd.result
    endpoint = aws_rds_cluster.aurora_cluster.endpoint
    port     = aws_rds_cluster.aurora_cluster.port
    dbname   = var.database_name
  })
}
