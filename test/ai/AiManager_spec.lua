local AiManager = require 'ai/AiManager'
local vector_to_unit_vector = require 'math/vector_to_unit_vector'
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

  local function given_the_ai_manager_is_initialized_with_two_bots()
    ai1.init:should_be_called():
    and_also(ai2.init:should_be_called()):
    when(function()
      ai_manager = AiManager(bots, { ai1, ai2 })
    end)
  end

  local function given_the_ai_manager_is_initialized_with_one_bot()
    ai1.init:should_be_called():
    when(function()
      ai_manager = AiManager(bots, { ai1 })
    end)
  end

  local function an_update_occurs_after(dt)
    ai_manager.update(dt)
  end

  it('should call each ai upon update and return their moves', function()
    given_the_ai_manager_is_initialized_with_two_bots()

    ai1.update:should_be_called_with(bots, 1, dt):
    and_will_return(a_move):
    and_also(ai2.update:should_be_called_with(bots, 2, dt)):
    and_will_return(another_move):
    when(function()
      local moves = ai_manager.update(dt)
      assert.are.same({ a_move, another_move }, moves)
    end)
  end)

  it('should restrict force to a multiple of the unit vector', function()
    given_the_ai_manager_is_initialized_with_two_bots()

    ai1.update:should_be_called_with_any_arguments():
    and_will_return({ force = { x = 400, y = 400 }}):
    and_also(ai2.update:should_be_called_with_any_arguments()):
    and_will_return({ force = { x = -30, y = 0 } }):
    when(function()
      local moves = ai_manager.update(dt)
      assert.are.same({
        { force = vector_to_unit_vector({ x = 400, y = 400 }) },
        { force = vector_to_unit_vector({ x = -30, y = 0 }) }
        }, moves)
    end)

  end)

  it('should vary speed based on the ai speed stat', function()
  end)

  it('should vary health based on the ai health stat', function()
  end)

  it('should vary firing rate based on the ai firing rate stat', function()
  end)

  it('should vary damage based on the ai damage stat', function()
  end)

  it('should vary health based on the ai health stat', function()
  end)

end)
