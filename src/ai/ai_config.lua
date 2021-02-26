local random_bot = require 'src/ai/Random'
local healer_bot = require 'src/ai/Healer'
local pyro_bot = require 'src/ai/Pyro'

local team_1 = {
  random_bot,
  random_bot,
  random_bot,
  healer_bot,
  healer_bot,
  healer_bot,
  pyro_bot,
  pyro_bot,
  pyro_bot,
}

local team_2 = team_1

local bots = {}

local function insert_table(table_from, table_to)
  for _, v in ipairs(table_from) do
    table.insert(table_to, v)
  end
end

insert_table(team_1, bots)
insert_table(team_2, bots)

return {
  team_1 = team_1,
  team_2 = team_2,
  bots = bots
}
