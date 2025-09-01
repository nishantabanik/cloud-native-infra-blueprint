resource "aws_launch_template" "raisin_nodegroup_launch_template" {
  name = var.eks_node_group_launch_template_name
  ebs_optimized = "true"
  image_id = var.eks_node_group_ami_id
  instance_type = var.eks_node_group_instance_type
  key_name = var.eks_node_group_ssh_key
  vpc_security_group_ids = var.eks_node_group_security_group_ids
  tag_specifications {
    resource_type = "instance"
    tags = var.eks_node_group_tags
  }

  lifecycle {
    ignore_changes = [
      vpc_security_group_ids,
      tag_specifications[0].tags["Owner"]
    ]
  }

  user_data = base64encode(templatefile(format("%s%s", path.module, "/templates/userdata.sh.tpl"),
                {
                  cluster_auth_base64 = var.eks_node_group_auth_base64
                  endpoint = var.eks_node_group_eks_endpoint
                  cluster_name = var.eks_cluster_name
                  region = var.eks_region
                }
              ))
}
