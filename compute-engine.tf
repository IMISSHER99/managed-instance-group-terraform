

resource "google_compute_instance_template" "custom-instance-template" {
    name = var.compute_instance_name
    machine_type = var.machine_type
    description = var.compute_instance_description

    labels = {
        environment = var.compute_instance_label
    }

    disk {
      source_image = var.source_image
      disk_type = "pd-balanced"
      disk_size_gb = 10
    }

    network_interface {
      network = google_compute_network.custom-vpc-network.name
      subnetwork = google_compute_subnetwork.custom-subnet.name

      access_config {
        
      }
    }

    tags = ["compute-engine-instance-template"]

    metadata = {
      startup-script = <<-EOT
        #!/bin/bash
        sudo apt-get update
        sudo apt-get install -y apache2
        echo "<html><body><h1>Hello World!</h1></body></html>" | sudo tee /var/www/html/index.html
        sudo systemctl start apache2
        sudo systemctl enable apache2
      EOT
    }
  
}


resource "google_compute_health_check" "http-health-check" {
  name = var.health-check
  timeout_sec = 30
  check_interval_sec = 30
  healthy_threshold = 4
  unhealthy_threshold = 4
  
  http_health_check {
    request_path = "/"
    port = "80"
  }

  log_config {
    enable = true
  }
  
}

resource "google_compute_instance_group_manager" "managed-instance-group" {
    name = var.managed-instance-group
    base_instance_name = var.base_instance_name
    zone = var.project_zone
    description = var.instance_group_description
    target_size = 1

    version {
      instance_template = google_compute_instance_template.custom-instance-template.self_link_unique
    }

    named_port {
      name = "http"
      port = "80"
    }

    auto_healing_policies {
      health_check = google_compute_health_check.http-health-check.self_link
      initial_delay_sec = 300
    }
  
}

resource "google_compute_autoscaler" "autoscaler-policy" {
  name = var.autoscaler-policy
  zone = var.project_zone
  target = google_compute_instance_group_manager.managed-instance-group.id

  autoscaling_policy {
    max_replicas = 3
    min_replicas = 1
    cooldown_period = 60
    cpu_utilization {
      target = 0.6
    }

    scale_in_control {
      max_scaled_in_replicas {
        fixed = 1
      }
      time_window_sec = 60
    }
  }
  
}