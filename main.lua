local world
local objects

local width = 800
local height = 800

function start_contact(a, b, coll)
    x,y = coll:getNormal()
    print("\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..y)
end

function end_contact(a, b, coll)

end

function love.load()
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(start_contact, end_contact)
  objects = {
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
  for _, object in pairs(objects) do
    object.fixture = love.physics.newFixture(object.body, object.shape)
    if object.restitution then object.fixture:setRestitution(object.restitution) end
    object.fixture:setUserData(object.name)
  end

  love.window.setMode(width, height)
end

function love.update(dt)
  world:update(dt)

  local force = 1000
  if love.keyboard.isDown("right") then
      objects.bot1.body:applyForce(force, 0)
  elseif love.keyboard.isDown("left") then
      objects.bot1.body:applyForce(-force, 0)
  end
  if love.keyboard.isDown("up") then
      objects.bot1.body:applyForce(0, -force)
  elseif love.keyboard.isDown("down") then
      objects.bot1.body:applyForce(0, force)
  end
end

function love.keypressed(key)
  if key == 'x' then love.event.quit() end
end

function love.draw()
  love.graphics.circle("line", objects.bot1.body:getX(),objects.bot1.body:getY(), objects.bot1.shape:getRadius(), 20)
  love.graphics.circle("line", objects.bot2.body:getX(),objects.bot2.body:getY(), objects.bot2.shape:getRadius(), 20)
  love.graphics.polygon("line", objects.box.body:getWorldPoints(objects.box.shape:getPoints()))
end
