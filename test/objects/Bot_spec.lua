local Bot = require('objects/Bot')
local mach = require('mach')

describe('Bot', function()
  local world = {}
  local body = {}
  local shape = {}

  local bot
  local love = {
    physics = {
      newBody = mach.mock_function('newBody'),
      newCircleShape = mach.mock_function('newCircleShape'),
    }
  }

  local Alive = true
  local Dead = false

  local function given_the_bot_is_initialized_with(name, x, y, team)
      love.physics.newBody:
        should_be_called_with(world, x, y, 'dynamic'):
        and_will_return(body):
        and_also(love.physics.newCircleShape:should_be_called_with_any_arguments()):
        and_will_return(shape):
        when(function()
          bot = Bot(love, world, name, x, y, team)
      end)
  end

local function the_name_should_be(expected)
  assert.are.same(expected, bot.data.name)
end

local function the_category_should_be(expected)
  assert.are.same(expected, bot.data.category)
end

local function the_graphics_type_should_be(expected)
  assert.are.same(expected, bot.data.graphicsType)
end

local function it_should_have_a_restitution_value()
  assert.are.are_not_equal(null, bot.restitution)
end

local function it_should_have_a_mass()
  assert.are.are_not_equal(null, bot.mass)
end

local function it_should_be(alive)
  assert.are.equal(not alive, bot.data.is_marked_for_deletion())
end

  it('should initialize provided default values', function()
    given_the_bot_is_initialized_with('some name', 3, 4, 'team1')
    the_name_should_be('some name')
    the_category_should_be('team1')
    the_graphics_type_should_be('circle')
    it_should_have_a_restitution_value()
    it_should_have_a_mass()
    it_should_be(Alive)
  end)

  it('should initialize different default values', function()
    given_the_bot_is_initialized_with('another name', 3, 4, 'team2')
    the_name_should_be('another name')
    the_category_should_be('team2')
  end)
end)
