return function(love, world, name, points)
  return {
    body = love.physics.newBody(world, 0, 0, 'static'),
    shape = love.physics.newPolygonShape(unpack(points)),
    data = {
      name = name,
      category = 'Environment',
      is_alive = function() return true end,
      graphicsType = 'polygon'
    }
  }
end
