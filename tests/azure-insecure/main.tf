
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

# INTENTIONALLY INSECURE TEST FIXTURES.
# Do not deploy these resources.

resource "azurerm_storage_account" "insecure" {
  name                     = "teststorageinsecure001"
  resource_group_name      = "rg-custodian-test"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Violations to test:
  allow_nested_items_to_be_public = true
  public_network_access_enabled  = true
  min_tls_version                = "TLS1_0"
}

resource "azurerm_key_vault" "insecure" {
  name                = "kv-custodian-test-001"
  resource_group_name = "rg-custodian-test"
  location            = "westeurope"
  tenant_id           = "00000000-0000-0000-0000-000000000000"
  sku_name            = "standard"

  # Violations to test:
  public_network_access_enabled = true
  purge_protection_enabled      = false
}

resource "azurerm_network_security_group" "insecure" {
  name                = "nsg-custodian-test"
  resource_group_name = "rg-custodian-test"
  location            = "westeurope"

  security_rule {
    name                       = "Allow-SSH-From-Internet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-RDP-From-Internet"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_mssql_server" "insecure" {
  name                         = "sql-custodian-test-001"
  resource_group_name          = "rg-custodian-test"
  location                     = "westeurope"
  version                      = "12.0"
  administrator_login          = "testadmin"
  administrator_login_password = "NotARealPassword123!"

  # Violation to test:
  public_network_access_enabled = true
}
