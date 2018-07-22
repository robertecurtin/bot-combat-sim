local vector_to_unit_vector = require 'src/math/vector_to_unit_vector'

return function (bots, config)
  stats = {}
  for i, ai in ipairs(config) do
    stats[i] = ai.init()
  end

  return {
    update = function(dt)
      local moves = {}
      for i, ai in ipairs(config) do
        local move
        move = ai.update(bots, i, dt)
        move.force = vector_to_unit_vector(move.force)
        move.force.x = move.force.x * stats[i].speed
        move.force.y = move.force.y * stats[i].speed

        moves[i] = move
      end
      return moves
    end
  }
end
