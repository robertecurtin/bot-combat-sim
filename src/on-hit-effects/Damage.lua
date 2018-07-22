return function(damage, objects, category)
  return function(o)
    if o.category ~= category then
      o.set_health(o.get_health() - damage)
      print('Dealing ' .. damage .. ' takes ' .. o.name ..
      ' down to ' .. o.get_health() .. ' health')
    end
  end
end
