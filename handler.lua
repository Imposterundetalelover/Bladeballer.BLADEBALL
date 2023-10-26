local id = game.PlaceId

local supported = { 13772394625 }

if table.find(supported, id) then
  loadstring(game:HttpGet('https://raw.githubusercontent.com/xenoszef/Fazed.BLADEBALL/main/main.lua'))()
else
  game.Players.LocalPlayer:Kick("💨 Fazed | Invalid Game")
end
