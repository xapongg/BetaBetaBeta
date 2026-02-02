local games = {
    [79657240466394] = "https://raw.githubusercontent.com/xapongg/XapVerseHub/refs/heads/main/ContainerRNG/main.lua",
    [82013336390273] = "https://raw.githubusercontent.com/xapongg/XapVerseHub/refs/heads/main/PickaxeSim/main.lua",
    [136404558442020] = "https://raw.githubusercontent.com/xapongg/XapVerseHub/refs/heads/main/Kayak%20And%20Surf/main.lua",
    [] = "",
}

local currentID = game.PlaceId
local scriptURL = games[currentID]

if scriptURL then
    loadstring(game:HttpGet(scriptURL))()
else
    game.Players.LocalPlayer:Kick("Yo! Game ini belum ada di list.\nCek Discord untuk melihat game yang tersedia, homie.")
end
