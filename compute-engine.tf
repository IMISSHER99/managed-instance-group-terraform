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