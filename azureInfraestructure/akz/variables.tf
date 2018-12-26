variable "client_id" {}
variable "client_secret" {}

variable "agent_count" {
    default = 3
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "wso2"
}

variable cluster_name {
    default = "wso2prod"
}

variable resource_group_name {
    default = "azure-wso2prod"
}

variable location {
    default = "Central US"
}


variable wso2AccountID {
    default = "wso2account"
}

variable acr_name {
    default = "acrwso2prod"
}

variable tag_Environment {
    default = "Production"
}

variable ip_name {
    default = "wso2ip"
}
