output "subnet_id" {
  value = aws_subnet.airflow-subnet.id
}

output "scheduler_security_group_id" {
  value = aws_security_group.airflow-scheduler-db-dp-sg.id
}

output "api_security_group_id" {
  value = aws_security_group.airflow-api-server-sg.id
}