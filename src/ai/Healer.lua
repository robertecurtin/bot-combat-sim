return function()
  return {
    speed = math.random(1,5),
    health = 15 + 3*math.random(1,5),
    firing_rate = math.random(1,5),
    effect_name = 'healing',
    effect_power = math.random(1,5),
    update = function (bots, my_index, dt)
      local my_team_name = bots[my_index].data.category
      local teammates = {}
      for i, bot in ipairs(bots) do
        if i ~= my_index and bot.data.category == my_team_name and bot.data.is_alive() then
          table.insert(teammates, bot)
        end
      end

      local target

      if teammates[1] then
        target = teammates[math.random(1, #teammates)].data.get_position()
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
