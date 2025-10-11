resource "cloudflare_zone" "yyuemii_co" {
  account = {
    id = var.account_id
  }

  name = "yyuemii.co"
  type = "full"
}

# proof of ownership

resource "cloudflare_dns_record" "yyuemii_co_apple_verification" {
  zone_id = cloudflare_zone.yyuemii_co.id

  name    = "yyuemii.co"
  type    = "TXT"
  content = "apple-domain=I2qfOPAr5FHLrid7"

  proxied = false
  ttl     = 3600
}

resource "cloudflare_dns_record" "yyuemii_co_discord_verification" {
  zone_id = cloudflare_zone.yyuemii_co.id

  name    = "_discord"
  type    = "TXT"
  content = "dh=be414e77d5287b4726e737e1801c5b2c6acba8ed"

  proxied = false
  ttl     = 1
}

# icloud mail setup

resource "cloudflare_dns_record" "yyuemii_co_icloud_mx01" {
  zone_id = cloudflare_zone.yyuemii_co.id

  name     = "yyuemii.co"
  type     = "MX"
  content  = "mx01.mail.icloud.com"
  priority = 10

  proxied = false
  ttl     = 3600
}

resource "cloudflare_dns_record" "yyuemii_co_icloud_mx02" {
  zone_id = cloudflare_zone.yyuemii_co.id

  name     = "yyuemii.co"
  type     = "MX"
  content  = "mx02.mail.icloud.com"
  priority = 10

  proxied = false
  ttl     = 3600
}

resource "cloudflare_dns_record" "yyuemii_co_icloud_spf" {
  zone_id = cloudflare_zone.yyuemii_co.id

  name    = "yyuemii.co"
  type    = "TXT"
  content = "v=spf1 include:icloud.com ~all"

  proxied = false
  ttl     = 3600
}

resource "cloudflare_dns_record" "yyuemii_co_icloud_dmarc" {
  zone_id = cloudflare_zone.yyuemii_co.id

  name    = "_dmarc"
  type    = "TXT"
  content = "v=DMARC1; p=reject; pct=100; adkim=s; aspf=s"

  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "yyuemii_co_icloud_domainkey" {
  zone_id = cloudflare_zone.yyuemii_co.id

  name    = "sig1._domainkey"
  type    = "CNAME"
  content = "sig1.dkim.yyuemii.co.at.icloudmailadmin.com"

  proxied = false
  ttl     = 3600
}
