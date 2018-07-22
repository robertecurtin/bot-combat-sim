return function()
  return {
    speed = math.random(1,10),
    health = 10*math.random(1,3),
    update = function (bots, my_index, dt)
      local my_team_name = bots[my_index].data.category
      local enemies = {}
      for i, bot in ipairs(bots) do
        if bot.data.category ~= my_team_name and bot.data.is_alive() then
          table.insert(enemies, bot)
        end
      end

      local target

      if enemies[1] then
        target = enemies[math.random(1, #enemies)].data.get_position()
      else
        target = { x = 400, y = 400 }
      end

      return {
        force = {
          x = math.random(-1, 1),
          y = math.random(-1, 1)
        },
        target = target
      }
    end
  }
end
