variable "lambda_arn" {
  type    = string
  default = ""
}

variable "sns_subscriptions" {
    type = map(object({
    protocol = string
    endpoint = string
  }))

#   default = [
#     {
#       protocol = ""
#       endpoint = ""
#     },
#     {
#       protocol = ""
#       endpoint = ""
#     }
#   ]
default = {
  "lambda_subscription" = {
      protocol = ""
      endpoint = ""
    },
    "email_subscription" = {
      protocol = ""
      endpoint = ""
    }
}
}