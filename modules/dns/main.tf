# These are DNS records required for the application to function

resource "linode_domain" "domain" {
  type = "master"
  domain = var.app_tld  
  soa_email = var.domain_soa_email
}

resource "linode_domain_record" "domain_record_server" {
  domain_id = linode_domain.domain.id
  name        = var.domain_record_server_name
  record_type = "A"
  target      = linode_instance.instances["server"].ip_address
  ttl_sec     = var.domain_record_server_ttl_sec
}

resource "linode_domain_record" "domain-records-additional" {
  for_each = { for i, dr in var.domain_record_additional : i => dr }

  domain_id   = linode_domain.domain.id
  name        = each.value["name"]
  record_type = each.value["record_type"]
  target      = each.value["target"]
  ttl_sec     = each.value["ttl_sec"]
}