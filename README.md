[![Build Status](https://travis-ci.com/Tieske/timerwheel.lua.svg?branch=master)](https://travis-ci.com/Tieske/timerwheel.lua)
[![Coverage Status](https://coveralls.io/repos/github/Tieske/timerwheel.lua/badge.svg?branch=master)](https://coveralls.io/github/Tieske/timerwheel.lua?branch=master)


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

## 0.1.0 released 01-Feb-2020

  - Initial released version
