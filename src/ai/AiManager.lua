local vector_to_unit_vector = require 'src/math/vector_to_unit_vector'

return function (bots, config)
  local ais = {}
  local stats = {}
  for i, Ai in ipairs(config) do
    local ai = Ai()
    table.insert(ais, ai)
    table.insert(stats, { health = ai.health })
  end

  return {
    update = function(dt)
      local moves = {}
      for i, ai in ipairs(ais) do
        local move
        move = ai.update(bots, i, dt)
        move.force = vector_to_unit_vector(move.force)
        move.force.x = move.force.x * ai.speed
        move.force.y = move.force.y * ai.speed

        moves[i] = move
      end
      return moves
    end,
    get_health = function(i) return stats[i].health end
  }
end
