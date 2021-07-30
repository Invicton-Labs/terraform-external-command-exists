terraform {
  required_version = ">= 0.13.0"
}

locals {
  is_windows      = dirname("/") == "\\"
  command_windows = var.command_windows != null ? var.command_windows : var.command_unix
  command_unix    = var.command_unix != null ? var.command_unix : var.command_windows
  command         = local.is_windows ? local.command_windows : local.command_unix
  exists          = local.is_windows ? tobool(lower(module.command_exists.stdout)) : module.command_exists.stdout == "0"
}

// Ensure that at least one command is provided
module "asset_command_provided" {
  source        = "Invicton-Labs/assertion/null"
  version       = "0.2.1"
  error_message = "At least one of the `command_unix` or `command_windows` input variable must be provided."
  condition     = var.command_unix != null || var.command_windows != null
}

module "command_exists" {
  source          = "Invicton-Labs/shell-data/external"
  version         = "0.2.1"
  command_unix    = "command -v \"$COMMAND\" >/dev/null 2>&1; echo $?"
  command_windows = "[bool](Get-Command -Name \"$Env:COMMAND\" -ErrorAction SilentlyContinue)"
  working_dir     = var.working_dir != null ? var.working_dir : path.module
  fail_on_error   = true
  environment = {
    COMMAND = local.command
  }
}

// Ensure that the command exists, in order to fail Terraform if desired
module "asset_command_exists" {
  source        = "Invicton-Labs/assertion/null"
  version       = "0.2.1"
  error_message = "The command \"${local.command}\" is not available in ${local.is_windows ? "PowerShell" : "the shell"}."
  // Only check the condition if we should fail if it's missing
  condition = var.fail_if_command_missing ? local.exists : true
}
