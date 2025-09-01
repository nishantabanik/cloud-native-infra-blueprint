## Providers

The following providers are used by this module:

- aws

- aws.default

## Required Inputs

The following input variables are required:

### accepter\_account\_id

Description: (Optional) The AWS account ID of the owner of the peer VPC. Defaults to the account ID the AWS provider is currently connected to

Type: `string`

### accepter\_cidr

Description: CIDR block of the accepter vpc

Type: `string`

### accepter\_private\_rt\_count

Description: Number of private route tables on the accepter side

Type: `number`

### accepter\_region\_id

Description: (Optional) The region of the accepter VPC of the VPC Peering Connection. auto\_accept must be false, and use the aws\_vpc\_peering\_connection\_accepter to manage the accepter side

Type: `string`

### accepter\_vpc\_id

Description: (Required) The ID of the VPC with which you are creating the VPC Peering Connection

Type: `string`

### accepter\_vpc\_private\_rt\_ids

Description: List of route tables IDs. It points at vpc peering accepter's private subnets to be associated to vpc requester

Type: `list(string)`

### environment\_tag

Description: This tag seems not to be used in the module. Perhaps superseded by var.tags?

Type: `any`

### peering\_name

Description: Name of the vpc peering connection to be used in tags both on requester/accepter side

Type: `string`

### requester\_cidr

Description: CIDR block of the requester vpc

Type: `string`

### requester\_vpc\_id

Description: (Required) The ID of the requester VPC

Type: `string`

### requester\_vpc\_private\_rt\_ids

Description: List of route tables IDs. It points at vpc peering requester's private subnets to be associated to vpc accepter

Type: `list(string)`

### requester\_vpc\_public\_rt\_ids

Description: List of route tables IDs. It points at vpc peering requester's public subnets to be associated to vpc accepter

Type: `list(string)`

### requester\_vpc\_rt\_id

Description: Route table id of public route from requester to accepter. Even if it's a list, only index 0 will be used.

Type: `list(string)`

### tags

Description: Map of tags to be added to vpc requester and accepter

Type: `map(string)`

## Optional Inputs

The following input variables are optional (have default values):

### enabled

Description: Whether the module is enabled or not: true/false

Type: `bool`

Default: `true`

### region

Description: VPC Region

Type: `string`

Default: `"eu-central-1"`

## Outputs

The following outputs are exported:

### peer\_id

Description: vpc peering connection ID

