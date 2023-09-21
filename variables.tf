# Define a variable to hold the instance name
variable "prefix" {
  description = "Name for the RDS instance"
  default     = "default" # Provide a default value if needed
}

variable "enginetype" {
  description = "Type of the RDS instance"
  default     = "postgres" # Provide a default value if needed
}

variable "engineversion" {
  description = "Type of the RDS instance"
  default     = "15.4" # Provide a default value if needed
}
