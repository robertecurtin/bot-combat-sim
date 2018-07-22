return function (bots, config)
  for _, ai in ipairs(config) do ai.init() end
  return {
    update = function(dt)
      local moves = {}
      for i, ai in ipairs(config) do
        moves[i] = ai.update(bots, i, dt)
      end
      return moves
    end
  }
end
