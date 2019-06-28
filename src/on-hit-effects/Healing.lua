return function(damage, objects, category)
  return function(o)
    if o.category ~= category then
      o.set_health(o.get_health() + damage)
      print('Healing ' .. damage .. ' takes ' .. o.name ..
      ' up to ' .. o.get_health() .. ' health')
    end
  end
end
