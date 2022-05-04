terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.17"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
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
# Create Database
resource "snowflake_database" "demo_db" {
  name    = "DEMO_DB"
  comment = "Database for Snowflake Terraform demo"
}
# Create Schema
resource "snowflake_schema" "schema" {
  database = "DEMO_DB"
  name     = "TestTF"
  comment  = "A schema."

  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}

# Create Table


resource "snowflake_table" "table" {
  database            = snowflake_schema.schema.database
  schema              = snowflake_schema.schema.name
  name                = "TFTable"
  comment             = "A table."

  column {
    name     = "id"
    type     = "int"
    nullable = true
  }

  column {
    name     = "data"
    type     = "text"
    nullable = false
  }

  column {
    name = "DATE"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name    = "extra"
    type    = "VARIANT"
    comment = "extra data"
  }
}


# Create View

resource snowflake_view view {
  database = "DEMO_DB"
  schema   = "TestTF"
  name     = "TFview"

  comment = "comment"

  statement  = <<-SQL
    select * from "TFTable";
SQL
}

# Create View

resource snowflake_view view1 {
  database = "DEMO_DB"
  schema   = "TestTF"
  name     = "TFTestview"

  comment = "comment"

  statement  = " Select 1 union Selct 2 "
}