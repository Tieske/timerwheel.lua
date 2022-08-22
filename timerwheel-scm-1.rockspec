local package_name = "timerwheel"
local package_version = "scm"
local rockspec_revision = "1"
local github_account_name = "Tieske"
local github_repo_name = package_name .. ".lua"


package = package_name
version = package_version.."-"..rockspec_revision
source = {
  url = "git+https://github.com/"..github_account_name.."/"..github_repo_name..".git",
  branch = (package_version == "scm") and "master" or nil,
  tag = (package_version ~= "scm") and package_version or nil,
}
description = {
  summary = "Timers based on a timerwheel",
  detailed = [[
    Creating and deleting is very fast. Typically suited for
    setting timeouts, which usually do not execute.
  ]],
  homepage = "https://github.com/"..github_account_name.."/"..github_repo_name,
  license = "MIT"
}
dependencies = {
  "lua >= 5.1, < 5.5",
  "coxpcall",
}
build = {
  type = "builtin",
  modules = {
    ["timerwheel.init"] = "src/timerwheel/init.lua",
  },
  copy_directories = {
    "docs",
  },
}
