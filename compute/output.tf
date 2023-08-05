output "instance_ips" {
    value = [for i in aws_instance.terralab[*]: i.public_ip ]
}

output "instance_ids" {
    value = [for i in aws_instance.terralab[*]: i.id ]
}