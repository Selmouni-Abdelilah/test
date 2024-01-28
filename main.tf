resource "azurerm_resource_group" "rg" {
  provider = azurerm.dest
  name = var.resgrp_name
  location = var.location 
}

resource "azurerm_resource_group_template_deployment" "webapp" {
  provider = azurerm.dest
  name                = "arm-api-connection-access-policy"
  resource_group_name = azurerm_resource_group.rg.name
  template_content = data.local_file.arm_file.content
  parameters_content = jsonencode({
    "sites_source_app_service_name" = {
      value = var.webapp_name
    },
    "serverfarms_source_app_service_plan_name" = {
      value = var.svc_plan_name
    }
  })
  deployment_mode = "Incremental"
}

data "local_file" "arm_file" {
  filename = "${path.module}/arm.json"
}