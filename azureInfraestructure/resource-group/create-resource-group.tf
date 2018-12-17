provider "azurerm" {
    version = "~>1.5"
    subscription_id = "1b0d9088-3f39-40bd-9f1b-30077d803e46"
    client_id       = "2fd2e9d3-343e-499d-92a3-f68e57cfd9c3"
    client_secret   = "c64xv382"
    tenant_id       = "275ff6db-faa9-42a8-894d-48fb88d7bde2"
}

resource "azurerm_resource_group" "wso2" {
    name     = "${var.resource_group_name}"
    location = "${var.location}"
    tags {
        Environment = "${var.environment-tag}"
    }
}

