param name string
param location string
param enableVaultForDeployment bool = true
param roleAssignments array = [
  {
    principalId: '7200f83e-ec45-4915-8c52-fb94147cfe5a'
    roleDefinitionIdOrName: 'Key Vault Secrets User'
    principalType: 'ServicePrincipal'
  }
]

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: name
  location: location
  properties: {
    enableSoftDelete: true
    enablePurgeProtection: true
    enabledForDeployment: enableVaultForDeployment
    accessPolicies: []
  }
}

// Role assignments for Key Vault
resource keyVaultRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for roleAssignment in roleAssignments: {
  name: guid(keyVault.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    principalId: roleAssignment.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalType: roleAssignment.principalType
  }
}]
