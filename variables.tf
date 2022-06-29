variable "command_unix" {
  description = "The command to check for on unix-based systems. If not provided, the `command_windows` variable will be used."
  type        = string
  default     = null
  validation {
    condition     = var.command_unix == null ? true : length(replace(replace(replace(var.command_unix, "\r", ""), "\n", ""), "\r\n", "")) == length(var.command_unix)
    error_message = "The `command_unix` input variable, if provided, may not contain any newline (\\n) or carriage return (\\r) characters."
  }
}
locals {
  var_command_unix = var.command_unix
}

variable "command_windows" {
  description = "The command to check for on Windows systems. If not provided, the `command_unix` variable will be used."
  type        = string
  default     = null
  validation {
    condition     = var.command_windows == null ? true : length(replace(replace(replace(var.command_windows, "\r", ""), "\n", ""), "\r\n", "")) == length(var.command_windows)
    error_message = "The `command_windows` input variable, if provided, may not contain any newline (\\n) or carriage return (\\r) characters."
  }
}
locals {
  var_command_windows = var.command_windows
}

variable "fail_if_command_missing" {
  description = "Whether to fail the Terraform plan/apply if the given command isn't available."
  type        = bool
  default     = false
}
locals {
  var_fail_if_command_missing = var.fail_if_command_missing != null ? var.fail_if_command_missing : false
}

variable "working_dir" {
  description = "The directory to check for the command in. Defaults to the module directory."
  type        = string
  default     = null
}
locals {
  var_working_dir = var.working_dir
}
