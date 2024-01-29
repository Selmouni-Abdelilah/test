data "azurerm_api_management" "name" {
    provider = azurerm.source
    name = "appservice-apim-source"
    resource_group_name = data.azurerm_resource_group.rg.name 
}

data "azurerm_api_management_api" "name" {
    provider = azurerm.source
    name = "arm-app-service"
    resource_group_name = data.azurerm_resource_group.rg.name
    api_management_name = data.azurerm_api_management.name.name
    revision = "1"
  
}
resource "azurerm_api_management" "exmple" {
    name                = "destination-apim"
    provider            = azurerm.dest
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    publisher_name      = data.azurerm_api_management.name.publisher_name
    publisher_email     = data.azurerm_api_management.name.publisher_email
    sku_name = data.azurerm_api_management.name.sku_name
    notification_sender_email = data.azurerm_api_management.name.notification_sender_email
}

# Copy API from source to destination
resource "azurerm_api_management_api" "example" {
    provider = azurerm.dest
    name                = "example-api"
    resource_group_name = azurerm_resource_group.rg.name
    api_management_name = azurerm_api_management.exmple.name
    revision            = data.azurerm_api_management_api.name.revision
    display_name        = data.azurerm_api_management_api.name.display_name
    path                = data.azurerm_api_management_api.name.path
}