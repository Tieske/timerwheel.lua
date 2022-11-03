_G._TEST = true    -- instruct for extra exports for test purposes
local tw = require "timerwheel"

-- make sure luasocket is installed when tesing
assert(
  (pcall(require, "socket")),
  "LuaSocket must be installed to run the test suite"
)

describe("Timerwheel", function()


  local set_time, now
  do
    local _time
    set_time = function(t)
      assert(type(t) == "number", "expected number")
      assert(t > _time, "new time should be greater than old time")
      _time = t
    end
    now = function()
      return _time
    end
    before_each(function()
      _time = 0
    end)
  end

  describe("new()", function()

    it("succeeds without options", function()
      local wheel = tw.new()
      assert.is_table(wheel)
      assert.is_function(wheel.step)
    end)


    it("fails with bad options", function()
      local function factory(opts)
        return function()
          tw.new(opts)
        end
      end
      assert.has_error(function() tw:new() end,
        "new should not be called with colon ':' notation")
      assert.has_error(factory {precision = -0.3},
        "expected 'precision' to be number > 0")
      assert.has_error(factory {precision = 0},
        "expected 'precision' to be number > 0")
      assert.has_error(factory {ringsize = -1},
        "expected 'ringsize' to be an integer number > 0")
      assert.has_error(factory {ringsize = 0},
        "expected 'ringsize' to be an integer number > 0")
      assert.has_error(factory {ringsize = 1.5},
        "expected 'ringsize' to be an integer number > 0")
      assert.has_error(factory {now = "hello"},
        "expected 'now' to be a function, got: string")
      assert.has_error(factory {err_handler = "hello"},
        "expected 'err_handler' to be a function, got: string")
    end)


    it("succeeds with proper options", function()
      local wheel = tw.new {
        precision = 0.5,
        ringsize = 10,
        now = function() end,
        err_handler = function() end,
      }
      assert.is_table(wheel)
      assert.is_function(wheel.step)
    end)

  end)



  describe("set() and step()", function()

    local wheel, precision, ringsize = nil, 1, 10

    before_each(function()
      wheel = assert(tw.new({
          now = now,
          precision = precision,
          ringsize = ringsize,
      }))
    end)


    it("sets a timer", function()
      local count = 0
      local id = wheel:set(0.5, function() count = count + 1 end)
      assert.is.equal(-1, id)
      assert.is.equal(1, wheel:count())
      set_time(1)
      wheel:step()
      assert.is.equal(1, count)
      assert.is.equal(0, wheel:count())
    end)


    it("sets a timer and passes the argument", function()
      local count = 0
      local arg = {}
      local id = wheel:set(0.5, function(cb_arg)
        assert.are.equal(arg, cb_arg)
        count = count + 1
      end, arg)
      assert.is.equal(-1, id)
      set_time(1)
      wheel:step()
      assert.is.equal(1, count)
    end)


    it("doesn't fail on a callback error", function()
      wheel = assert(tw.new({
          now = now,
          precision = precision,
          ringsize = ringsize,
          err_handler = function() end,  -- drop the error
      }))

      local id = wheel:set(0.5, function() error() end)
      assert.is.equal(-1, id)
      set_time(1)
      assert.has.no.error(function() wheel:step() end)
    end)


    it("sets 10 timers", function()
      local count = 0
      local cb = function() count = count + 1 end
      for i = 0, 9 do
        local id = wheel:set(i + 0.5, cb)
        assert.is.equal(-1-i, id)
      end
      for i = 1, 10 do
        set_time(i)
        wheel:step()
        assert.is.equal(i, count)
      end
    end)


    it("sets 10 timers and reuses the tables", function()
      local count = 0
      local cb = function() count = count + 1 end
      for i = 0, 9 do
        local id = wheel:set(i + 0.5, cb)
        assert.is.equal(-1-i, id)
      end
      for i = 1, 10 do
        set_time(i)
        wheel:step()
        assert.is.equal(i, count)
      end
      -- do the same again
      for i = 0, 9 do
        local id = wheel:set(i + 0.5, cb)
        assert.is.equal(-1-i-10, id)
      end
      for i = 11, 20 do
        set_time(i)
        wheel:step()
        assert.is.equal(i, count)
      end
      -- check reused tables
      assert.equal(10, #wheel._tables)
      for _, t in ipairs(wheel._tables) do
        assert.same({ arg = {}, ids = {}, n = 0 }, t)
      end
    end)


    it("sets a timer in the past", function()
      local count = 0
      local id = wheel:set(-0.5, function() count = count + 1 end)
      assert.is.equal(-1, id)

      set_time(1)
      wheel:step()
      assert.is.equal(1, count)
    end)


    it("sets a timer on the old edge", function()
      local count = 0
      local id = wheel:set(0, function() count = count + 1 end)
      assert.is.equal(-1, id)

      set_time(1)
      wheel:step()
      assert.is.equal(1, count)
    end)


    it("sets a timer on the new edge", function()
      local count = 0
      local id = wheel:set(1, function() count = count + 1 end)
      assert.is.equal(-1, id)

      set_time(1)
      wheel:step()
      assert.is.equal(0, count)

      set_time(2)
      wheel:step()
      assert.is.equal(1, count)
    end)


    it("sets timers over the ring edge", function()
      local count = 0
      local cb = function() count = count + 1 end
      for i = 0, 10 * ringsize - 1 do
        local id = wheel:set(i + 0.5, cb)
        assert.is.equal(-1-i, id)
      end
      for i = 1, 10 * ringsize do
        set_time(i)
        wheel:step()
        assert.is.equal(i, count)
      end
    end)


    it("sets timers, skipping over empty rings", function()
      local count = 0
      local cb = function() count = count + 1 end
      local total = 10 * ringsize
      for i = 0, total - 1 do
        if i >= total/2 then  -- skip first half == multiple rings
          assert(wheel:set(i + 0.5, cb))
        end
      end
      for i = 1, total do
        set_time(i)
        wheel:step()
      end
      assert.is.equal(total/2, count)
    end)


    it("doesn't execute before edge, but on/after edge", function()
      local count = 0
      local id = wheel:set(0.5, function() count = count + 1 end)
      assert.is.equal(-1, id)

      set_time(0.99999)
      wheel:step()
      assert.is.equal(0, count)

      set_time(1)
      wheel:step()
      assert.is.equal(1, count)
    end)


    it("callback and args gets GC'ed after executing", function()
      local count = 0
      local cb = function() count = count + 1 end
      local arg = {}
      local check_table = setmetatable({
          value1 = cb,
          value2 = arg,
        }, {
          __mode = "v"
        })
      local id = wheel:set(0.5, cb, arg)
      assert.is.equal(-1, id)

      cb = nil     -- luacheck: ignore
      arg = nil    -- luacheck: ignore
      collectgarbage()
      collectgarbage()
      assert.is.Not.Nil(next(check_table))

      set_time(1)
      wheel:step()
      assert.is.equal(1, count)

      collectgarbage()
      collectgarbage()
      assert.is.Nil(next(check_table))
    end)


    it("calls the error handler on an error", function()
      local err_count = 0
      wheel = assert(tw.new({
          now = now,
          precision = precision,
          ringsize = ringsize,
          err_handler = function(err) err_count = err_count + 1 end,
      }))
      local id = wheel:set(0.5, function() error() end)
      assert.is.equal(-1, id)
      set_time(1)
      wheel:step()
      assert.is.equal(1, err_count)
    end)

  end)



  describe("peek()", function()

    local wheel, precision, ringsize = nil, 1, 10

    before_each(function()
      wheel = assert(tw.new({
          now = now,
          precision = precision,
          ringsize = ringsize,
      }))
    end)


    it("returns time to execution", function()
      assert.is.Nil(wheel:peek()) -- on empty wheel

      local count = 0
      wheel:set(0.5, function() count = count + 1 end)
      assert.is.near(1, wheel:peek(), 0.00001)
      assert.is.Nil(wheel:peek(0.999))

      set_time(0.9)
      assert.is.near(0.1, wheel:peek(), 0.00001)
      assert.is.Nil(wheel:peek(0.0999))
    end)


    it("returns time to execution from last slot", function()
      local count = 0
      wheel:set(9.5, function() count = count + 1 end)
      assert.is.near(10, wheel:peek(), 0.00001)
      assert.is.Nil(wheel:peek(9.999))

      set_time(9.9)
      assert.is.near(0.1, wheel:peek(), 0.00001)
      assert.is.Nil(wheel:peek(0.0999))
    end)


    it("returns time to execution a few (empty) rings ahead", function()
      local count = 0
      wheel:set(109.5, function() count = count + 1 end)
      assert.is.near(110, wheel:peek(), 0.00001)
      assert.is.Nil(wheel:peek(109.999))

      set_time(109.9)
      assert.is.near(0.1, wheel:peek(), 0.00001)
      assert.is.Nil(wheel:peek(0.0999))
    end)


    it("returns time to execution in the past", function()
      local count = 0
      wheel:set(0.5, function() count = count + 1 end)
      set_time(100)
      assert.is.near(-99, wheel:peek(), 0.00001)
    end)

  end)



  describe("cancel()", function()

    local wheel, precision, ringsize = nil, 1, 10

    before_each(function()
      wheel = assert(tw.new({
          now = now,
          precision = precision,
          ringsize = ringsize,
      }))
    end)


    it("removes a timer", function()
      local count = 0
      local id = wheel:set(0.5, function() count = count + 1 end)
      assert.is.equal(1, wheel:count())
      assert.is.True(wheel:cancel(id))

      set_time(1)
      wheel:step()
      assert.is.equal(0, count)
      assert.is.equal(0, wheel:count())

      -- check reusable tables
      assert.equal(1, #wheel._tables)
      assert.same({ arg = {}, ids = {}, n = 0 }, wheel._tables[1])
    end)


    it("removes a non-existing timer", function()
      local id = "something bad"
      assert.is.False(wheel:cancel(id))
    end)


    it("removes timers, leaving holes in the slot", function()
      local called = {}
      local id1 = wheel:set(0.5, function(arg) called[#called+1] = arg end, "id1")
      local _   = wheel:set(0.5, function(arg) called[#called+1] = arg end, "id2")
      local id3 = wheel:set(0.5, function(arg) called[#called+1] = arg end, "id3")
      local _   = wheel:set(0.5, function(arg) called[#called+1] = arg end, "id4")
      local id5 = wheel:set(0.5, function(arg) called[#called+1] = arg end, "id5")
      assert.is.equal(5, wheel:count())
      assert.is.True(wheel:cancel(id1))
      assert.is.True(wheel:cancel(id3))
      assert.is.True(wheel:cancel(id5))

      set_time(1)
      wheel:step()

      table.sort(called)
      assert.is.equal(2, #called)
      assert.is.same({ "id2", "id4" }, called)

      -- check reused tables
      assert.equal(1, #wheel._tables)
      assert.same({ arg = {}, ids = {}, n = 0 }, wheel._tables[1])
    end)


    it("callback and args gets GC'ed after cancelling", function()
      local count = 0
      local cb = function() count = count + 1 end
      local arg = {}
      local check_table = setmetatable({
          value1 = cb,
          value2 = arg,
        }, {
          __mode = "v"
        })
      local id = wheel:set(0.5, cb, arg)

      cb = nil     -- luacheck: ignore
      arg = nil    -- luacheck: ignore
      collectgarbage()
      collectgarbage()
      assert.is.Not.Nil(next(check_table))


      wheel:cancel(id)
      collectgarbage()
      collectgarbage()

      assert.is.Nil(next(check_table))
    end)

  end)

end)
