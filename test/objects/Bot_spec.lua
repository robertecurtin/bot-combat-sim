local Bot = require('objects/Bot')
local mach = require('mach')

describe('Bot', function()
  local world = {}

  local bot
  local love = {
    physics = {
      newBody = mach.mock_function('newBody'),
      newCircleShape = mach.mock_function('newCircleShape'),
    }
  }

  local ALIVE = true
  local DEAD = false

  local function given_the_bot_is_initialized_with(c)
    love.physics.newBody:
      should_be_called_with(world, c.x, c.y, 'dynamic'):
      and_also(love.physics.newCircleShape:should_be_called_with_any_arguments()):
      when(function()
        bot = Bot(love, world, c.name, c.x, c.y, c.team, c.health)
      end)
  end

  local function when_it_collides_with_an_object_with_category(category)
    bot.data.collision_callback({ category = category })
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
      x = 3,
      y = 4,
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
      x = 3,
      y = 4,
      team = 'team2',
      health = 5
    })
    its_name_should_be('another name')
    its_category_should_be('team2')
    its_health_should_be(5)
  end)

  it('should take damage when it collides with a projectile', function()
    given_the_bot_is_initialized_with({
      name = '',
      x = 3,
      y = 4,
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
      x = 3,
      y = 4,
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
      x = 3,
      y = 4,
      team = 'team2',
      health = 5
    })
    when_it_collides_with_an_object_with_category('environment')
    its_health_should_be(5)
  end)

  it('should die when it loses all its health', function()
    given_the_bot_is_initialized_with({
      name = '',
      x = 3,
      y = 4,
      team = 'team2',
      health = 2
    })
    when_it_collides_with_an_object_with_category('projectile')
    it_should_be(ALIVE)
    when_it_collides_with_an_object_with_category('projectile')
    it_should_be(DEAD)
  end)

end)
