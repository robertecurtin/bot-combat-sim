local vector_to_unit_vector = require 'src/math/vector_to_unit_vector'

return function (bots, config)
  for i, ai in ipairs(config) do
    ai.init()
  end

  return {
    update = function(dt)
      local moves = {}
      for i, ai in ipairs(config) do
        moves[i] = ai.update(bots, i, dt)
        moves[i].force = vector_to_unit_vector(moves[i].force)
      end
      return moves
    end
  }
end
