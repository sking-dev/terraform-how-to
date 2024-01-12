## Common Variables ##
variable "location" {
  type        = string
  description = "The location to deploy the resources to."
  default     = "uksouth"
}

variable "environment_name" {
  type        = string
  description = "The environment to deploy the resources to."
}

variable "tags" {
  type        = map(string)
  description = "The set of default resource tags."
  default     = {}
}

variable "custom_tags" {
  type        = map(string)
  description = "The set of custom resource tags."
  default     = {}
}

## ACME POC Variables ##

variable "certificates" {
  description = "The list of SSL certificates to be generated."
  default = [
    {
      name = "apple"
    },
    {
      name = "banana"
    },
    {
      name = "cherry"
    },
    {
      name = "damson"
    }
  ]
}

variable "acme_registration_email" {
  type        = string
  description = "The email address for the ACME registration with Let's Encrypt."
}

# TODO: Use variables below in next phase of testing (or not..!)

# variable "acme_provider" {
#   type        = string
#   description = "The URL for the acme provider e.g. https://acme-staging-v02.api.letsencrypt.org/directory"
# }

# variable "certificate_common_name" {
#   type        = string
#   description = "This is the Common Name for the certificate."
#   default     = ""
# }

# variable "certificate_name" {
#   type        = string
#   description = "The generated certificate name."
# }

# variable "dns_challenge_dns_zone_name" {
#   type    = string
#   default = "Before creating a certificate, ACME will need to know if you own the domain so it will need to create a TXT record. This is the DNS zone where it will create that TXT record."
# }
