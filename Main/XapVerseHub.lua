local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GameList = {
    [8836568224] = "https://raw.githubusercontent.com/xapongg/XapVerseHub/main/Kayak%20And%20Surf/main.lua",
}

local PlaceList = {
    [79657240466394] = "https://raw.githubusercontent.com/xapongg/XapVerseHub/main/ContainerRNG/main.lua",
    [82013336390273] = "https://raw.githubusercontent.com/xapongg/XapVerseHub/main/PickaxeSim/main.lua",
    [76285745979410] = "https://raw.githubusercontent.com/xapongg/XapVerseHub/refs/heads/main/Anime%20Card%20Collection/main.lua",
}

local scriptURL =
    GameList[game.GameId]
    or PlaceList[game.PlaceId]

if scriptURL then
    loadstring(game:HttpGet(scriptURL))()
else
    warn("[XapVerseHub] Game/Place belum terdaftar")
    LocalPlayer:Kick(
        "XapVerseHub ❌\n" ..
        "Game ini belum ada di list.\n" ..
        "Cek Discord untuk update terbaru."
    )
end
