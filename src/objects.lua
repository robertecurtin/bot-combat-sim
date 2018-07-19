return {
  bot1 = {
    body = love.physics.newBody(world, 400, 200, 'dynamic'),
    shape = love.physics.newCircleShape(50),
    restitution = 0.4,
    mass = 5,
    name = "Bot1"
  },
  bot2 = {
    body = love.physics.newBody(world, 200, 200, 'dynamic'),
    shape = love.physics.newCircleShape(50),
    restitution = 0.4,
    mass = 5,
    name = "Bot2"
  },
  box = {
    body = love.physics.newBody(world, 400, 400, 'static'),
    shape = love.physics.newRectangleShape(200,50),
    name = "Box"
  },
  topEdge = {
    body = love.physics.newBody(world, 0, 0, 'static'),
    shape = love.physics.newEdgeShape(0, 0, width, 0),
    name = "Arena top edge"
  },
  bottomEdge = {
    body = love.physics.newBody(world, 0, 0, 'static'),
    shape = love.physics.newEdgeShape(0, 0, 0, height),
    name = "Arena bottom edge"
  },
  leftEdge = {
    body = love.physics.newBody(world, 0, 0, 'static'),
    shape = love.physics.newEdgeShape(width, height, width, 0),
    name = "Arena left edge"
  },
  rightEdge = {
    body = love.physics.newBody(world, 0, 0, 'static'),
    shape = love.physics.newEdgeShape(width, height, 0, height),
    name = "Arena right edge"
  }  
}
