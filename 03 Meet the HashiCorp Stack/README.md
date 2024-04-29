## Securing Terraform Access with Vault

### HashiCorp Vault

- Secrets Management
- Secrets Engine
- Encryption Service

#### Secrets Management

Store secrets in one place to control access

**Static Values**

- Upload the secret/file/key to the manager, and that value will stay the same.

**Manage Access**

- Create an access control list defining who can access what secrets.

**Lots of Options**

- In addition to HashiCorp Vault, GCP offers a Secret Manager. Kubernetes, Ansible and Chef also have one.

#### Secrets Engines

1. Dynamic Secrets
	- Vault provisions access credits on demand

2.  Just-In-Time
	- Credentials are short lived

3. Access Audit Trail
	- Vault tracks who created what credentials

## Enforcing Standards in Terraform with Sentinel

### What is Sentinel?

1. **Policy as Code**
	- Defined expectations for Infrastructure as Code as code using custom Sentinel language.
2. **Integrated with Terraform Enterprise/Cloud**
	- This is a feature of paid Terraform solutions - it is rarely used outside those environments.
3. **Enforce Standards**
	- Policies allow stakeholders to automate enforcement of standards and best practices across an organisation.