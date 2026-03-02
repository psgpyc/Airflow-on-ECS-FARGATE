variable "aws_profile" {

    type = string
    description = "The profile identifier to use to connect to AWS"
    nullable = false
    default = "default"

    validation {
      condition = length(trimspace(var.aws_profile)) > 0
      error_message = "The profile identifier cannot be an empty string"
    }

}


variable "aws_region" {

    type = string
    description = "The default AWS region"
    nullable = false
    default = "eu-west-2"

    validation {
      condition = length(trimspace(var.aws_region)) > 0
      error_message = "The aws region cannot be an empty string"
    }
  
}

variable "bucket_name" {

    type = string
    description = "Globally-unique S3 bucket name."
    nullable = false
  
}

variable "bucket_tags" {

  type = object({
    Domain = string
    Environment = string 
  })

  default = {
    Domain = "raw"
    Environment = "dev"
  }
  nullable = false
  description = "Tags for s3 bucket."
  
}

variable "bucket_force_destroy" {

  type = bool
  description = "Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error"
  default = false
  
}

variable "bucket_versioning_status" {
  type = string
  description = "Versioning state of the bucket."
  
  
}


# lifecycle rules

variable "noncurrent_v_lifecycle_rules" {

  type = list(
      object({
        id = string
        status= string
        prefix = optional(string, null)
        tags = optional(map(string), null)
        noncurrent_version_transition = list(object({
          noncurrent_days = number
          storage_class = string 
        }))
        noncurrent_version_expiration = optional(object({
          noncurrent_days = number 
        }), null)
       })
  )
  
}

variable "sse_algorithm" {

  type = string
  description = "value"
  nullable = false

}


variable "kms_key_alias" {

    type = string
    description = "The alias of exisitng KMS key used to encrypt data in s3 bucket"

    nullable = false

    validation {
      condition = length(trimspace(var.kms_key_alias)) > 0
      error_message = "Kms key alias cannot be an empty string"
    }
  
}
