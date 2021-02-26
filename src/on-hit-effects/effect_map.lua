local Damage = require 'src/on-hit-effects/Damage'
local Burn = require 'src/on-hit-effects/Burn'
local Healing = require 'src/on-hit-effects/Healing'

return {
  damage = Damage,
  healing = Healing,
  burn = Burn
}
