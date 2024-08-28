resource "azurerm_log_analytics_workspace" "example" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_days
}

resource "azurerm_user_assigned_identity" "example" {
  name                = "example-uai"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

resource "azurerm_monitor_data_collection_endpoint" "example" {
  name                = "example-dce"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_monitor_data_collection_rule" "example" {
  name                        = var.dcr_name
  resource_group_name         = azurerm_resource_group.example.name
  location                    = azurerm_resource_group.example.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.example.id

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.example.id
      name                  = "example-destination-log"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["example-destination-log"]
  }

  data_sources {
    windows_event_log {
      streams = ["Microsoft-WindowsEvent"]
      x_path_queries = [
        "Security!*[System/Level=2]", # Collecte tous les événements de niveau 2 (erreurs)
        "System!*[System/Level=2]"
      ]
      name = "example-datasource-wineventlog"
    }
  }


  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }

  depends_on = [
    azurerm_log_analytics_workspace.example
  ]
}
