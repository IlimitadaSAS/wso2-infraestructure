resource "azurerm_resource_group" "wso2prod" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

  tags {
    Environment = "${var.tag_Environment}"
  }
}
resource "azurerm_container_registry" "acrwso2prod" {
  name                   = "${var.acr_name}"
  resource_group_name    = "${azurerm_resource_group.wso2prod.name}"
  location               = "${azurerm_resource_group.wso2prod.location}"
  sku                    = "Basic"
  admin_enabled          = false

  tags {
    Environment = "${var.tag_Environment}"
  }
}

resource "azurerm_kubernetes_cluster" "akswso2prod" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.wso2prod.location}"
  resource_group_name = "${azurerm_resource_group.wso2prod.name}"
  dns_prefix          = "${var.dns_prefix}"

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = "${file("${var.ssh_public_key}")}"
    }
  }

  agent_pool_profile {
    name            = "agentpool"
    count           = "${var.agent_count}"
    vm_size         = "Standard_DS1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  tags {
    Environment = "${var.tag_Environment}"
  }
}


resource "azurerm_public_ip" "wso2ipstatic" {
  name                         = "${var.ip_name}"
  location                     = "${azurerm_resource_group.wso2prod.location}"
  resource_group_name          = "MC_${azurerm_resource_group.wso2prod.name}_${azurerm_kubernetes_cluster.akswso2prod.name}_${azurerm_resource_group.wso2prod.location}"
  public_ip_address_allocation = "static"
  domain_name_label = "wso2ilimitada"

  tags {
    environment = "${var.tag_Environment}"
  }
}