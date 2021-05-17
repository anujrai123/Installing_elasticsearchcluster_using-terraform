output "instance_id" {
  value = element(aws_instance.elasticsearch.*.id, 1)
}


output "instance2_id" {
  value = element(aws_instance.elasticsearch.*.id, 2)
}

output "instance3_id" {
  value = element(aws_instance.elasticsearch.*.id, 3)
}
