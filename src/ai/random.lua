return function (bots, my_index, dt)
  local my_team_name = bots[my_index].data.category
  local enemies = {}
  for i, bot in ipairs(bots) do
    if bot.data.category ~= my_team_name then
      table.insert(enemies, bot)
    end
  end

  local target = enemies[math.random(1, #enemies)]

  return {
    force = {
      x = math.random(-1, 1),
      y = math.random(-1, 1)
    },
    target = target.data.get_position(),
    fire = true
  }
end
