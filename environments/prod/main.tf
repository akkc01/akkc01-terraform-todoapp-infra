locals {
  common_tags = {
    "ManagedBy"   = "Terraform"
    "Owner"       = "TodoAppTeam"
    "Environment" = "prod"
  }
}

module "rg" {
  source      = "../../modules/azurerm_resource_group"
  rg_name     = "rg1-prod-todoapp"
  rg_location = "canadacentral"
  rg_tags     = local.common_tags
}

module "rg1" {
  source      = "../../modules/azurerm_resource_group"
  rg_name     = "rg1-prod-todoapp-1"
  rg_location = "canadacentral"
  rg_tags     = local.common_tags
}

module "acr" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_container_registry"
  acr_name   = "acrprodtodoapp"
  rg_name    = "rg1-prod-todoapp"
  location   = "canadacentral"
  tags       = local.common_tags
}

module "sql_server" {
  depends_on      = [module.rg]
  source          = "../../modules/azurerm_sql_server"
  sql_server_name = "sql-prod-todoapp"
  rg_name         = "rg1-prod-todoapp"
  location        = "canadacentral"
  admin_username  = "prodopsadmin"
  admin_password  = "P@ssw01rd@123"
  tags            = local.common_tags
}

module "sql_db" {
  depends_on  = [module.sql_server]
  source      = "../../modules/azurerm_sql_database"
  sql_db_name = "sqldb-prod-todoapp"
  server_id   = module.sql_server.server_id
  max_size_gb = "2"
  tags        = local.common_tags
}

module "aks" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_kubernetes_cluster"
  aks_name   = "aks-prod-todoapp"
  location   = "canadacentral"
  rg_name    = "rg1-prod-todoapp"
  dns_prefix = "aks-prod-todoapp"
  tags       = local.common_tags
}


module "pip" {
  source   = "../../modules/azurerm_public_ip"
  pip_name = "pip-prod-todoapp"
  rg_name  = "rg-prod-todoapp"
  location = "canadacentral"
  sku      = "Basic"
  tags     = local.common_tags
}
