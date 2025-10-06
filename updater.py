import subprocess

CIL_PATH = "customer-x-infra-live"
paths = [
    "azure/dev/eastus/rg1/xdr-content",
    # "azure/dev/eastus/rg1/services"
]

for path in paths:
    print(f"Running terragrunt plan & apply for {path}")
    subprocess.run(["terragrunt", "plan", "--terragrunt-include-dir", path], cwd=CIL_PATH)
    # subprocess.run(["terragrunt", "apply", "-auto-approve", "--terragrunt-include-dir", path], cwd=CIL_PATH)
