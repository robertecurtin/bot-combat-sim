local function calculate_initial_force(origin, target)
    local x_origin
    local y_origin
    local x_target
    local y_target
    local speed = 100

    x_origin, y_origin = origin.body:getPosition()
    x_target, y_target = target.body:getPosition()
    return speed * (x_origin - x_target), speed * (y_origin - y_target)
end

return function(love, world, name, x, y, origin, target)
  local radius = 10
  local mass = 5
  local restitution = 0.4
  local marked_for_deletion = false

  local projectile = {
    body = love.physics.newBody(world, x, y, 'dynamic'),
    shape = love.physics.newCircleShape(10),
    restitution = 0.4,
    mass = 5,
    data = {
      name = name,
      graphicsType = 'circle',
      objectType = 'projectile',
      collision_callback = function(o)
        if o.objectType == 'bot' then
          marked_for_deletion = true
        end
      end,
      is_marked_for_deletion = function() return marked_for_deletion end
    }
  }

  projectile.body:applyForce(calculate_initial_force(origin, target))
  return projectile
end
