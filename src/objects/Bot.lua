return function(love, world, name, x, y, team, health)
  local marked_for_deletion = false
  return {
    body = love.physics.newBody(world, x, y, 'dynamic'),
    shape = love.physics.newCircleShape(10),
    restitution = 0.1,
    mass = 5,
    data = {
      name = name,
      health = health,
      graphicsType = 'circle',
      category = team,
      is_marked_for_deletion = function() return marked_for_deletion end
    }
  }
end
