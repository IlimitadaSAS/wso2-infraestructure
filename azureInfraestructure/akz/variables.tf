variable "client_id" {}
variable "client_secret" {}

variable "agent_count" {
    default = 3
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "wso2test"
}

variable cluster_name {
    default = "wso2test"
}

variable resource_group_name {
    default = "azure-wso2test"
}

variable location {
    default = "Central US"
}


variable wso2AccountID {
    default = ""
}