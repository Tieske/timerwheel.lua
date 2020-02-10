package = "timerwheel"
version = "0.1.0-2"
source = {
  url = "https://github.com/Tieske/timerwheel.lua/archive/0.1.0.tar.gz",
  dir = "timerwheel.lua-0.1.0",
  --tag = "0.1.0",
  --branch = "master",
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
  copy_directories = {"docs"}
}
