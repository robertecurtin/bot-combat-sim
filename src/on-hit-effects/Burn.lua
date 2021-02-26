return function(args)
  local damage = args.power.damage
  local hits = args.power.hits
  local category = args.category
  local timer = args.timer

  return function(o)
    local function hit_teammate()
      return o.category == category
    end

    local function callback()
      o.set_health(o.get_health() - damage)
      hits = hits - 1
      print('Burning ' .. damage .. ' takes ' .. o.name ..
        ' down to ' .. o.get_health() .. ' health, ' .. hits .. ' hits remain')
      if hits > 0 then
        timer.start(1, callback)
      end
    end

    if not hit_teammate() then
      timer.start(1, callback)
    end
  end
end
