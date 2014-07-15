local quads = {}
for i = 1, 25 do
  quads[i] = love.graphics.newQuad(
    (i - 1) % 25 * 16,
    math.floor((i - 1) / 25) * 16,
    16, 16,
    400, 16
  )
end

return "tiles/OutsideyCaius.png", quads