local mach = require('mach')

local Projectile = require('objects/Projectile')

describe('Projectile', function()
  local projectile
  local love = {
    physics = {
      newBody = mach.mock_function('newBody'),
      newCircleShape = mach.mock_function('newCircleShape'),
    }
  }

  local bot1 = {
    body = { getPosition = function() return 1, 2 end },
    data = { category = 'team1' }
  }

  local bot2 = {
    body = { getPosition = function() return 3, 4 end },
    data = { category = 'team2' }
  }

  local body = { applyForce = function () end }

  local ALIVE = true
  local DEAD = not ALIVE

  local function given_the_projectile_is_initialized_with(name, origin_bot, position)
    love.physics.newBody:
      should_be_called_with(world, mach.any, mach.any, 'dynamic'):
      and_will_return(body):
      and_also(love.physics.newCircleShape:should_be_called_with_any_arguments()):
      when(function()
        projectile = Projectile(love, world, name, origin_bot, position)
      end)
  end

  local function when_it_collides_with_an_object_with_category(category)
    projectile.data.collision_callback({ category = category })
  end

  local function its_name_should_be(expected)
    assert.are.same(expected, projectile.data.name)
  end

  local function its_category_should_be(expected)
    assert.are.same(expected, projectile.data.category)
  end

  local function its_graphics_type_should_be(expected)
    assert.are.same(expected, projectile.data.graphicsType)
  end

  local function its_mask_should_be(expected)
    assert.are.same(expected, projectile.mask)
  end

  local function it_should_have_a_restitution_value()
    assert.are.are_not_equal(null, projectile.restitution)
  end

  local function it_should_have_a_mass()
    assert.are.are_not_equal(null, projectile.mass)
  end

  local function it_should_be(alive)
    assert.are.equal(alive, projectile.data.is_alive())
  end

  local a_position = { x = 3, y = 4 }

  it('should initialize love objects', function()
    local world = { 1 }
    local body = { applyForce = function() end }
    local shape = { 3 }

    love.physics.newBody:
      should_be_called_with(world, 1 + 30 * math.sin(math.pi / 4), 2 + 30 * math.cos(math.pi / 4), 'dynamic'):
      and_will_return(body):
      and_also(love.physics.newCircleShape:should_be_called_with_any_arguments()):
      and_will_return(shape):
      when(function()
        Projectile(love, world, '', bot1, { x = 3, y = 4 })
      end)
  end)

  it('should initialize using the provided values', function()
    given_the_projectile_is_initialized_with('some name', bot1, a_position)
    its_name_should_be('some name')
    its_graphics_type_should_be('circle')
    its_category_should_be('projectile')
    it_should_have_a_restitution_value()
    it_should_have_a_mass()
    it_should_be(ALIVE)
  end)

  it('should not collide with other projectiles or the originating bots team', function()
    given_the_projectile_is_initialized_with('some name', bot1, a_position)
    its_mask_should_be({ 'projectile', 'team1' })

    given_the_projectile_is_initialized_with('some name', bot2, a_position)
    its_mask_should_be({ 'projectile', 'team2' })
  end)

  it('should destroy itself when it collides with a bot from team 1', function()
    given_the_projectile_is_initialized_with('some name', bot2, a_position)
    when_it_collides_with_an_object_with_category('team1')
    it_should_be(DEAD)
  end)

  it('should destroy itself when it collides with a bot from team 2', function()
    given_the_projectile_is_initialized_with('some name', bot1, a_position)
    when_it_collides_with_an_object_with_category('team2')
    it_should_be(DEAD)
  end)

  it('should destroy itself when it collides with a wall', function()
    given_the_projectile_is_initialized_with('some name', bot1, a_position)
    when_it_collides_with_an_object_with_category('environment')
    it_should_be(DEAD)
  end)
end)
