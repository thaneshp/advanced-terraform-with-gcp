## Building Flexible Network Modules with IP Functions

### What Are Terraform Functions?

- You can't write your own functions to manipulate data in Terraform.
- Terraform offers dozens of pre-made functions to support all sorts of querying, transforming, and management behaviours.

### `cidrsubnet`

`cidrsubnet(prefix, newbits, netnum)`

- Calculates a subnet in a given IP range
- `prefix`:  The parent CIDR range
- `newbits`: The integer difference between the sizes of the parent and child ranges (/28 - /24 = 4)
- `netnum`: `cidrsubnet` splits the prefix into as many ranges as possible, and `netnum` is the position in that list
	- e.g. `cidrsubnet(var.cidr_range, var.size_diff, count.index)`

```shell
> cidrsubnet("10.10.0.0/24", 4, 0)
"10.10.0.0/28"

> cidrsubnet("10.10.0.0/24", 4, 3)
"10.10.0.48/28"

```

### `cidrhost`

`cidrhost(prefix, hostnum)`

- Calculates the host IP at a given position in a range
- `prefix`: The CIDR range
- `hostnum`: The position in the range

```shell
> cidrhost("10.0.0.0/8", 1)
"10.0.0.1"

> cidrhost("10.0.0.0/8", 100000)
"10.1.134.160"
```

## Encoding Data Structures with Terraform

### YAML and JSON

**Encode and Decode YAML and JSON** 
- These functions let you access data stored as YAML or JSON and output data into those structures.

**Managing System Configurations**
- Kubernetes manifests, IAM policies, and HTTP payloads are often expressed in JSON or YAML.

```shell
> jsonencode({"hello" = "cloud_gurus"})
{"hello": "cloud gurus"}

> yamlencode({"apple" = [1,2,3], "orange" = "pear"})
"orange": "pear"
"apple":
- 1
- 2
- 3
```

### Base64

Terraform supports Base64 encoding and decoding for strings, text, and files.

```shell
> base64encode("Hello Cloud Gurus!")
"SGVsbG8gQ2xvdWQgR3VydXMh"
```

### URL

Terraform can encode and decode data for URL addressing. This is useful when working with the HTTP provider.

```shell
> urlencode("Hello Cloud Gurus!")
"Hello+Cloud+Gurus%21"
```

## Using Date and Time Functions in Terraform

### `timestamp`

- The `timestamp` function returns a UTC timestamp
- `timestamp()` recalculates each time its run, so use with caution
- Use the `ignore_changes` meta-argument to avoid updates
- The Time Provider can also support static timestamps

```HCL
resource "google_spanner_instance" "db" {
	display_name = "Application Database"
	labels = {
		"time_created" = timestamp()
	}
	lifecycle {
		ignore_changes = [
			labels,
		]
	}
}
```

### `timeadd`

The `timeadd` function adds a specified duration to a timestamp and outputs the value.

```shell
> timeadd("2022-02-04T20:22:47Z", "4h")
"2022-02-05T00:22:47Z"
```

### `formatdate`

The `formatdate` function converts a timestamp into a different format.

## Accessing Filesystem Data with Terraform

### Referencing the Filesystem

- `path.module` is the module directory
- `path.root` is the root of the Terraform project
- `path.cwd` is the current working directory - it is usually the same as `path.root`

### Getting the Path 

- `path` expressions only work inside Terraform code - if you need to export the value, use a function
- `abspath()` returns the absolute path where it is run
- `pathexpand()` replaces `~` with the full path expression - it does not access the filesystem and so it cannot follow symbolic links

```shell
> abspath(path.root)
"/home/cloud_user_p_ec50b360"

> pathexpand("~/.ssh")
"home/cloud_user_p_ec50b360/.ssh"
```

### Directory and File Names

- You can separate the absolute path into the directory and base names
- `dirname()` returns the path up to the file name
- `basename()` returns only the file name with no path information
- Hard-coding path information can lead to errors when the same Terraform code is run on different workstations.

### Files

- `file()` returns the contents of the specified file
- `fileset()` returns all files in the specified directory that match the supplied pattern
- `fileexists()` returns `true` if the specified file exists and `false` if it does not
	- This can be used in validation of variables, as well as in conditional expressions

### Template Files

Map data into template files to structure data using the `templatefile` function.

[Example](../01%20Fun%20with%20Terraform%20Functions/template-files-example/)

## Managing Data Types in Terraform Code

### Types and Variables

- All values and resource attributes have types: `string`, `number`, `bool`, `list`, `map`, `null`.
- By default, variables are strings.
- Mark variables sensitive to restrict outputs.

### Type Conversion

- Automatically transforms valid arguments to specified data types.
- Use Terraform functions to transform values as needed.
- Use `can()` to validate expressions and `try()` to set fallback options.

```shell
> tostring(42)
"42"

> tonumber("18")
18
```

```HCL
variable "target" {
	description = "Target IP and port"
	default = "localhost:8000"
}

local {
	port_list = split(":", var.target)
	port_string = element(local.port_list, 1)
	port_num = tonumber(local.port_string)
}
```

[Example](../01%20Fun%20with%20Terraform%20Functions/validation-examples/)