# Command Exists
Determines whether a given command is available on the CLI (Linux shell or Windows PowerShell). During a `terraform import`, it will return `null` (since the external data source isn't run during an import).

Usage:

```
// Check if Git is installed and available
module "command_exists" {
  source       = "Invicton-Labs/command-exists/external"
  
  // The command to look for on Unix systems
  command_unix = "git"
  
  // The command to look for on Windows systems
  // This is technically not required because if only `command_unix` or `command_windows` is specified,
  // it will be used on both operating system types
  command_windows = "git"
  
  // Specify the working directory if the command is not installed system-wide
  working_dir = path.root
  
  // If Git isn't installed, fail Terraform so that nothing gets planned/applied
  fail_if_command_missing = true
}

output "command_exists" {
  value = module.command_exists
}
```

```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

command_exists = {
  "exists" = true
}
```
