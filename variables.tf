variable "repository_id" {
  type = string
}

variable "format" {
  type = string
}

variable "location" {
  type    = string
  default = null
}

variable "description" {
  type    = string
  default = null
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "kms_key_name" {
  type    = string
  default = null
}

variable "docker_config" {
  type = object({
    immutable_tags = optional(bool)
  })
  default = null
}

variable "maven_config" {
  type = object({
    allow_snapshot_overwrites = optional(bool)
    version_policy            = optional(string)
  })
  default = null
}

variable "mode" {
  type    = string
  default = "STANDARD_REPOSITORY"
}

variable "virtual_repository_config" {
  type = object({
    upstream_policies = object({
      id         = optional(string)
      repository = optional(string)
      priority   = optional(string)
    })
  })
  default = null
}

variable "cleanup_policies" {
  type = list(object({
    id     = string
    action = optional(string)
    condition = optional(object({
      tag_state             = optional(string)
      tag_prefixes          = optional(string)
      version_name_prefixes = optional(string)
      package_name_prefixes = optional(string)
      older_than            = optional(string)
      newer_than            = optional(string)
    }))
    most_recent_versions = object({
      package_name_prefixes = optional(list(string))
      keep_count            = optional(number)
    })
  }))
  default = null
}

variable "remote_repository_config" {
  type = object({
    description = optional(string)
    apt_repository = optional(object({
      public_repository = optional(object({
        repository_base = string
        repository_path = string
      }))
    }))
    docker_repository = optional(object({
      public_repository = optional(string)
      custom_repository = optional(object({
        uri = optional(string)
      }))
    }))
    maven_repository = optional(object({
      public_repository = optional(string)
      custom_repository = optional(object({
        uri = optional(string)
      }))
    }))
    npm_repository = optional(object({
      public_repository = optional(string)
      custom_repository = optional(object({
        uri = optional(string)
      }))
    }))
    python_repository = optional(object({
      public_repository = optional(string)
      custom_repository = optional(object({
        uri = optional(string)
      }))
    }))
    yum_repository = optional(object({
      public_repository = optional(object({
        repository_base = string
        repository_path = string
      }))
    }))
    upstream_credentials = optional(object({
      username_password_credentials = optional(object({
        username                = optional(string)
        password_secret_version = optional(string)
      }))
    }))
    disable_upstream_validation = optional(bool)
  })
  default = null
}

variable "cleanup_policy_dry_run" {
  type    = bool
  default = false
}

variable "project" {
  type    = string
  default = null
}

variable "deletion_protection" {
  type    = bool
  default = null
}

variable "members" {
  type    = list(string)
  default = []
}