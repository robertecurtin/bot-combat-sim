local Timer = require 'timer/Timer'
local mach = require 'mach'

describe('Timer', function()
  local timer

  local some_callback = mach.mock_function('some_callback')
  local with_some_callback = some_callback

  local some_other_callback = mach.mock_function('some_other_callback')
  local with_some_other_callback = some_other_callback

  local four_seconds = 4
  local after_four_seconds = four_seconds

  local three_seconds = 3
  local after_three_seconds = three_seconds

  local two_seconds = 2
  local after_two_seconds = two_seconds

  local one_second = 1
  local after_one_second = one_second

  local a_split_second = 0.00001

  local function given_the_timer_has_been_initialized()
    timer = Timer()
  end
  local function given_a_timer_has_been_started_for(time, callback)
    timer.start(time, callback)
  end

  local function nothing_should_happen(timer)
  end

  local function after(dt)
    timer.tick(dt)
  end

  local function it_should_call_callback_after(callback, time)
    callback:should_be_called():when(function()
      after(time)
    end)
  end

  local function it_should_call(callback, time)
    nothing_should_happen()
    after(time - a_split_second)
    it_should_call_callback_after(callback, a_split_second)
  end

  it('should call back when a timer expires', function()
    given_the_timer_has_been_initialized()
    given_a_timer_has_been_started_for(three_seconds, with_some_callback)

    it_should_call(some_callback, after_three_seconds)
  end)

  it('should call back when a timer expires', function()
    given_the_timer_has_been_initialized()
    given_a_timer_has_been_started_for(three_seconds, with_some_callback)

    it_should_call(some_callback, after_three_seconds)
  end)

  it('should call back multiple timers', function()
    given_the_timer_has_been_initialized()
    given_a_timer_has_been_started_for(two_seconds, with_some_callback)
    given_a_timer_has_been_started_for(one_second, with_some_other_callback)

    it_should_call(some_other_callback, after_one_second)
    it_should_call(some_callback, after_one_second)
  end)

  it('should call back a timer when extra time has passed', function()
    given_the_timer_has_been_initialized()
    given_a_timer_has_been_started_for(two_seconds, with_some_callback)

    it_should_call_callback_after(some_callback, after_three_seconds)
  end)
end)
