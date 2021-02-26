return function(args)
  local damage = args.power
  local category = args.category

  return function(o)
    local function hit_teammate()
      return o.category == category
    end

    if not hit_teammate() then
      o.set_health(o.get_health() - damage)
      print('Dealing ' .. damage .. ' takes ' .. o.name ..
        ' down to ' .. o.get_health() .. ' health')
    end
  end
end
