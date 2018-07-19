local Bot = require 'src/objects/Bot'
local Edge = require 'src/objects/Edge'

local world
local objects

local width = 800
local height = 800

function start_contact(a, b, coll)
    x,y = coll:getNormal()
    print("\n"..a:getUserData().name.." colliding with "..b:getUserData().name.." with a vector normal of: "..x..", "..y)
end

function end_contact(a, b, coll)

end

function love.load()
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(start_contact, end_contact)
  objects = {
    bot1 = Bot(love, world, 'Bot 1', 400, 200),
    bot2 = Bot(love, world, 'Bot 2', 200, 200),
    topEdge = Edge(love, world, 'Top edge', 0, 0, width, 0),
    bottomEdge = Edge(love, world, 'Bottom edge', 0, 0, 0, height),
    leftEdge = Edge(love, world, 'Top edge', width, height, width, 0),
    rightEdge = Edge(love, world, 'Top edge', width, height, 0, height)
  }
  for _, object in pairs(objects) do
    object.fixture = love.physics.newFixture(object.body, object.shape)
    if object.restitution then object.fixture:setRestitution(object.restitution) end
    object.fixture:setUserData(object.data)
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
end
