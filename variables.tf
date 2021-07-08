variable "command_unix" {
  description = "The command to check for on unix-based systems. If not provided, the `command_windows` variable will be used."
  type        = string
  default     = null
}

variable "command_windows" {
  description = "The command to check for on Windows systems. If not provided, the `command_unix` variable will be used."
  type        = string
  default     = null
}

variable "fail_if_command_missing" {
  description = "Whether to fail the Terraform plan/apply if the given command isn't available."
  type        = bool
  default     = false
}

variable "working_dir" {
  description = "The directory to check for the command in. Defaults to the module directory."
  type        = string
  default     = null
}
