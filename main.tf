locals {
  is_windows      = dirname("/") == "\\"
  command_windows = local.var_command_windows != null ? local.var_command_windows : local.var_command_unix
  command_unix    = local.var_command_unix != null ? local.var_command_unix : local.var_command_windows
  command         = local.is_windows ? local.command_windows : local.command_unix
  stdout          = module.command_exists.stdout != "" ? module.command_exists.stdout : (local.is_windows ? "True" : "0")
  exists          = module.command_exists.stdout != "" ? local.is_windows ? tobool(lower(module.command_exists.stdout)) : module.command_exists.stdout == "0" : null
}

// Ensure that at least one command is provided
module "assert_command_provided" {
  source        = "Invicton-Labs/assertion/null"
  version       = "~> 0.2.1"
  error_message = "At least one of the `command_unix` or `command_windows` input variable must be provided."
  condition     = local.var_command_unix != null || local.var_command_windows != null
}

module "command_exists" {
  source          = "Invicton-Labs/shell-data/external"
  version         = "~> 0.2.1"
  command_unix    = "command -v \"$COMMAND\" >/dev/null 2>&1; echo $?"
  command_windows = "[bool](Get-Command -Name \"$Env:COMMAND\" -ErrorAction SilentlyContinue)"
  working_dir     = local.var_working_dir != null ? local.var_working_dir : path.module
  fail_on_error   = true
  environment = {
    COMMAND = local.command
  }
}

// Ensure that the command exists, in order to fail Terraform if desired
module "asset_command_exists" {
  source        = "Invicton-Labs/assertion/null"
  version       = "~> 0.2.1"
  error_message = "The command \"${local.command}\" is not available in ${local.is_windows ? "PowerShell" : "the shell"}."
  // Only check the condition if we should fail if it's missing
  condition = local.var_fail_if_command_missing ? (local.exists == null ? true : local.exists) : true
}
