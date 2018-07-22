return function(vector)
  local m = math.sqrt(vector.x ^ 2 + vector.y ^ 2)
  return m == 0 and { x = 0, y = 0 } or { x = vector.x / m, y = vector.y / m }
end
