variable "lab_role_arn" {
  description = "ARN of the LabRole role"
  type        = string
  default = "arn:aws:iam::861115334572:role/LabRole"
}

variable "requests_layer_arn" {
  description = "ARN da Lambda Layer do requests já existente na conta AWS"
  type        = string
  default = "arn:aws:lambda:us-east-1:861115334572:layer:requests:12"
} 