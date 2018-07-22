return function(damage)
  return function(o)
    if o.category == 'Team 1' or o.category == 'Team 2' then
      o.set_health(o.get_health() - damage)
      print('Dealing ' .. damage .. ' takes ' .. o.name ..
      ' down to ' .. o.get_health() .. ' health')
    end
  end
end
