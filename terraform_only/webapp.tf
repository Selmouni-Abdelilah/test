resource "azurerm_resource_group" "forimport" {
  provider = azurerm.source
  name = var.resgrp_name
  location = var.location
}
data "azurerm_resource_group" "rg" {
  provider = azurerm.source
  name = var.resgrp_name
}
data "azurerm_app_service_plan" "name" {
    provider = azurerm.source
    name = "arm-app-service-plan"
    resource_group_name = data.azurerm_resource_group.rg.name  
}
data "azurerm_app_service" "name" {
    provider = azurerm.source
    name = "arm-app-service"
    resource_group_name = data.azurerm_resource_group.rg.name  
}

resource "azurerm_resource_group" "rg" {
    provider = azurerm.dest
    name = var.resgrp_name
    location = data.azurerm_resource_group.rg.location
}
# Create the destination App Service Plan if it doesn't exist already
resource "azurerm_app_service_plan" "name" {
    provider = azurerm.dest
    name = var.svc_plan_name
    location = data.azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    kind = data.azurerm_app_service_plan.name.kind
    reserved = data.azurerm_app_service_plan.name.reserved
    zone_redundant = data.azurerm_app_service_plan.name.zone_redundant

    sku {
      tier = data.azurerm_app_service_plan.name.sku[0].tier
      size = data.azurerm_app_service_plan.name.sku[0].size
    }  
}

resource "azurerm_app_service" "name" {
    provider = azurerm.dest
    name = var.webapp_name
    location = data.azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    app_service_plan_id = azurerm_app_service_plan.name.id
    site_config {
    default_documents = data.azurerm_app_service.name.site_config[0].default_documents
    ftps_state = data.azurerm_app_service.name.site_config[0].ftps_state 
    health_check_path = data.azurerm_app_service.name.site_config[0].health_check_path
    always_on = data.azurerm_app_service.name.site_config[0].always_on
    http2_enabled = data.azurerm_app_service.name.site_config[0].http2_enabled
    }
    tags = data.azurerm_app_service.name.tags
    app_settings = data.azurerm_app_service.name.app_settings

    connection_string {
        name  = data.azurerm_app_service.name.connection_string[0].name
        type  = data.azurerm_app_service.name.connection_string[0].type
        value = data.azurerm_app_service.name.connection_string[0].value
    }
    source_control {
        repo_url   = data.azurerm_app_service.name.source_control[0].repo_url
        branch  = data.azurerm_app_service.name.source_control[0].branch
        manual_integration  = data.azurerm_app_service.name.source_control[0].manual_integration
        rollback_enabled  = data.azurerm_app_service.name.source_control[0].rollback_enabled
        use_mercurial  = data.azurerm_app_service.name.source_control[0].use_mercurial
    }

}
