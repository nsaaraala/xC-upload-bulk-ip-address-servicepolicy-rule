data "local_file" "ips" {
  filename = "ips.txt"
}

locals {
  # List of IPs with /32 CIDR notation
  ip_list = [for ip in split("\n", trimspace(data.local_file.ips.content)) : "${ip}/32"]

  # Set the chunk size to 1024
  chunk_size  = 1024

  # Chunk the IPs into groups of 1024
  chunked_ips = [for i in range(0, length(local.ip_list), local.chunk_size) : slice(local.ip_list, i, min(i + local.chunk_size, length(local.ip_list)))]

  # Generate a list of prefix set names for each chunk
  prefix_set_names = [for i in range(0, length(local.chunked_ips)) : format("harel-terraform-denylist-%d-prefix-set", i)]

  # Group prefix set names into batches of 4
  batch_size = 4
  prefix_set_batches = [
    for i in range(0, length(local.prefix_set_names), 4) :
    slice(local.prefix_set_names, i, min(i + 4, length(local.prefix_set_names)))
  ]
}



resource "volterra_ip_prefix_set" "example" {
  for_each = { for i, chunk in local.chunked_ips : i => chunk }

  name      = format("harel-terraform-denylist-%d-prefix-set", each.key)
  namespace = "naveen"
  prefix    = each.value
}

resource "volterra_service_policy" "blocked" {
  name      = "harel-terraform-ip-block-service-policy"
  namespace = "naveen"
  algo      = "FIRST_MATCH"

  # Debug output for dynamic rule_list iteration
  dynamic "rule_list" {
    for_each = local.prefix_set_batches
    content {
      rules {
        metadata {
          # Generate a unique name for each rule based on the batch index
          name = "test-batch-${rule_list.key}"
        }
        spec {
          action = "DENY"
          waf_action {
            none = true
          }
          ip_matcher {
            dynamic "prefix_sets" {
              for_each = rule_list.value
              content {
                name = prefix_sets.value
              }
            }
          }
        }
      }
    }
  }

  depends_on = [volterra_ip_prefix_set.example]
}


