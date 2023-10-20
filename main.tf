
provider "google" {
  project = "infra-workshop-template-94fb"
  credentials = file("/Users/yashasree/Downloads/infra-workshop-template-94fb-437c61d3a7d6.json")
  region = "asia-south1"
}

resource "google_service_account" "child" {
  account_id   = "child-service-account"
  display_name = "Child Service Account"
}

resource "google_project_iam_member" "child_storage_admin" {
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.child.email}"
}

resource "google_project_iam_member" "child_kubernetes_admin" {
  role = "roles/container.clusterAdmin"
  member = "serviceAccount:${google_service_account.child.email}"
}

resource "google_compute_network" "network" {
  name = "my-network"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.network.self_link
}

resource "google_container_cluster" "cluster" {
  name               = "my-cluster"
  location           = "asia-south1"
  initial_node_count = 1
}

resource "google_container_node_pool" "pool" {
  name       = "my-pool"
  location   = "asia-south1"
  cluster    = google_container_cluster.cluster.name
  node_count = 1
  node_config {
    machine_type = "n1-standard-1"
  }
}

