maps = {}

maps[1] = function() return love.filesystem.load("maps/Level1.lua")() end
maps[2] = function() return love.filesystem.load("maps/Level2.lua")() end
maps[3] = function() return love.filesystem.load("maps/Level3.lua")() end
maps[4] = function() return love.filesystem.load("maps/Level4.lua")() end
maps[5] = function() return love.filesystem.load("maps/Level5.lua")() end