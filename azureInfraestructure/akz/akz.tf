resource "azurerm_resource_group" "wso2" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_role_assignment" "wso2ACSUser" {
  scope                = "${azurerm_resource_group.wso2.id}"
  role_definition_name = "Contributor"
  principal_id         = "${var.client_id}"
}

resource "azurerm_kubernetes_cluster" "wso2" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.wso2.location}"
  resource_group_name = "${azurerm_resource_group.wso2.name}"
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
    Environment = "Production"
  }
}
