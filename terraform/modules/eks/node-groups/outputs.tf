output "launch_template_name" {
  description = "Name of the launch template"
  value = aws_launch_template.raisin_nodegroup_launch_template.name
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value = aws_launch_template.raisin_nodegroup_launch_template.latest_version
}
