package = "timerwheel"
version = "scm-1"
source = {
  url = "git://github.com/Tieske/timerwheel.lua",
  --tag = "0.1.0",
  branch = "master",
}
description = {
  summary = "Timers based on a timerwheel",
  detailed = [[
    Creating and deleting is very fast. Typically suited for
    setting timeouts, which usually do not execute.
  ]],
  homepage = "https://github.com/Tieske/timerwheel.lua",
  license = "MIT"
}
dependencies = {
  "lua >= 5.1, < 5.4",
  "coxpcall",
}
build = {
  type = "builtin",
  modules = {
    ["timerwheel.init"] = "src/timerwheel.lua",
  },
}
