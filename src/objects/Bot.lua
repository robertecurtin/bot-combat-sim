return function(love, world, name, x, y, team)
  local radius = 50
  local mass = 5
  local restitution = 0.4

  local bot = {
    body = love.physics.newBody(world, x, y, 'dynamic'),
    shape = love.physics.newCircleShape(10),
    restitution = 0.4,
    mass = 5,
    data = {
      name = name,
      graphicsType = 'circle',
      category = team,
      is_marked_for_deletion = function() return false end
    }
  }
    return bot
end
