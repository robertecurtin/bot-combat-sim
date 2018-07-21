local Edge = require('objects/Edge')
local mach = require('mach')

describe('Edge', function()
  local love = {
    physics = {
      newBody = mach.mock_function('newBody'),
      newEdgeShape = mach.mock_function('newEdgeShape'),
    }
  }

  it('should initialize love objects', function()
    local world = { 1 }
    local body = { 2 }
    local shape = { 3 }

    love.physics.newBody:
      should_be_called_with(world, 0, 0, 'static'):
      and_will_return(body):
      and_also(love.physics.newEdgeShape:should_be_called_with(4, 3, 2, 1)):
      and_will_return(shape):
      when(function()
        Edge(love, world, '', 4, 3, 2, 1)
      end)
  end)

  it('should initialize provided default values', function()
    local love = {
      physics = {
        newBody = function () end,
        newEdgeShape = function () end
      }
    }

    local edge = Edge(love, world, 'some name', 1, 2, 3, 4)
    assert.are.same('some name', edge.data.name)
    assert.are.same('environment', edge.data.category)
    assert.are.same(false, edge.data.is_marked_for_deletion())
  end)
end)
