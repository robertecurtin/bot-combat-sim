local Bot = require 'src/objects/Bot'
local Edge = require 'src/objects/Edge'
local Projectile = require 'src/objects/Projectile'
local categories = require 'src/objects/categories'
local colors = require 'src/objects/colors'

local world
local objects = {}

local width = 800
local height = 800

local bot1
local bot2

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
  bot1 = Bot(love, world, 'Bot 1', 400, 200, 'team1')
  bot2 = Bot(love, world, 'Bot 2', 200, 200, 'team2')

  initialObjects = {
    bot1,
    bot2,
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

  projectile_timer = projectile_timer + dt
  if projectile_timer > 1 then
    projectile_timer = 0
    target_bot1_x, target_bot1_y = bot2.body:getPosition()
    target_bot1 = { x = target_bot1_x, y = target_bot1_y }
    target_bot2_x, target_bot2_y = bot1.body:getPosition()
    target_bot2 = { x = target_bot2_x, y = target_bot2_y }
    add_object(Projectile(love, world, 'projectile', bot1, target_bot1))
    add_object(Projectile(love, world, 'projectile', bot2, target_bot2))
  end
end

local function CreateProjectile()
  add_object(Projectile(love, world, 'projectile', bot1, bot2))
end

function love.keypressed(key)
  if key == 'x' then love.event.quit() end
  if key == 'r' then CreateProjectile() end
end

local function remove_objects_marked_for_deletion()
  for i=#objects,1,-1 do
    if(objects[i].data.is_marked_for_deletion() == true) then
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
  remove_objects_marked_for_deletion()
  for _, object in pairs(objects) do
    if(object.data.graphicsType == 'circle') then
      draw_circle(object)
    end
  end
end
