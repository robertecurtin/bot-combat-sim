local radius = 50
local mass = 5
local restitution = 0.4

return function(love, world, name, x, y)
  return {
    body = love.physics.newBody(world, x, y, 'dynamic'),
    shape = love.physics.newCircleShape(10),
    restitution = 0.4,
    mass = 5,
    data = {
      name = name,
      graphicsType = 'circle'
    }
  }
end
