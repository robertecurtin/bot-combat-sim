local AiManager = require 'ai/AiManager'
local mach = require 'mach'

describe('AiManager', function()
  local ai_manager

  local ai1 = {
    init = mach.mock_function('ai1_init'),
    update = mach.mock_function('ai1_update')
  }
  local ai2 = {
    init = mach.mock_function('ai2_init'),
    update = mach.mock_function('ai2_update')
  }
  local stats1 = mach.mock_function('stats1')
  local stats2 = mach.mock_function('stats1')
  local config = { ai1, ai2 }

  local a_move = {
    force = { x = 1, y = -1 },
    target = { x = 3, y = -5 },
    fire = true
  }

  local another_move = {
    force = { x = -0.4, y = .74 },
    target = { x = -3000.98, y = 5.72 },
    fire = true
  }

  local bots = {}

  local function given_the_ai_manager_is_initialized()
    ai1.init:should_be_called():
    and_also(ai2.init:should_be_called()):
    when(function()
      ai_manager = AiManager(bots, config)
    end)
  end

  local function an_update_occurs_after(dt)
    ai_manager.update(dt)
  end

  it('should init', function()
    given_the_ai_manager_is_initialized()
  end)

  it('should call each ai upon update and return their moves', function()
    given_the_ai_manager_is_initialized()

    ai1.update:should_be_called_with(bots, 1, dt):
    and_will_return(a_move):
    and_also(ai2.update:should_be_called_with(bots, 2, dt)):
    and_will_return(another_move):
    when(function()
      local moves = ai_manager.update(dt)
      assert.are.same({ a_move, another_move }, moves)
    end)
  end)

  it('should restrict movement to a multiple of the unit vector', function()
    given_the_ai_manager_is_initialized()
  end)

  it('should vary speed based on the ai speed stat', function()
    given_the_ai_manager_is_initialized()
  end)

  it('should vary health based on the ai health stat', function()
    given_the_ai_manager_is_initialized()
  end)

  it('should vary firing rate based on the ai firing rate stat', function()
    given_the_ai_manager_is_initialized()
  end)

  it('should vary damage based on the ai damage stat', function()
    given_the_ai_manager_is_initialized()
  end)

  it('should vary health based on the ai health stat', function()
    given_the_ai_manager_is_initialized()
  end)

end)
