data "azurerm_resource_group" "example" {
  name     = "example-resources"
}

data "azurerm_app_service_plan" "source" {
  name                = "source-appserviceplan"
  resource_group_name = data.azurerm_resource_group.example.name
}

data "azurerm_app_service" "source" {
  name                = "source-app-service"
  resource_group_name = data.azurerm_resource_group.example.name
}

resource "azurerm_resource_group" "import" {
  name     = "example-resources-imported"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "import" {
  name                = "target-appserviceplan"
  location            = azurerm_resource_group.import.location
  resource_group_name = azurerm_resource_group.import.name
  reserved = data.azurerm_app_service_plan.source.reserved
  zone_redundant = data.azurerm_app_service_plan.source.zone_redundant
  kind = data.azurerm_app_service_plan.source.kind
  sku {
    tier = "Standard"
    size = "S1"
  }
}
resource "azurerm_app_service" "example" {
  name                = "source-app-service"
  location            = azurerm_resource_group.import.location
  resource_group_name = azurerm_resource_group.import.name
  app_service_plan_id = azurerm_app_service_plan.import.id
  client_affinity_enabled = data.azurerm_app_service.source.client_affinity_enabled
  https_only = data.azurerm_app_service.source.https_only
  site_config {
    app_command_line= data.azurerm_app_service.source.site_config[0].app_command_line
    default_documents = data.azurerm_app_service.source.site_config[0].default_documents
    always_on = data.azurerm_app_service.source.site_config[0].always_on
    dotnet_framework_version = data.azurerm_app_service.source.site_config[0].dotnet_framework_version
    ftps_state = data.azurerm_app_service.source.site_config[0].ftps_state
    number_of_workers = data.azurerm_app_service.source.site_config[0].number_of_workers
    http2_enabled = data.azurerm_app_service.source.site_config[0].http2_enabled
    cors {
      allowed_origins =  data.azurerm_app_service.source.site_config[0].cors[0].allowed_origins
      support_credentials = data.azurerm_app_service.source.site_config[0].cors[0].support_credentials
    }
  }
  app_settings = data.azurerm_app_service.source.app_settings
}