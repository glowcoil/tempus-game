codesAndKeys = {
  ["01"] = guy,
  ["02"] = crate,
  ["03"] = temporalCrate,
  ["04"] = ladder,
  ["05"] = function(x, y)
    return movingPlatform(x, y, .5, 0)
  end,
  ["06"] = function(x, y)
    return movingPlatform(x, y, 0, .5)
  end,
  ["07"] = spikesUp,
  ["08"] = spikesDown,
  ["09"] = button,
  ["0A"] = forceField,
  ["0B"] = sidewaysForceField,
  ["0C"] = spawner,
  ["0D"] = function(x, y)
    return spikedMovingPlatform(x, y, 0, 6)
  end,
  ["0E"] = enemy,
  ["0F"] = door
}