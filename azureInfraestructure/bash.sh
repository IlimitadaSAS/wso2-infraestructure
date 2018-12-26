az ad sp create-for-rbac --name ServicePrincipalName --password c64xv382.
// Test
export ARM_SUBSCRIPTION_ID="1b0d9088-3f39-40bd-9f1b-30077d803e46"
export ARM_CLIENT_ID="2fd2e9d3-343e-499d-92a3-f68e57cfd9c3"
export ARM_CLIENT_SECRET="c64xv382"
export ARM_TENANT_ID="275ff6db-faa9-42a8-894d-48fb88d7bde2"


az account show --query "{subscriptionId:id, tenantId:tenantId}"

az account set --subscription="${ARM_SUBSCRIPTION_ID}"

az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${ARM_SUBSCRIPTION_ID}"


{
  "appId": "63f5bfeb-ba94-40a1-abb2-a1693e62b4b5",
  "displayName": "azure-cli-2018-12-26-15-29-56",
  "name": "http://azure-cli-2018-12-26-15-29-56",
  "password": "7700821a-a678-4ff0-a248-04b7e6c1d461",
  "tenant": "9d781529-2431-4f13-8fbe-1ce43aed2e56"
}



//Prod
export ARM_SUBSCRIPTION_ID="c801f3bb-e4d2-452d-b66a-f1a8f7609504"
export ARM_CLIENT_ID="63f5bfeb-ba94-40a1-abb2-a1693e62b4b5"
export ARM_CLIENT_SECRET="7700821a-a678-4ff0-a248-04b7e6c1d461"
export ARM_TENANT_ID="9d781529-2431-4f13-8fbe-1ce43aed2e56"


export TF_VAR_client_id=${ARM_CLIENT_ID}
export TF_VAR_client_secret=${ARM_CLIENT_SECRET}


"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+VAhVhzBrIzhSY2/UzQLvSaRwhoZYeTqmbbzUCNGLeqKRw3YXyMtqY2NhzXA0QeXvZt0wmMcRbsDUCEbJmtxrggTL1pNNb4b07u07eC6nyouMERwMBJlTb8Jijt6OS5m97ffzUhr+ifhd/M5nEJjwhoAL3G1xAUDNDKreUPHPfutTEuuN42NcOQG9+hSu3esbNCcwekM4jgb9WGA7bmpiQMFMH+ZahBCOLtnt3P8SLIYUm0rJgzxtEZH1Qu42VH6BMOxNDWAndcMK6PzS8cYUAXdHZQndu/IcyNvhV9GG6e5hYiB86wdcsC1uTpUIRv2teh2GzvSyvUtS9re0PfOB migueagile@migueagile-Latitude-E7240\n"



{
  "appId": "63f5bfeb-ba94-40a1-abb2-a1693e62b4b5",
  "displayName": "azure-cli-2018-12-26-15-29-56",
  "name": "http://azure-cli-2018-12-26-15-29-56",
  "password": "7700821a-a678-4ff0-a248-04b7e6c1d461",
  "tenant": "9d781529-2431-4f13-8fbe-1ce43aed2e56"
}


az role assignment create --assignee 63f5bfeb-ba94-40a1-abb2-a1693e62b4b5 --role Owner

* azurerm_role_assignment.wso2ACSUser: 
authorization.RoleAssignmentsClient#Create:
 Failure responding to request: StatusCode=403 -- 
 Original Error: autorest/azure: 
 Service returned an error. Status=403 Code="AuthorizationFailed" 
 Message="The client 'c237cd52-6229-47e9-bea4-c2264113b0d8' with object id 'c237cd52-6229-47e9-bea4-c2264113b0d8' 
 does not have authorization to perform action 'Microsoft.Authorization/roleAssignments/write' 
 over scope '/subscriptions/c801f3bb-e4d2-452d-b66a-f1a8f7609504/resourceGroups/azure-wso2prod/providers/Microsoft.Authorization/roleAssignments/85fd80e4-f827-c0f8-1945-980954f9127a'."
