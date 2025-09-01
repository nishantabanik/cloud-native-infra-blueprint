output "record_name" {
  description = "The name of the record"
  value       = aws_route53_record.main.name
}

output "record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = aws_route53_record.main.fqdn
}

output "record_type" {
  description = "The record type"
  value       = aws_route53_record.main.type
}

output "zone_id" {
  description = "The ID of the hosted zone to contain this record"
  value       = aws_route53_record.main.zone_id
}

output "alias_name" {
  description = "DNS domain name of a resource record set"
  value       = aws_route53_record.main.alias[0].name
}

output "alias_zone_id" {
  description = "Hosted zone ID of the resource record set"
  value       = aws_route53_record.main.alias[0].zone_id
}