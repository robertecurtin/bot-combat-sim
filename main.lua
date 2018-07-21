local Bot = require 'src/objects/Bot'
local Edge = require 'src/objects/Edge'
local Projectile = require 'src/objects/Projectile'
local categories = require 'src/objects/categories'
local colors = require 'src/objects/colors'
local ai = require 'src/ai/config'

local world
local objects = {}

local width = 800
local height = 800

local bots

function on_collision(a, b, coll)
  x,y = coll:getNormal()
  local a_data = a:getUserData()
  local b_data = b:getUserData()

  if a_data.collision_callback then a_data.collision_callback(b_data) end
  if b_data.collision_callback then b_data.collision_callback(a_data) end
end

function create_mask(object)
  local mask = 0
  for _, category in ipairs(object.mask) do
    mask = bit.bor(mask, categories[category])
  end
  object.fixture:setMask(mask)
end

function add_object(object)
  object.fixture = love.physics.newFixture(object.body, object.shape)
  object.fixture:setCategory(categories[object.data.category])
  if object.restitution then object.fixture:setRestitution(object.restitution) end
  if object.mask then create_mask(object) end
  object.fixture:setUserData(object.data)
  table.insert(objects, object)
end

function love.load()
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(on_collision)
  bots = {
    Bot(love, world, 'Bot 1', 400, 200, 'team1', 50),
    Bot(love, world, 'Bot 2', 200, 200, 'team2', 50)
  }

  initialObjects = {
    bots[1],
    bots[2],
    Edge(love, world, 'Top edge', 0, 0, width, 0),
    Edge(love, world, 'Bottom edge', 0, 0, 0, height),
    Edge(love, world, 'Left edge', width, height, width, 0),
    Edge(love, world, 'Right edge', width, height, 0, height)
  }

  for _, object in pairs(initialObjects) do
    add_object(object)
  end

  love.window.setMode(width, height)
end

local projectile_timer = 0

local function CreateProjectile(source, target)
  add_object(Projectile(love, world, 'projectile', source, target))
end

function love.update(dt)
  world:update(dt)
  local force = 300
  if(bots[1].data.is_alive() and bots[2].data.is_alive()) then
    bot1_x, bot1_y = bots[1].body:getPosition()
    bot2_x, bot2_y = bots[2].body:getPosition()

    local bot1_move = ai.bot1(
      { x = bot1_x, y = bot1_y },
      { x = bot2_x, y = bot2_y },
      dt)

    local bot2_move = ai.bot2(
      { x = bot2_x, y = bot2_y },
      { x = bot1_x, y = bot1_y },
      dt)

    bots[1].body:applyForce(force * bot1_move.force.x, force * bot1_move.force.y)
    bots[2].body:applyForce(force * bot2_move.force.x, force * bot2_move.force.y)

    if bot1_move.fire then CreateProjectile(bots[1], bot1_move.target) end
    if bot2_move.fire then CreateProjectile(bots[2], bot2_move.target) end
  end
end


function love.keypressed(key)
  if key == 'x' then love.event.quit() end
  if key == 'r' then CreateProjectile() end
end

local function remove_dead_objects()
  for i=#objects,1,-1 do
    if(objects[i].data.is_alive() == false) then
      objects[i].body:destroy()
      table.remove(objects,i)
    end
  end
end

local function draw_circle(object)
  love.graphics.setColor(colors[object.data.category])
  love.graphics.circle("line", object.body:getX(),object.body:getY(), object.shape:getRadius())
end

function love.draw()
  remove_dead_objects()
  for _, object in pairs(objects) do
    if(object.data.graphicsType == 'circle') then
      draw_circle(object)
    end
  end
end
