local vector_to_unit_vector = require 'src/math/vector_to_unit_vector'

return function (bots, config)
  local ais = {}
  local stats = {}
  for _, Ai in ipairs(config) do
    local ai = Ai()
    table.insert(ais, ai)
    table.insert(stats, {
      health = ai.health,
      last_fired = 0,
      firing_rate = ai.firing_rate,
      effect = { effect_name = ai.effect_name, power = ai.effect_power }
    })
  end

  local time = 0

  local function shot_is_valid(i)
    local valid = time >= stats[i].last_fired + 1 / stats[i].firing_rate
    if valid then stats[i].last_fired = time end
    return valid
  end

  return {
    update = function(dt)
      local moves = {}
      time = time + dt
      for i, ai in ipairs(ais) do
        local move
        move = ai.update(bots, i, dt)
        move.force = vector_to_unit_vector(move.force)
        move.force.x = move.force.x * ai.speed
        move.force.y = move.force.y * ai.speed
        move.target = shot_is_valid(i) and move.target or nil
        move.effect = stats[i].effect
        moves[i] = move
      end
      return moves
    end,
    get_health = function(i) return stats[i].health end,
  }
end
