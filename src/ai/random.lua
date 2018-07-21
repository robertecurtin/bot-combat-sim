return function (bots, my_index, dt)
  local their_position

  for i, bot in ipairs(bots) do
    if not (i == my_index) then
      their_position = bot.data.get_position()
    end
  end
  return {
    force = {
      x = math.random(-1, 1),
      y = math.random(-1, 1)
    },
    target = their_position,
    fire = true
  }
end
