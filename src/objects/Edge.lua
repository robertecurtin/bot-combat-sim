return function(love, world, name, x1, y1, x2, y2)
  return {
    body = love.physics.newBody(world, 0, 0, 'static'),
    shape = love.physics.newEdgeShape(x1, y1, x2, y2),
    data = {
      name = name,
      category = 'Environment',
      is_alive = function() return true end
    }
  }
end
