module "test_exists" {
  source          = "../"
  command_unix    = "echo"
  command_windows = "Write-Output"
}

module "check_test_exists" {
  source        = "Invicton-Labs/assertion/null"
  version       = "~>0.2.1"
  condition     = module.test_exists.exists
  error_message = "The `${module.test_exists.command}` command was not found, but we expected to find it."
}

module "test_not_exists" {
  source                  = "../"
  command_unix            = "somerandomcommandthatcantpossiblyexist"
  command_windows         = "Some-Random-Command-That-Cant-Possibly-Exist"
  fail_if_command_missing = false
}

module "check_test_not_exists" {
  source        = "Invicton-Labs/assertion/null"
  version       = "~>0.2.1"
  condition     = !module.test_not_exists.exists
  error_message = "The `${module.test_not_exists.command}` command was found, but we expected not to find it."
}

output "checked" {
  value = module.check_test_exists.checked && module.check_test_not_exists.checked
}
