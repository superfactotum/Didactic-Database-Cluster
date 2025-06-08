output "control_plane_1_public_ip_ew1" {
  description = "Public IP of control_plane_1 in eu-west-1"
  value       = aws_instance.control_plane_1.public_ip
}

output "control_plane_1_private_ip_ew1" {
  description = "Private IP of control_plane_1 in eu-west-1"
  value       = aws_instance.control_plane_1.private_ip
}

output "data_plane_1_public_ip_ew1" {
  description = "Public IP of data_plane_1 in eu-west-1"
  value       = aws_instance.data_plane_1.public_ip
}

output "data_plane_1_private_ip_ew1" {
  description = "Private IP of data_plane_1 in eu-west-1"
  value       = aws_instance.data_plane_1.private_ip
}

output "data_plane_2_public_ip_ew1" {
  description = "Public IP of data_plane_2 in eu-west-1"
  value       = aws_instance.data_plane_2.public_ip
}

output "data_plane_2_private_ip_ew1" {
  description = "Private IP of data_plane_2 in eu-west-1"
  value       = aws_instance.data_plane_2.private_ip
}

output "data_plane_3_public_ip_ew1" {
  description = "Public IP of data_plane_3 in eu-west-1"
  value       = aws_instance.data_plane_3.public_ip
}

output "data_plane_3_private_ip_ew1" {
  description = "Private IP of data_plane_3 in eu-west-1"
  value       = aws_instance.data_plane_3.private_ip
}

output "s3_bucket_name_ew1" {
  description = "Name of the S3 bucket in eu-west-1"
  value       = aws_s3_bucket.bucket_ew1.bucket
}

output "vm_public_ip_ew2" {
  description = "Public IP of the VM in eu-west-2"
  value       = aws_instance.vm_ew2.public_ip
}

output "s3_bucket_name_ew2" {
  description = "Name of the S3 bucket in eu-west-2"
  value       = aws_s3_bucket.bucket_ew2.bucket
}