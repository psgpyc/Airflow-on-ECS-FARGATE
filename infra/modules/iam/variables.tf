variable "iam_role_name" {

    type = string
    nullable = false

    validation {
      condition = length(trimspace(var.iam_role_name)) > 0
      error_message = "I am role name cannot be empty."
    }
  
}


variable "iam_role_description" {

    type = string
    nullable = false

    validation {
      condition = length(trimspace(var.iam_role_description)) > 0
      error_message = "I am role description  cannot be empty."
    }
  
}


variable "assume_role_policy" {
    type = string
    nullable = false

    validation {
      condition = (
        length(trimspace(var.assume_role_policy)) > 0
        &&
        can(jsonencode(var.assume_role_policy))
      )
      error_message = "Assume role policy must be a valid JSON & cannot be empty."
    }
  
}

variable "assume_role_max_session_duration" {
    type = number
    nullable = false
    default = 3600

    validation {
      condition = var.assume_role_max_session_duration >= 3600 && var.assume_role_max_session_duration <= 43200
      error_message = "The session duration value must be a number between 3600(1 hr) and 43200(12 hr)."
    }
  
}

variable "tags" {

    type = map(string)
    default = {}
  
}


variable "iam_role_policy" {

    type = string
    nullable = false

    validation {
      condition = (
        length(trimspace(var.iam_role_policy)) > 0
        &&
        can(jsonencode(var.iam_role_policy))
      )
      error_message = "IAM role policy must be a valid JSON & cannot be empty."
    }
}