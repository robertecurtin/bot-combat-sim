local bit = require('bit')
local mach = require('mach')

local Projectile = require('objects/Projectile')

describe('Projectile', function()
    local love = {
    physics = {
      newBody = function () return { applyForce = function() end } end,
      newCircleShape = function () end
      }
    }

  local love_mock = {
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

  it('should initialize love objects', function()
    local world = { 1 }
    local body = { applyForce = function() end }
    local shape = { 3 }

    love_mock.physics.newBody:
    should_be_called_with(world, 1 + 70 * math.sin(math.pi / 4), 2 + 70 * math.cos(math.pi / 4), 'dynamic'):
    and_will_return(body):
    and_also(love_mock.physics.newCircleShape:should_be_called_with_any_arguments()):
    and_will_return(shape):
    when(function()
      Projectile(love_mock, world, '', bot1, bot2)
    end)
  end)

  it('should initialize using the provided values', function()
    local projectile = Projectile(love, world, 'some name', bot1, bot2)
    assert.are.same('some name', projectile.data.name)
    assert.are.same('circle', projectile.data.graphicsType)
    assert.are.same('projectile', projectile.data.category)
    assert.are.are_not_equal(null, projectile.restitution)
    assert.are.are_not_equal(null, projectile.mass)
    assert.are.same(false, projectile.data.is_marked_for_deletion())
  end)

  it('should not collide with other projectiles or the originating bots team', function()
    local projectile = Projectile(love, world, 'some name', bot1, bot2)
    assert.are.same({ 'projectile', 'team1' }, projectile.mask)

    local another_projectile = Projectile(love, world, 'some name', bot2, bot1)
    assert.are.same({ 'projectile', 'team2' }, another_projectile.mask)
  end)

  it('should have an initial velocity from the first object towards the second', function()
    local origin = {
    body = { getPosition = mach.mock_function('getPositionBot1')},
    data = { category = 'team1' }
  }
  local target = {
    body = { getPosition = mach.mock_function('getPositionBot2')},
    data = { category = 'team2' }
  }
  local body_mock = { applyForce = mach.mock_function('applyForce')}

  origin.body.getPosition:should_be_called_with(origin.body):
    and_will_return(1, 2):
    and_then(target.body.getPosition:should_be_called_with(target.body)):
    and_will_return(3, 4):
    and_then(love_mock.physics.newBody:should_be_called_with_any_arguments()):
    and_will_return(body_mock):
    and_then(love_mock.physics.newCircleShape:should_be_called_with_any_arguments()):
    and_then(body_mock.applyForce:should_be_called_with(body_mock, 3000 * math.sin(math.pi / 4), 3000 * math.cos(math.pi / 4))):
    when(function()
      Projectile(love_mock, world, '', origin, target)
    end)
  end)

  it('should destroy itself when it collides with a bot from team 1', function()
    local projectile = Projectile(love, world, 'some name', bot1, bot2)
    projectile.data.collision_callback({ category = 'team1' })
    assert.are.same(true, projectile.data.is_marked_for_deletion())
  end)

  it('should destroy itself when it collides with a bot from team 2', function()
    local projectile = Projectile(love, world, 'some name', bot1, bot2)
    projectile.data.collision_callback({ category = 'team2' })
    assert.are.same(true, projectile.data.is_marked_for_deletion())
  end)

  it('should destroy itself when it collides with a wall', function()
    local projectile = Projectile(love, world, 'some name', bot1, bot2)
    projectile.data.collision_callback({ category = 'environment' })
    assert.are.same(true, projectile.data.is_marked_for_deletion())
  end)
end)
