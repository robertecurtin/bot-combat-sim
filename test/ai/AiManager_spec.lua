local AiManager = require 'ai/AiManager'
local vector_to_unit_vector = require 'math/vector_to_unit_vector'
local mach = require 'mach'

describe('AiManager', function()
  local ai_manager

  local ai1_update = mach.mock_function('ai1_update')
  local ai1 = function()
    return {
      speed = 1,
      update = ai1_update
    }
  end

  local ai2_update = mach.mock_function('ai2_update')
  local ai2 = function()
    return {
      speed = 1,
      update = ai2_update
    }
  end

  local stats1 = mach.mock_function('stats1')
  local stats2 = mach.mock_function('stats1')

  local a_move = {
    force = { x = 1, y = -1 },
    target = { x = 3, y = -5 }
  }

  local another_move = {
    force = { x = -0.4, y = .74 },
    target = { x = -3000.98, y = 5.72 }
  }

  local bots = {
    { set_health = mach.mock_function('set_health') },
    { set_health = mach.mock_function('set_health') },
  }

  local function given_the_ai_manager_is_initialized_with_two_bots()
    ai_manager = AiManager(bots, { ai1, ai2 })
  end

  local function given_the_ai_manager_is_initialized_with_this_ai(ai)
    ai_manager = AiManager(bots, { ai })
  end

  local function an_update_occurs_after(dt)
    ai_manager.update(dt)
  end

  local function this_bots_health_should_be(i, health)
    assert.are.same(health, ai_manager.stats[i].health)
  end

  it('should call each ai upon update and return their moves', function()
    given_the_ai_manager_is_initialized_with_two_bots()

    ai1_update:should_be_called_with(bots, 1, dt):
      and_will_return(a_move):
      and_also(ai2_update:should_be_called_with(bots, 2, dt)):
      and_will_return(another_move):
      when(function()
        local moves = ai_manager.update(dt)
        assert.are.same({ a_move, another_move }, moves)
      end)
  end)

  it('should restrict force to a multiple of the unit vector', function()
    given_the_ai_manager_is_initialized_with_two_bots()

    ai1_update:should_be_called_with_any_arguments():
      and_will_return({ force = { x = 400, y = 400 }}):
      and_also(ai2_update:should_be_called_with_any_arguments()):
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
    local update = mach.mock_function('update')
    local ai = function() return
      {
        speed = 2,
        health = 1,
        update = update
      }
    end
    given_the_ai_manager_is_initialized_with_this_ai(ai)

    update:should_be_called_with_any_arguments():
      and_will_return({ force = { x = 1, y = 0 }}):
      when(function()
        local moves = ai_manager.update(dt)
        assert.are.same({ x = 2, y = 0 }, moves[1].force)
      end)
  end)

  it('should expose health based on the ai health stat', function()
    local update = mach.mock_function('update')
    local ai = function() return {
      health = 3,
      update = update
    }
    end
  end)

  it('should vary firing rate based on the ai firing rate stat', function()
    end)

  it('should vary damage based on the ai damage stat', function()
    end)

  it('should vary health based on the ai health stat', function()
    end)

end)
