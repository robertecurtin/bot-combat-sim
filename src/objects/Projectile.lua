local categories = require 'src/objects/categories'
local points_to_unit_vector = require 'src/math/points_to_unit_vector'

local function calculate_initial_location_and_force(origin, target)
  local x_origin
  local y_origin
  local x_target
  local y_target
  local speed = 3000
  local distance = 30

  x_origin, y_origin = origin.body:getPosition()
  x_target, y_target = target.x, target.y
  unit_vector = points_to_unit_vector(
    x_origin, y_origin, x_target, y_target)

  return {
    force = {
      x = speed * unit_vector.x,
      y = speed * unit_vector.y
    },
    location = {
      x = x_origin + (distance * unit_vector.x),
      y = y_origin + (distance * unit_vector.y)
    }
  }
end

return function(love, world, name, origin, target, trigger_effect)
  local alive = true
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
          alive = false
          trigger_effect(o)
        end
      end,
      is_alive = function() return alive end
    }
  }

  projectile.body:applyForce(initial_physics.force.x, initial_physics.force.y)
  return projectile
end
