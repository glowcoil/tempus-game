local quads = {}
for i = 1, 35 do
  quads[i] = love.graphics.newQuad(
    (i - 1) % 18 * 16,
    math.floor((i - 1) / 18) * 16,
    16, 16,
    288, 32
  )
end

return "tiles/Tileset.png", quads