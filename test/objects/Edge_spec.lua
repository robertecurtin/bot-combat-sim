local Edge = require('objects/Edge')
local mach = require('mach')

describe('Edge', function()
  local edge
  local world = {}
  local love = {
    physics = {
      newBody = mach.mock_function('newBody'),
      newEdgeShape = mach.mock_function('newEdgeShape'),
    }
  }

  local function given_the_edge_is_initialized_with(name, x1, y1, x2, y2)
    love.physics.newBody:
      should_be_called_with(world, 0, 0, 'static'):
      and_also(love.physics.newEdgeShape:should_be_called_with(x1, y1, x2, y2)):
      when(function()
        edge = Edge(love, world, name, x1, y1, x2, y2)
      end)
  end

  local function the_name_should_be(expected)
    assert.are.same(expected, edge.data.name)
  end

  local function the_category_should_be(expected)
    assert.are.same(expected, edge.data.category)
  end

  local function it_should_be_alive()
    assert.are.equal(false, edge.data.is_marked_for_deletion())
  end

  it('should initialize using the provided default values', function()
    given_the_edge_is_initialized_with('some name', 1, 2, 3, 4)
    the_name_should_be('some name')
    the_category_should_be('environment')
    it_should_be_alive()
  end)
end)
