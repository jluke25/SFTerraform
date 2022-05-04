terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.17"
    }
  }

  backend "remote" {
    organization = "R1Terraform"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}

provider "snowflake" {
}

resource "snowflake_database" "demo_db" {
  name    = "DEMO_DB"
  comment = "Database for Snowflake Terraform demo"
}

resource snowflake_schema "schema" {
  database = "DEMO_DB"
  name     = "TestTF"
  comment  = "A schema."

  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}