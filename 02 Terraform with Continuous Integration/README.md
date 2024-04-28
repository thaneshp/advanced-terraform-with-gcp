## Automating Infrastructure as Code

### Continuous Integration

- **CI**: is a software development paradigm where code is added to the production codebase as it is ready, rather than waiting for a periodic release point.
- **Our Infrastructure is Code**: With Terraform, infrastructure changes can be treated just like any other other code.
- **Automation Reduces Toil**: By allowing an automated system to manage updates to infrastructure, you free up developers from rote tasks (and reduce odds of "fat finger" errors).

## Creating a Reusable Module

### Architecture Overview

```bash
├── modules
│   ├── gke
│	  └── main.tf
│   ├── ...
└── main
    ├── main.tf
```

## Continuously Integrating Applications with Terraform

### Design Choices

**You have your cluster, but you don't want to develop in production...**

**Workspaces?**
- Workspaces would be a fast, easy way to create development resources, but they would be inflexible.

**Modules?**
- You can instantiate a development module, but then changes to module code aren't isolated from your main resources.

**Branches?**
- Making changes to development resources on a development branch will keep your changes out of production until you're ready.

### Architecture Update

```bash
├── modules
│   ├── gke
│	  └── main.tf
│   ├── ...
└── main
│   ├── main.tf
└── dev
    ├── main.tf
```

[Example](../02%20Terraform%20with%20Continuous%20Integration/reusable-module-example/)