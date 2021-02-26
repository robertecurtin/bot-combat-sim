local Bot = require 'objects/Bot'
local mach = require 'mach'

describe('Bot', function()
  local bot

  local body = { getPosition = mach.mock_function('GetPosition') }

  local ALIVE = true
  local DEAD = false

  local function given_the_bot_is_initialized_with(c)
    bot = Bot(body, {}, c.name, c.team, c.health)
  end

  local function when_its_health_is_set_to(health)
    bot.data.set_health(health)
  end

  local function its_name_should_be(expected)
    assert.are.same(expected, bot.data.name)
  end

  local function its_category_should_be(expected)
    assert.are.same(expected, bot.data.category)
  end

  local function its_graphics_type_should_be(expected)
    assert.are.same(expected, bot.data.graphicsType)
  end

  local function its_health_should_be(expected)
    assert.are.same(expected, bot.data.get_health())
  end

  local function its_position_should_be(expected)
    assert.are.same(expected, bot.data.get_position())
  end

  local function it_should_have_a_restitution_value()
    assert.are.are_not_equal(null, bot.restitution)
  end

  local function it_should_have_a_mass()
    assert.are.are_not_equal(null, bot.mass)
  end

  local function it_should_be(alive)
    assert.are.equal(alive, bot.data.is_alive())
  end

  it('should initialize using the provided default values', function()
    given_the_bot_is_initialized_with({
      name = 'some name',
      team = 'Team 1',
      health = 1
    })
    its_name_should_be('some name')
    its_category_should_be('Team 1')
    its_graphics_type_should_be('circle')
    it_should_have_a_restitution_value()
    it_should_have_a_mass()
    it_should_be(ALIVE)
  end)

  it('should initialize different default values', function()
    given_the_bot_is_initialized_with({
      name = 'another name',
      team = 'Team 2',
      health = 5
    })
    its_name_should_be('another name')
    its_category_should_be('Team 2')
  end)

  it('should update its health when it is set', function()
    given_the_bot_is_initialized_with({
      name = 'another name',
      team = 'Team 2',
      health = 5
    })
    when_its_health_is_set_to(5)
    its_health_should_be(5)
  end)

  it('should die when it loses all its health', function()
    given_the_bot_is_initialized_with({
      name = '',
      team = 'Team 2',
      health = 2
    })
    when_its_health_is_set_to(1)
    it_should_be(ALIVE)
    when_its_health_is_set_to(0)
    it_should_be(DEAD)
  end)

  it('should provide access to its current position', function()
    given_the_bot_is_initialized_with({
      name = '',
      team = 'Team 2',
      health = 2
    })
    body.getPosition:should_be_called_with(body):
    and_will_return(3, 4):
    when(function()
      its_position_should_be({ x = 3, y = 4 })
    end)
  end)
end)
