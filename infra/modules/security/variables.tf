variable "sec_group_name" {
  
  type = string
  nullable = false
}

variable "sec_group_description" {

    type = string
    nullable = true
  
}

variable "sec_group_vpc_id" {
    type = string
    nullable = false
  
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}



# variable "sec_group_ingress_rule" {
#     type = map(object({
#        description = optional(string, " ")
#        from_port = number
#        to_port = number
#        ip_protocol = string
#        cidr_ipv4 = optional(string, null)
#        referenced_security_group_id = optional(string, null)
#     }))

#     validation {
#         condition = alltrue([
#             for _, r in var.sec_group_ingress_rule:
#                 # XOR (a != null) != (b != null)
#                 (try(r.cidr_ipv4, null) != null) != (try(r.referenced_security_group_id, null) != null)
#         ])
#         error_message = "Each ingress rule must set exactly one of cidr_ipv4 or referenced_security_group_id."
      
#     }
  
# }

# variable "sec_group_egress_rule" {
#     type = map(object({
#        description = optional(string, " ")
#        from_port = number
#        to_port = number
#        ip_protocol = string
#        cidr_ipv4 = optional(string, null)
#        referenced_security_group_id = optional(string, null)
#     }))

#     validation {
#         condition = alltrue([
#             for _, r in var.sec_group_egress_rule:
#                 # XOR 
#                 (try(r.cidr_ipv4, null) != null) != (try(r.referenced_security_group_id, null) != null)

#         ])
#         error_message = "Each egress rule must set exactly one of cidr_ipv4 or referenced_security_group_id."
      
#     }
  
# }

