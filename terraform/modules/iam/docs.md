## Providers

The following providers are used by this module:

- aws

## Required Inputs

The following input variables are required:

### role\_name

Description: The name of the IAM Role

Type: `string`

### tags

Description: A map of tags

Type: `map(string)`

## Optional Inputs

The following input variables are optional (have default values):

### assume\_role\_policy

Description: The assume role policy for the IAM role

Type: `string`

Default: `""`

### custom\_iam\_policies

Description: The custom IAM policies to be attached with the IAM

Type:

```hcl
list(object({
    name = string
    description = string
    policy_document = string
  }))
```

Default: `[]`

### description

Description: The description of the IAM role

Type: `string`

Default: `""`

### force\_detach\_policies

Description: Force detach policies when deleting the IAM Role

Type: `bool`

Default: `true`

### managed\_iam\_policies

Description: The list of managed polices that needs to be attached to the IAM Role

Type: `list(string)`

Default: `[]`

### max\_session\_duration

Description: The maximum session duration for the role

Type: `number`

Default: `3600`

## Outputs

The following outputs are exported:

### iam\_role\_arn

Description: The AWS ARN of the IAM Role

### iam\_role\_id

Description: The ID of the IAM Role

### iam\_role\_name

Description: The name of the IAM Role

### iam\_role\_policy\_arns

Description:  A list of Amazon Resource Names (ARN) of the policies attached to the Role

### iam\_role\_policy\_names

Description: A list of IAM policy names attached to the IAM Role

### iam\_role\_unique\_id

Description: The stable and unique string identifying the role

