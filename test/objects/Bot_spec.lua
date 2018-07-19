local Bot = require('objects/Bot')
local mach = require('mach')

describe('Bot', function()
  local love = {
    physics = {
      newBody = mach.mock_function('newBody'),
      newCircleShape = mach.mock_function('newCircleShape'),
    }
  }

  it('should initialize love objects', function()
    local world = { 1 }
    local body = { 2 }
    local shape = { 3 }

    love.physics.newBody:
      should_be_called_with(world, 3, 4, 'dynamic'):
      and_will_return(body):
      and_also(love.physics.newCircleShape:should_be_called_with_any_arguments()):
      and_will_return(shape):
      when(function()
        local bot = Bot(love, world, '', 3, 4)
      end)
  end)

  it('should initialize provided default values', function()
    local love = {
      physics = {
        newBody = function () end,
        newCircleShape = function () end
      }
    }

    local bot = Bot(love, world, 'some name', 3, 4)
    assert.are.same('some name', bot.data.name)
    assert.are.are_not_equal(null, bot.restitution)
    assert.are.are_not_equal(null, bot.mass)
  end)
end)
