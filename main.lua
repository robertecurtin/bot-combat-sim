local Bot = require 'src/objects/Bot'
local Edge = require 'src/objects/Edge'
local Projectile = require 'src/objects/Projectile'

local world
local objects = {}

local width = 800
local height = 800

function start_contact(a, b, coll)
    x,y = coll:getNormal()
    print("\n"..a:getUserData().name.." colliding with "..b:getUserData().name.." with a vector normal of: "..x..", "..y)
end

function add_object(object)
  object.fixture = love.physics.newFixture(object.body, object.shape)
  if object.restitution then object.fixture:setRestitution(object.restitution) end
  object.fixture:setUserData(object.data)
  table.insert(objects, object)
end

function love.load()
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(start_contact)
  initialObjects = {
    bot1 = Bot(love, world, 'Bot 1', 400, 200),
    bot2 = Bot(love, world, 'Bot 2', 200, 200),
    topEdge = Edge(love, world, 'Top edge', 0, 0, width, 0),
    bottomEdge = Edge(love, world, 'Bottom edge', 0, 0, 0, height),
    leftEdge = Edge(love, world, 'Left edge', width, height, width, 0),
    rightEdge = Edge(love, world, 'Right edge', width, height, 0, height)
  }

  for _, object in pairs(initialObjects) do
    add_object(object)
  end

  love.window.setMode(width, height)
end

function love.update(dt)
  world:update(dt)

  local force = 300
  if love.keyboard.isDown("right") then
      objects[1].body:applyForce(force, 0)
  elseif love.keyboard.isDown("left") then
      objects[1].body:applyForce(-force, 0)
  end
  if love.keyboard.isDown("up") then
      objects[1].body:applyForce(0, -force)
  elseif love.keyboard.isDown("down") then
      objects[1].body:applyForce(0, force)
  end
end

local function CreateProjectile()
  add_object(Projectile(love, world, 'projectile', 200, 200))
end

function love.keypressed(key)
  if key == 'x' then love.event.quit() end
  if key == 'r' then CreateProjectile() end
end

function love.draw()
  for _, object in pairs(objects) do
    if(object.data.graphicsType == 'circle') then
      love.graphics.circle("line", object.body:getX(),object.body:getY(), object.shape:getRadius())
    end
  end
end
