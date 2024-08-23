resource "google_compute_firewall" "allow_access_specific_ip" {
  name = var.allow_access_specific_ip
  network = google_compute_network.custom-vpc-network.name
  allow {
    protocol = var.protocol
    ports = var.ports
  }
  priority = 1001
  direction = "INGRESS"
  source_ranges = [var.source_ranges]
  log_config {
    metadata = var.flow_logs_metadata
  }

  target_tags = ["compute-engine-instance-template"]

  depends_on = [ google_compute_network.custom-vpc-network ]

}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.custom-vpc-network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.source_ranges]  # Allows SSH from any IP
  # Alternatively, use specific IP ranges for more security, e.g., ["192.168.1.8/32"]

  priority  = 1000
  direction = "INGRESS"

  target_tags = ["compute-engine-instance-template"]
}

# Creating a custom VPC
resource "google_compute_network" "custom-vpc-network" {
  name                    = var.vpc_name
  project                 = var.project_id
  auto_create_subnetworks = false
  mtu                     = 1460
  routing_mode            = var.route_mode
  description = var.vpc_description

}

resource "google_compute_subnetwork" "custom-subnet" {
  name = var.custom_subnet
  ip_cidr_range = var.ip_cidr_range
  region = var.project_region
  network = google_compute_network.custom-vpc-network.name
  private_ip_google_access = true
  description = var.subnet_description
  log_config {
    aggregation_interval = var.aggregation_interval
    flow_sampling = 1.0
    metadata = var.flow_logs_metadata
  }
}
