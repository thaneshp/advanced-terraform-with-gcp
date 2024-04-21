202404091325

Status: #notes

Tags: [[Cloud Computing MOC]]

## Understanding the `terraform` block

### Anatomy of a `terraform` Block

- Required version
- Backend configuration
- Provider requirements
- Experimental features
- Provider metadata

```HCL
terraform {
  required_version = ">= 1.0.11"
  backend "gcs" {
	  bucket = "tf-state-storage"
	  prefix = "terraform/config"
  }
  required_providers {
    local = {
        source = "hashicorp/local"
        version = ">= 2.1.0"
    }
  }
  experiments = [example]
  provider_meta "google" {
	  hello = "cloud gurus"
  }
}
```

#### Version Requirements

To specify the version in which Terraform must run.

- **Equals** `=` - Terraform must run the specified version
- **Greater Than or Equals** `>=` - Terraform must run the specified version or newer
- **Approximately Greater Than** `~>` - Terraform must run a version that is equal to or greater than the last digit

#### Remote Backends

- **Terraform Needs State Files** - Any time Terraform runs, it stores information about the resource it creates in a `.tfstate` file.
- **Store State Data Remotely** - Storing the state files remotely allows multiple users to work on the same state and maintains consistency.
- **Lots of Options for Storage** - Ste can be stored in storage buckets, HTTP endpoints, Artifactory, Postgres, and Terraform Cloud.

#### Providers

Providers are the plugins that allow Terraform to interface with specific technologies.

- Terraform Block - Define provider version and source information in the `terraform` block.
- Provider Block - Define project ID, region information, and authentication information in an independent `provider` block.

##### Provider Aliases

**Provider**

```HCL
provider "google" {
	region = "us-east1"
}
```

**Alias**

Configure a provider with different parameters and an `alias` attribute.

```HCL
provider "google" {
	alias = "west"
	region = "us-west1"
}
```

## Managing Multiple Environments with Terraform

### What Do We Mean by Repeatable?

```ad-info
title: Always the Same

- Infrastructure should be created the exact same way everytime.
- Dev environments should always run the same versions
- Lab sandboxes should always have the same setting.
```

```ad-example
title: Create n Copies
- You should be able to leverage the code to create as many instances of the infrastructure you need.
- You should be able to create `n` many worker nodes as you need to handle spikes in traffic.
- You should be able to create a new workstation for a new hire.
```

### Repeatability with Terraform

#### Modules

**A collection of variables, data sources, resources, and outputs.**

- Bundles of resources
- Like a class in object-oriented programming
- Like a stamp: you can change the ink colour, but the pattern is always the same

**Hard-Coded Values**
- You can set properties in attributes so that instantiations of the modules will have a specific configuration.

**Sane Defaults**
- You can specify default values for attributes but allow users to override those values.

**Required Arguments**
- You can leave arguments in a module undefined so users need to supply a value to create any resources.

#### Workspaces

- Create isolated sets of resources
- Duplicate entire project directory's resources
- Lifecycle each workspace independently

1. Parellel Sets of Resources
	- Using Terraform workspaces, you can create duplicate sets of resources from a single code base that are isolated from other workspaces' Terraform runs (`plan`/`apply`/`destroy`).
2. Like Git Branches
	- When you run `terraform apply` to apply configuration changes, Terraform will only make changes to the current workspace. Other workspaces' resources won't change.
3. Using `terraform.workspace`
	- Workspaces are less flexible than modules but you can use the workspace's name and conditional expressions to customise behaviour.

## Going Beyond Resources in Terraform Syntax

### Local Values

- Local values (locals) are variables that are internal to a module
- Locals can be useful for transforming data
- The block is defined as `locals`, but values are referenced as `local.value`

```HCL
locals {
	env = "prod"
	dept = "Cloud Gurus"

	startup_script = "echo ${local.dept} > org.config"
}
```

### Data Sources

- Terraform can read data about cloud resources
- It can get current values at time of apply to keep external information up to date
- Each provider can define its own data sources, just like resources - for instance, Google offers a lot of them
- For example: Get the IP of a server based on name or tag pattern for firewall rules
- Some data sources are local (files, directories), and the local provider is required for those
- You can access Terraform remote states as data objects

```HCL
data "google_storage_bucket_object_content" "my_file" {
	name = "reference.txt"
	bucket = "my-storage-bucket"
}

output "my_file" {
	value = data.google_storage_bucket_object_content.my_file.content
}
```

### Loops

- **Let there be count**
	- Create `n` modules with `count = n`
- **count + length(list) = :)**
	- Using count to iterate over a list led to more flexible modules
- **But...**
	- Iterating over a list is brittle - it can force unnecessary recreation of resources
- `for_each`
	- More flexible - supports mapped values (key:value)

```ad-note
- `count`
	- Works best for fixed list of values
- `for_each`
	- Supports more flexible data types
```

### Conditionals

- Conditionals are if/else statements. These can be used to customise how Terraform behaves under specific conditions.

### Outputs

- Outputs are explicit definitions exposing a resource or module's attributes.
- Outputs can be passed in as arguments for other resources and modules.
- Module outputs will be printed to the log after a successful `apply` is run


