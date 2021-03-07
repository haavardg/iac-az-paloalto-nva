# iac-az-paloalto-nva
Azure Palo Alto Lab

## Step 1: Deploy Azure resources
- Go to the tf-azure-resources folder
- create a .tfvars file, use the sample files as a template
- run: terraform init
- run: terraform plan -var-file="./sample.tfvars"
- run: terraform apply -var-file="./sample.tfvars"

# Step 2: Run basic Palo Alto config

**There is a limit to the amount of virtual routers on the Palo Alto with the trial license. You need to log on to the management portal and delete the "default" router on the palo alto before you run this terraform code.**

- Go to the tf-paloalto-config folder
- create a .tfvars file, use the sample files as a template
- run: terraform init
- run: terraform plan -var-file="./sample.tfvars"
- run: terraform apply -var-file="./sample.tfvars"
