vpc_name = "private-custom-vpc"
route_mode = "REGIONAL"
project_id = "compute-engine-learning-433211"
project_region = "asia-south1"
project_zone = "asia-south1-a"
ip_cidr_range = "10.0.1.0/24"
custom_subnet = "custom-subnet"
vpc_description = "Custom VPC network that has only 1 subnet with private google access and flow logs enabled"
subnet_description = "Custom Subnet that has an ip range of 10.0.1.0/24"
aggregation_interval = "INTERVAL_30_SEC"
flow_logs_metadata = "INCLUDE_ALL_METADATA"
allow_access_specific_ip = "allow-access-to-specific-ip"
protocol = "tcp"
ports = ["80", "8080"]
# source_ranges = "110.224.80.16/32"
source_ranges = "0.0.0.0/0"
compute_instance_name = "custom-compute-instance-template"
machine_type = "e2-micro"
compute_instance_description = "Compute Instance Template that installs apache2 webserver and displays an hello world page"
compute_instance_label = "sandbox"
source_image = "debian-cloud/debian-11"
health-check = "health-check-https"
managed-instance-group = "managed-instance-group"
base_instance_name = "apache2-webserver"
instance_group_description = "Managed Instance Group that creates 3 instances and also has a health check"
autoscaler-policy = "autoscaler-policy"