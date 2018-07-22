local Bot = require 'src/objects/Bot'
local Edge = require 'src/objects/Edge'
local Projectile = require 'src/objects/Projectile'
local categories = require 'src/objects/categories'
local colors = require 'src/objects/colors'
local AiManager = require 'src/ai/AiManager'
local ai_config = require 'src/ai/config'

local world
local objects = {}

local bots
local ai_manager

local function on_collision(a, b, coll)
  x,y = coll:getNormal()
  local a_data = a:getUserData()
  local b_data = b:getUserData()

  if a_data.collision_callback then a_data.collision_callback(b_data) end
  if b_data.collision_callback then b_data.collision_callback(a_data) end
end

local function create_mask(object)
  local mask = 0
  for _, category in ipairs(object.mask) do
    mask = bit.bor(mask, categories[category])
  end
  object.fixture:setMask(mask)
end

local function add_object(object)
  object.fixture = love.physics.newFixture(object.body, object.shape)
  object.fixture:setCategory(categories[object.data.category])
  if object.restitution then object.fixture:setRestitution(object.restitution) end
  if object.mask then create_mask(object) end
  object.fixture:setUserData(object.data)
  table.insert(objects, object)
end

local function new_bot_body_at(x, y)
  return love.physics.newBody(world, x, y, 'dynamic')
end

local function new_bot_shape() return love.physics.newCircleShape(10) end

function love.load()
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(on_collision)

  local width = 800
  local height = 800

  bots = {
    Bot(new_bot_body_at(width/3,   height/3),   new_bot_shape(), 'Bot 1', 'Team 1', 30),
    Bot(new_bot_body_at(width/3,   2*height/3), new_bot_shape(), 'Bot 2', 'Team 1', 30),
    Bot(new_bot_body_at(2*width/3, height/3),   new_bot_shape(), 'Bot 3', 'Team 2', 30),
    Bot(new_bot_body_at(2*width/3, 2*height/3), new_bot_shape(), 'Bot 4', 'Team 2', 30)
  }

  ai_manager = AiManager(bots, ai_config)

  initialObjects = {
    Edge(love, world, 'Top edge', 0, 0, width, 0),
    Edge(love, world, 'Bottom edge', 0, 0, 0, height),
    Edge(love, world, 'Left edge', width, height, width, 0),
    Edge(love, world, 'Right edge', width, height, 0, height)
  }

  for _, bot in ipairs(bots) do table.insert(initialObjects, bot) end
  for _, object in pairs(initialObjects) do add_object(object) end

  love.window.setMode(width, height)
end

local function create_projectile(source, target)
  add_object(Projectile(love, world, 'projectile', source, target))
end

local function check_for_winner()
  local live_teams = {}
  for _, bot in ipairs(bots) do
    if bot.data.is_alive() then live_teams[bot.data.category] = true end
  end

  if not live_teams['Team 1'] and not live_teams['Team 2'] then return 'No one' end
  if not live_teams['Team 1'] then return 'Team 2' end
  if not live_teams['Team 2'] then return 'Team 1' end
  return false
end

function love.update(dt)
  world:update(dt)
  local force = 300
  local winner = check_for_winner()
  if not winner then
    local bot_moves = ai_manager.update(bots, i, dt)
    for i, move in ipairs(bot_moves) do
      if bots[i].data.is_alive() then
        bots[i].body:applyForce(force * move.force.x, force * move.force.y)
        if move.fire then create_projectile(bots[i], move.target) end
      end
    end
  end
  love.graphics.setColor(1, 1, 0, 1)
end

function love.keypressed(key)
  if key == 'x' then love.event.quit() end
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

  local winner = check_for_winner()
  if winner then
    love.graphics.setColor(colors[winner])
    love.graphics.print(winner .. ' wins!', 360, 200, 0, 1, 1)
  end
end
