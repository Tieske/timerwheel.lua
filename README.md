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

```
Copyright 2018 Thijs Schreijer.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

History
=======

0.1 xx-xxx-2018

- Initial version
