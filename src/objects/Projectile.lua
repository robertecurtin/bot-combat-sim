local categories = require('src/objects/categories')
local bit = require('bit')

local function calculate_unit_vector(x1, y1, x2, y2)
  local angle = math.atan2(x2 - x1, y2 - y1)
  return { x = math.sin(angle), y = math.cos(angle) }
end

local prev_time = 0
local function calculate_initial_location_and_force(origin, target)
    local x_origin
    local y_origin
    local x_target
    local y_target
    local speed = 3000
    local distance = 70

    x_origin, y_origin = origin.body:getPosition()
    x_target, y_target = target.body:getPosition()
    unit_vector = calculate_unit_vector(
      x_origin, y_origin, x_target, y_target)

    return {
      force = {
        x = speed * unit_vector.x,
        y = speed * unit_vector.y
      },
      location = {
        x = x_origin + (70 * unit_vector.x),
        y = y_origin + (70 * unit_vector.y)
      }
    }
end

return function(love, world, name, origin, target)
  local marked_for_deletion = false
  local initial_physics = calculate_initial_location_and_force(origin, target)
  local projectile = {
    body = love.physics.newBody(
      world, initial_physics.location.x, initial_physics.location.y, 'dynamic'),
    shape = love.physics.newCircleShape(3),
    restitution = 0.4,
    mass = 5,
    mask = {'projectile', origin.data.category},
    data = {
      name = name,
      graphicsType = 'circle',
      category = 'projectile',
      collision_callback = function(o)
        if o.category ~= 'projectile' then
          marked_for_deletion = true
        end
      end,
      is_marked_for_deletion = function() return marked_for_deletion end
    }
  }

  projectile.body:applyForce(initial_physics.force.x, initial_physics.force.y)
  return projectile
end
