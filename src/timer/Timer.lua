return function()
  local callbacks = {}
  local current_time = 0

  return {
    tick = function(dt)
      current_time = current_time + dt
      local new_callbacks = {}
      for _, callback in pairs(callbacks) do
        if current_time >= callback.time then
          callback.callback()
        else
          table.insert(new_callbacks, callback)
        end
      end
      callbacks = new_callbacks
    end,
    start = function(time, callback)
      table.insert(callbacks, {time = time, callback = callback})
    end
  }
end
