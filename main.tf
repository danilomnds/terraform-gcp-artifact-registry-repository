resource "google_artifact_registry_repository" "repository" {
  repository_id = var.repository_id
  format        = var.format
  location      = var.location
  description   = var.description
  labels        = var.labels
  kms_key_name  = var.kms_key_name
  dynamic "docker_config" {
    for_each = var.docker_config != null ? [var.docker_config] : []
    content {
      immutable_tags = docker_config.value.immutable_tags
    }
  }
  dynamic "maven_config" {
    for_each = var.maven_config != null ? [var.maven_config] : []
    content {
      allow_snapshot_overwrites = lookup(maven_config.value, "allow_snapshot_overwrites", null)
      version_policy            = lookup(maven_config.value, "version_policy", null)
    }
  }
  mode = var.mode
  dynamic "virtual_repository_config" {
    for_each = var.virtual_repository_config != null ? [var.virtual_repository_config] : []
    content {
      dynamic "upstream_policies" {
        for_each = virtual_repository_config.value.upstream_policies != null ? [virtual_repository_config.value.upstream_policies] : []
        content {
          id         = lookup(upstream_policies.value, "id", null)
          repository = lookup(upstream_policies.value, "repository", null)
          priority   = lookup(upstream_policies.value, "priority", null)
        }
      }
    }
  }
  dynamic "cleanup_policies" {
    for_each = var.cleanup_policies != null ? var.cleanup_policies : []
    content {
      id     = cleanup_policies.value.id
      action = lookup(cleanup_policies.value, "action", null)
      dynamic "condition" {
        for_each = cleanup_policies.value.condition != null ? [cleanup_policies.value.condition] : []
        content {
          tag_state             = lookup(condition.value, "tag_state", null)
          tag_prefixes          = lookup(condition.value, "tag_prefixes", null)
          version_name_prefixes = lookup(condition.value, "version_name_prefixes", null)
          package_name_prefixes = lookup(condition.value, "package_name_prefixes", null)
          older_than            = lookup(condition.value, "older_than", null)
          newer_than            = lookup(condition.value, "newer_than", null)
        }
      }
      dynamic "most_recent_versions" {
        for_each = cleanup_policies.value.most_recent_versions != null ? [cleanup_policies.value.most_recent_versions] : []
        content {
          package_name_prefixes = lookup(most_recent_versions.value, "package_name_prefixes", null)
          keep_count            = lookup(most_recent_versions.value, "keep_count", null)
        }
      }
    }
  }
  dynamic "remote_repository_config" {
    for_each = var.remote_repository_config != null ? [var.remote_repository_config] : []
    content {
      description = lookup(remote_repository_config.value, "description", null)
      dynamic "apt_repository" {
        for_each = remote_repository_config.value.apt_repository != null ? [remote_repository_config.value.apt_repository] : []
        content {
          dynamic "public_repository" {
            for_each = apt_repository.value.public_repository != null ? [apt_repository.value.public_repository] : []
            content {
              repository_base = public_repository.value.repository_base
              repository_path = public_repository.value.repository_path
            }
          }
        }
      }
      dynamic "docker_repository" {
        for_each = remote_repository_config.value.docker_repository != null ? [remote_repository_config.value.docker_repository] : []
        content {
          public_repository = lookup(docker_repository.value, "public_repository", null)
          dynamic "custom_repository" {
            for_each = docker_repository.value.custom_repository != null ? [docker_repository.value.custom_repository] : []
            content {
              uri = custom_repository.value.uri
            }
          }
        }
      }
      dynamic "maven_repository" {
        for_each = remote_repository_config.value.maven_repository != null ? [remote_repository_config.value.maven_repository] : []
        content {
          public_repository = lookup(maven_repository.value, "public_repository", null)
          dynamic "custom_repository" {
            for_each = maven_repository.value.custom_repository != null ? [maven_repository.value.custom_repository] : []
            content {
              uri = custom_repository.value.uri
            }
          }
        }
      }
      dynamic "npm_repository" {
        for_each = remote_repository_config.value.npm_repository != null ? [remote_repository_config.value.npm_repository] : []
        content {
          public_repository = lookup(npm_repository.value, "public_repository", null)
          dynamic "custom_repository" {
            for_each = npm_repository.value.custom_repository != null ? [npm_repository.value.custom_repository] : []
            content {
              uri = custom_repository.value.uri
            }
          }
        }
      }
      dynamic "python_repository" {
        for_each = remote_repository_config.value.python_repository != null ? [remote_repository_config.value.python_repository] : []
        content {
          public_repository = lookup(python_repository.value, "public_repository", null)
          dynamic "custom_repository" {
            for_each = python_repository.value.custom_repository != null ? [python_repository.value.custom_repository] : []
            content {
              uri = custom_repository.value.uri
            }
          }
        }
      }
      dynamic "yum_repository" {
        for_each = remote_repository_config.value.yum_repository != null ? [remote_repository_config.value.yum_repository] : []
        content {
          dynamic "public_repository" {
            for_each = yum_repository.value.public_repository != null ? [yum_repository.value.public_repository] : []
            content {
              repository_base = public_repository.value.repository_base
              repository_path = public_repository.value.repository_path
            }
          }
        }
      }
      dynamic "upstream_credentials" {
        for_each = remote_repository_config.value.upstream_credentials != null ? [remote_repository_config.value.upstream_credentials] : []
        content {
          dynamic "username_password_credentials" {
            for_each = upstream_credentials.value.username_password_credentials != null ? [upstream_credentials.value.username_password_credentials] : []
            content {
              username                = lookup(username_password_credentials.value, "username", null)
              password_secret_version = lookup(username_password_credentials.value, "password_secret_version", null)
            }
          }
        }
      }
    }
  }
  cleanup_policy_dry_run = var.cleanup_policy_dry_run
  project                = var.project
  lifecycle {
    ignore_changes = []
  }
}

resource "google_project_iam_member" "repoAdmin" {
  depends_on = [ google_artifact_registry_repository.repository ]
  for_each   = { for member in var.members : member => member }
  project    = var.project
  role       = "roles/artifactregistry.repoAdmin"
  member     = each.value
}