[![Unix build](https://img.shields.io/github/workflow/status/Tieske/timerwheel.lua/Unix%20build?label=Unix%20build&logo=linux)](https://github.com/Tieske/timerwheel.lua/actions/workflows/unix_build.yml)
[![Coveralls code coverage](https://img.shields.io/coveralls/github/Tieske/timerwheel.lua?logo=coveralls)](https://coveralls.io/github/Tieske/timerwheel.lua)
[![Lint](https://github.com/Tieske/timerwheel.lua/workflows/Lint/badge.svg)](https://github.com/Tieske/timerwheel.lua/actions/workflows/lint.yml)


timerwheel.lua
==============

Efficient timer for timeout related timers: fast insertion, deletion, and
execution (all as O(1) implemented), but with lesser precision.

This module will not provide the timer/runloop itself. Use your own runloop
and call `wheel:step` to check and execute timers.


Installation
============

Install through LuaRocks (`luarocks install timerwheel`) or from source, see the
[github repo](https://github.com/Tieske/timerwheel.lua).

Documentation
=============

The docs are [available online](https://tieske.github.io/timerwheel.lua/), or can
be generated using [Ldoc](http://stevedonovan.github.io/ldoc/). Just run
`"ldoc ."` from the repo.


Tests
=====

Tests are in the `spec` folder and can be executed using the
[busted test framework](http://olivine-labs.github.io/busted/). Just run
`"busted"` from the repo.

Besides that `luacheck` is configured for linting, just run `"luacheck ."` from
the repo. And if LuaCov is installed, the Busted test-run will result in a
coverage report (file `"luacov.report.out"`).


Copyright and License
=====================

See [LICENSE](https://github.com/Tieske/timerwheel.lua/blob/master/LICENSE).

History
=======

## 0.2.0 released 11-Feb-2020

  - Added `count` method to retrieve the current number of active timers

## 0.1.0 released 01-Feb-2020

  - Initial released version
