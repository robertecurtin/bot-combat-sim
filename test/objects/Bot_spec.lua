local Bot = require 'objects/Bot'
local mach = require 'mach'

describe('Bot', function()
  local bot
  local world = {}

  local body = { getPosition = mach.mock_function('GetPosition') }

  local ALIVE = true
  local DEAD = false

  local function given_the_bot_is_initialized_with(c)
    bot = Bot(body, {}, c.name, c.team, c.health)
  end

  local function when_it_collides_with_an_object_with_category(category)
    bot.data.collision_callback({ category = category })
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
    assert.are.same(expected, bot.data.health)
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
      team = 'team1',
      health = 1
    })
    its_name_should_be('some name')
    its_category_should_be('team1')
    its_graphics_type_should_be('circle')
    its_health_should_be(1)
    it_should_have_a_restitution_value()
    it_should_have_a_mass()
    it_should_be(ALIVE)
  end)

  it('should initialize different default values', function()
    given_the_bot_is_initialized_with({
      name = 'another name',
      team = 'team2',
      health = 5
    })
    its_name_should_be('another name')
    its_category_should_be('team2')
    its_health_should_be(5)
  end)

  it('should update its health when it is set', function()
    given_the_bot_is_initialized_with({
      name = 'another name',
      team = 'team2',
      health = 5
    })
    when_its_health_is_set_to(5)
    its_health_should_be(5)
  end)

  it('should take damage when it collides with a projectile', function()
    given_the_bot_is_initialized_with({
      name = '',
      team = 'team2',
      health = 5
    })
    when_it_collides_with_an_object_with_category('projectile')
    its_health_should_be(4)
    when_it_collides_with_an_object_with_category('projectile')
    its_health_should_be(3)
  end)

  it('should not take damage when it collides with another bot', function()
    given_the_bot_is_initialized_with({
      name = '',
      team = 'team2',
      health = 5
    })
    when_it_collides_with_an_object_with_category('team1')
    its_health_should_be(5)
    when_it_collides_with_an_object_with_category('team2')
    its_health_should_be(5)
  end)

  it('should not take damage when it collides with a wall', function()
    given_the_bot_is_initialized_with({
      name = '',
      team = 'team2',
      health = 5
    })
    when_it_collides_with_an_object_with_category('environment')
    its_health_should_be(5)
  end)

  it('should die when it loses all its health', function()
    given_the_bot_is_initialized_with({
      name = '',
      team = 'team2',
      health = 2
    })
    when_it_collides_with_an_object_with_category('projectile')
    it_should_be(ALIVE)
    when_it_collides_with_an_object_with_category('projectile')
    it_should_be(DEAD)
  end)

  it('should provide access to its current position', function()
    given_the_bot_is_initialized_with({
      name = '',
      team = 'team2',
      health = 2
    })
    body.getPosition:should_be_called_with(body):
    and_will_return(3, 4):
    when(function()
      its_position_should_be({ x = 3, y = 4 })
    end)
  end)
end)
