# Module - Artifact Registry Repository
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()
[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![OCI](https://img.shields.io/badge/provider-OCI-red)](https://registry.terraform.io/providers/oracle/oci/latest)

Module developed to standardize the creation of Artifact Registry Repository.

## Compatibility Matrix

| Module Version | Terraform Version | Google Version     |
|----------------|-------------------| ------------------ |
| v1.0.0         | v1.9.8            | 6.7.0              |

## Specifying a version

To avoid that your code get the latest module version, you can define the `?ref=***` in the URL to point to a specific version.
Note: The `?ref=***` refers a tag on the git module repo.

## Default use case
```hcl
module "repo" {    
  source = "git::https://github.com/danilomnds/terraform-gcp-module-artifact-registry-repository?ref=v1.0.0"
  project = "project_id"
  repository_id = "repo name"
  location = "<southamerica-east1>"
  format = "<DOCKER>"
  cleanup_policies = [{
    id = "default policy"
    action = "KEEP"
    most_recent_versions = {
      package_name_prefixes = ["webapp", "mobile", "sandbox"]
      keep_count            = 5
    }
  }]  
  labels = {
    diretoria   = "ctio"
    area        = "area"
    system      = "system"    
    environment = "fqa"
    projinfra   = "0001"
    dm          = "00000000"
    provider    = "gcp"
    region      = "southamerica-east1"
  }
}
output "id" {
  value = module.repo.id
}
```

## Default use case plus RBAC
```hcl
module "repo" {    
  source = "git::https://github.com/danilomnds/terraform-gcp-module-artifact-registry-repository?ref=v1.0.0"
  project = "project_id"
  repository_id = "repo name"
  location = "<southamerica-east1>"
  format = "<DOCKER>"
  cleanup_policies = [{
    id = "default policy"
    action = "KEEP"
    most_recent_versions = {
      package_name_prefixes = ["webapp", "mobile", "sandbox"]
      keep_count            = 5
    }
  }]
  members = ["group:GRP_GCP-SYSTEM-PRD@timbrasil.com.br"]
  labels = {
    diretoria   = "ctio"
    area        = "area"
    system      = "system"    
    environment = "fqa"
    projinfra   = "0001"
    dm          = "00000000"
    provider    = "gcp"
    region      = "southamerica-east1"
  }
}
output "id" {
  value = module.repo.id
}
```

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| repository_id | The last part of the repository name, for example: "repo1" | `string` | n/a | `Yes` |
| format | The format of packages that are stored in the repository | `string` | n/a | `Yes` |
| location | The name of the location this repository is located in | `string` | n/a | No |
| description | The user-provided description of the repository | `string` | n/a | No |
| labels | Labels with user-defined metadata | `map(string)` | n/a | No |
| kms_key_name | The Cloud KMS resource name of the customer managed encryption key that’s used to encrypt the contents of the Repository | `string` | n/a | No |
| docker_config | Docker repository config contains repository level configuration for the repositories of docker type | `object({})` | n/a | No |
| maven_config | MavenRepositoryConfig is maven related repository details | `object({})` | n/a | No |
| mode | The mode configures the repository to serve artifacts from different sources | `string` | `STANDARD_REPOSITORY` | No |
| virtual_repository_config | Configuration specific for a Virtual Repository | `object({})` | n/a | No |
| cleanup_policies | Cleanup policies for this repository | `list[object({})]` | n/a | No |
| remote_repository_config | Configuration specific for a Remote Repository | `object({})` | n/a | No |
| cleanup_policy_dry_run |  If true, the cleanup pipeline is prevented from deleting versions in this repository | `bool` | `false` | No |
| project | The ID of the project in which the resource belongs. If it is not provided, the provider project is used | `string` | n/a | No |
| members | list of azure AD groups that will use the resource | `list(string)` | n/a | No |

# Object variables for blocks

Please check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository)

## Output variables

| Name | Description |
|------|-------------|
| id | artifact registry repository id|

## Documentation
Artifact Registry Repository: <br>
[https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository)