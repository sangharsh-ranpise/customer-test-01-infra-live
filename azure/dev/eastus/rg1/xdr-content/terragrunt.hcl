# terragrunt.hcl
terraform {
  source = "./module"
}

inputs = {
  my_number = 42
}
