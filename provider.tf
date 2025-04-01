terraform {
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = "0.11.30"
    }
  }
}
provider "volterra" {
  api_p12_file     = "<cert path>"
  url              = "https://<tenant>.console.ves.volterra.io/api"
}
