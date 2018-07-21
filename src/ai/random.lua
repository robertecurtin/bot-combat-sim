return function (my_position, their_position, dt)
  return {
    force = {
      x = math.random(-1, 1),
      y = math.random(-1, 1)
    },
    target = {
      x = their_position.x,
      y = their_position.y
    },
    fire = true
  }
end
