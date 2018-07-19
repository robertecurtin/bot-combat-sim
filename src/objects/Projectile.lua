return function(love, world, name, x, y)
  local radius = 50
  local mass = 5
  local restitution = 0.4
  local marked_for_deletion = false
  
  return {
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
end
