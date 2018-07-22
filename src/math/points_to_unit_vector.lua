return function (x1, y1, x2, y2)
  local angle = math.atan2(x2 - x1, y2 - y1)
  return { x = math.sin(angle), y = math.cos(angle) }
end
