local Projectile = require('objects/Projectile')
local mach = require('mach')

describe('Projectile', function()
  local love = {
    physics = {
      newBody = function () end,
      newCircleShape = function () end
    }
  }

  it('should initialize love objects', function()
    local mock_love = {
      physics = {
        newBody = mach.mock_function('newBody'),
        newCircleShape = mach.mock_function('newCircleShape'),
      }
    }
    local world = { 1 }
    local body = { 2 }
    local shape = { 3 }

    mock_love.physics.newBody:
      should_be_called_with(world, 3, 4, 'dynamic'):
      and_will_return(body):
      and_also(mock_love.physics.newCircleShape:should_be_called_with_any_arguments()):
      and_will_return(shape):
      when(function()
        Projectile(mock_love, world, '', 3, 4)
      end)
  end)

  it('should initialize provided default values', function()
    local projectile = Projectile(love, world, 'some name', 3, 4)
    assert.are.same('some name', projectile.data.name)
    assert.are.same('circle', projectile.data.graphicsType)
    assert.are.same('projectile', projectile.data.objectType)
    assert.are.are_not_equal(null, projectile.restitution)
    assert.are.are_not_equal(null, projectile.mass)
    assert.are.same(false, projectile.data.is_marked_for_deletion())
  end)

  it('should destroy itself when it collides with a bot', function()
      local projectile = Projectile(love, world, 'some name', 3, 4)
      projectile.data.collision_callback({ objectType = 'bot' })
      assert.are.same(true, projectile.data.is_marked_for_deletion())
  end)
end)
