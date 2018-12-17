az ad sp create-for-rbac --name ServicePrincipalName --password c64xv382.

export ARM_SUBSCRIPTION_ID="1b0d9088-3f39-40bd-9f1b-30077d803e46"
export ARM_CLIENT_ID="2fd2e9d3-343e-499d-92a3-f68e57cfd9c3"
export ARM_CLIENT_SECRET="c64xv382"
export ARM_TENANT_ID="275ff6db-faa9-42a8-894d-48fb88d7bde2"



export TF_VAR_client_id=${ARM_CLIENT_ID}
export TF_VAR_client_secret=${ARM_CLIENT_SECRET}


2fd2e9d3-343e-499d-92a3-f68e57cfd9c3


* azurerm_role_assignment.wso2ACSUser: 
authorization.RoleAssignmentsClient#Create: 
Failure responding to request: StatusCode=403 -- 
Original Error: autorest/azure: 
Service returned an error. 
Status=403 Code="AuthorizationFailed" 
Message="The client '60c80de0-39e4-4ed6-98b7-dcf32a9bc548' with object id '60c80de0-39e4-4ed6-98b7-dcf32a9bc548' 
does not have authorization to perform action 'Microsoft.Authorization/roleAssignments/write' 
over scope '/subscriptions/1b0d9088-3f39-40bd-9f1b-30077d803e46/resourceGroups/azure-wso2test/
providers/Microsoft.Authorization/roleAssignments/d7680def-396a-812e-d40b-f67f969d7d53'."