output "elasticsearch_ami" {
  value = aws_ami_from_instance.elasticsearch_ami.id
}
