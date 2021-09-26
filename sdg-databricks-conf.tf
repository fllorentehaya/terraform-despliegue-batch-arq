/*provider "databricks" {
  alias = "created_workspace" 

  #host  = "${azurerm_databricks_workspace.sdgdatabricks.workspace_url}"
  #token=databricks_token.pat.token_value
  #azure_workspace_resource_id = azurerm_databricks_workspace.sdgdatabricks.id
 
      subscription_id = "14f69348-8506-41f1-ac5f-830f0c4ffceb"
  client_id       = "7101e195-2f4d-44b3-a29a-f2acf4e047ca"
  client_secret   = "xWMT0iRnwzCDPUY9GJzhNdVODTFDTIwg.5"
  tenant_id       = "cd149d37-c0df-4919-a5de-b2294e066d62"
  workspace_url = azurerm_databricks_workspace.sdgdatabricks.workspace_url
  


}*/

// create PAT token to provision entities within workspace
/*resource "databricks_token" "pat" {
  provider = databricks.created_workspace
  comment  = "Terraform Provisioning"
  // 100 day token
  lifetime_seconds = 8640000
}

// output token for other modules
output "databricks_token" {
  value     = databricks_token.pat.token_value
  sensitive = true
}*/