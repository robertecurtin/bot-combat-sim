return function(love, world, name, x, y, team, health)
  local alive = true
  local bot
  bot = {
    body = love.physics.newBody(world, x, y, 'dynamic'),
    shape = love.physics.newCircleShape(10),
    restitution = 0.1,
    mass = 5,
    data = {
      name = name,
      health = health,
      graphicsType = 'circle',
      category = team,
      collision_callback = function(o)
        if o.category == 'projectile' then
          bot.data.health = bot.data.health - 1
          if bot.data.health <= 0 then alive = false end
        end
      end,
      is_alive = function() return alive end,
      get_position = function()
        local x
        local y
        x, y = bot.body:getPosition()
        return { x = x, y = y }
      end
    }
  }
  return bot
end
