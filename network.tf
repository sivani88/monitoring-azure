# Créer un groupe de sécurité réseau (NSG) avec des règles pour la VM Windows 11
resource "azurerm_network_security_group" "nsg_example" {
  name                = "windows11-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  # Règle pour autoriser le trafic RDP (port 3389) de l'extérieur
  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Règle pour autoriser le trafic HTTP (port 80)
  security_rule {
    name                       = "allow-http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Règle pour autoriser le trafic HTTPS (port 443)
  security_rule {
    name                       = "allow-https"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Règle pour refuser tout autre trafic entrant
  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Créer une adresse IP publique pour la VM
resource "azurerm_public_ip" "example" {
  name                = "windows11-pip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

# Créer un réseau virtuel
resource "azurerm_virtual_network" "example" {
  name                = "windows11-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

# Créer un sous-réseau
resource "azurerm_subnet" "example" {
  name                 = "windows11-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Associer le NSG au sous-réseau
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.nsg_example.id
}

# Créer une interface réseau et l'associer à l'adresse IP publique et au NSG
resource "azurerm_network_interface" "example" {
  name                = "windows11-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "windows11-ipconfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}
