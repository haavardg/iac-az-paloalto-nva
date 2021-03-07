
subscription_id = "11111111-2222-3333-4444-555555555555"  // Subscription ID that the Palo Alto firewall is deployed to
tenant_id       = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"  // Tenant ID that the Palo Alto firewall is deployed to

kv_rg_name      = "pa-h-rg-fw" // Key Vault name that contains the admin passoword secret
kv_name         = "pa-h-kv-fw-wctn" // Key Vault name that contains the admin passoword secret
kv_secret_name  = "admin-pwd-pa-h-vm-fw" // Key Vault secret name that contains the admin passoword secret

pip_rg_name     = "pa-h-rg-fw" // Resource Group name that contains the Palo Alto firewall
pip_name        = "pa-h-vm-fw-mgmt-pip" // Name of the Public IP that is attached to the Management Interface (mgmt)