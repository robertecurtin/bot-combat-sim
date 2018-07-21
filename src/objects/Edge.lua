return function(love, world, name, x1, y1, x2, y2)
  return {
    body = love.physics.newBody(world, 0, 0, 'static'),
    shape = love.physics.newEdgeShape(x1, y1, x2, y2),
    data = {
      name = name,
      category = 'environment',
      is_marked_for_deletion = function() return false end
    }
  }
end
