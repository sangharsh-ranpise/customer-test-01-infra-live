terraform {
  required_version = ">= 1.0"
}

provider "local" {}

resource "local_file" "test_number" {
  content  = "42"
  filename = "output.txt"
}
