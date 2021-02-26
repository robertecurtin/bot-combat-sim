local Polygon = require('objects/Polygon')
local mach = require('mach')

describe('Polygon', function()
  local polygon
  local world = {}
  local love = {
    physics = {
      newBody = mach.mock_function('newBody'),
      newPolygonShape = mach.mock_function('newPolygonShape'),
    }
  }

  local function given_the_Polygon_is_initialized_with(name, x1, y1, x2, y2)
    love.physics.newBody:
      should_be_called_with(world, 0, 0, 'static'):
      and_also(love.physics.newPolygonShape:should_be_called_with(x1, y1, x2, y2)):
      when(function()
        polygon = Polygon(love, world, name, { x1, y1, x2, y2 })
      end)
  end

  local function the_name_should_be(expected)
    assert.are.same(expected, polygon.data.name)
  end

  local function the_category_should_be(expected)
    assert.are.same(expected, polygon.data.category)
  end

  local function it_should_be_alive()
    assert.are.equal(true, polygon.data.is_alive())
  end

  it('should initialize using the provided default values', function()
    given_the_Polygon_is_initialized_with('some name', 1, 2, 3, 4)
    the_name_should_be('some name')
    the_category_should_be('Environment')
    it_should_be_alive()
  end)
end)
