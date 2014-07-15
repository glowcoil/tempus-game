function spikesUp(x, y)
  local s = entity(graphical("resources/materials/solids/spikes_up.png", x, y+12), { death = true })
  s.height = 4
  return s
end