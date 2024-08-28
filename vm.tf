resource "azurerm_windows_virtual_machine" "example" {
  name                  = var.vm_name
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  size                  = var.vm_size

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-pro"
    version   = "latest"
  }

  admin_username = var.admin_username
  admin_password = var.admin_password
}
resource "azurerm_virtual_machine_extension" "log_analytics_extension" {
  name                 = "LogAnalyticsAgent"
  virtual_machine_id   = azurerm_windows_virtual_machine.example.id # Assurez-vous que cela correspond à l'ID de la VM Windows
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

  settings = <<SETTINGS
    {
        "workspaceId": "${azurerm_log_analytics_workspace.example.workspace_id}"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "workspaceKey": "${azurerm_log_analytics_workspace.example.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}
