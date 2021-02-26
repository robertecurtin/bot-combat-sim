return function(args)
  local category = args.category
  local power = args.power

  return function(o)
    local function hit_teammate()
      return o.category == category
    end

    if hit_teammate() then
      o.set_health(o.get_health() + power)
      print('Healing ' .. power .. ' takes ' .. o.name ..
        ' up to ' .. o.get_health() .. ' health')
    end
  end
end
