return function(damage)
  return function(o)
    if o.set_health then
      o.set_health(o.get_health() - damage)
    end
  end
end
