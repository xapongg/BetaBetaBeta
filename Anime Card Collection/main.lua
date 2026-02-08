--// Services
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Wind UI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--// Window
local Window = WindUI:CreateWindow({
    Title = "Anime Card Collection",
    Icon = "package",
    Author = "Xapongg",
    Folder = "AnimeCardCollection",

    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,

    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
})

--// Open Button
Window:EditOpenButton({
    Title = "AnimeCard",
    Icon = "package",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"),
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

--// Tab
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local MiscTab = Window:Tab({Title = "Misc", Icon = "settings"})

--// =========================
--// AUTO COLLECT CARDS
--// =========================
local AutoCollectCards = false
local PLOT_ID = "3"

local CardRemote = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("Card")

MainTab:Toggle({
    Title = "Auto Collect Cards",
    Desc = "Auto collect card slot 1 - 9 (Left & Right)",
    Value = false,
    Callback = function(v)
        AutoCollectCards = v
        if not v then return end

        task.spawn(function()
            while AutoCollectCards do
                local plot = workspace.Plots:FindFirstChild(PLOT_ID)
                if not plot then task.wait(0.5) continue end

                local display = plot:FindFirstChild("Map")
                    and plot.Map:FindFirstChild("Display")

                if not display then task.wait(0.5) continue end

                -- 🔥 collect kiri & kanan
                for _, sideName in ipairs({"Left", "Right"}) do
                    local side = display:FindFirstChild(sideName)
                    if side then
                        for i = 1, 9 do
                            if not AutoCollectCards then break end

                            local card = side:FindFirstChild(tostring(i))
                            if card then
                                task.spawn(function()
                                    pcall(function()
                                        CardRemote:FireServer("Collect", card)
                                    end)
                                end)
                            end
                        end
                    end
                end

                task.wait(0.35)
            end
        end)
    end
})


--// =========================
--// AUTO COLLECT TRAVEL COIN
--// =========================
local AutoCollectTravel = false

local PotionRemote = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("Potion")

MainTab:Toggle({
    Title = "Auto Collect Travel Coin",
    Desc = "Auto collect TravelToken 1 & 2",
    Value = false,
    Callback = function(v)
        AutoCollectTravel = v
        if not v then return end

        task.spawn(function()
            while AutoCollectTravel do
                pcall(function()
                    PotionRemote:FireServer("Collect", "TravelToken1")
                    PotionRemote:FireServer("Collect", "TravelToken2")
                end)

                task.wait(0.5)
            end
        end)
    end
})

--// =========================
--// AUTO COLLECT POTION
--// =========================
local AutoCollectPotion = false

MainTab:Toggle({
    Title = "Auto Collect Potion",
    Desc = "Auto collect HatchTime & Luck",
    Value = false,
    Callback = function(v)
        AutoCollectPotion = v
        if not v then return end

        task.spawn(function()
            while AutoCollectPotion do
                pcall(function()
                    PotionRemote:FireServer("Collect", "HatchTime")
                    PotionRemote:FireServer("Collect", "Luck")
                end)

                task.wait(0.6)
            end
        end)
    end
})

MainTab:Space()

local SelectedPacks = {}

local PackList = {
    "Pirate",
    "Ninja",
    "Soul",
    "Slayer",
    "Sorcerer",
    "Dragon",
    "Fire",
    "Hero",
    "Hunter",
    "Solo",
    "Titan",
    "Chainsaw",
    "Flight",
    "Ego",
    "Clover",
    "Ghoul",
    "Geass",
    "Bizarre"
}

MainTab:Dropdown({
    Title = "Select Packs",
    Multi = true,
    Values = PackList,
    Callback = function(v)
        SelectedPacks = v
    end
})

local AutoBuyPack = false
local CardRemote = game:GetService("ReplicatedStorage").Remotes.Card

MainTab:Toggle({
    Title = "Auto Buy Pack",
    Desc = "Auto buy pack by name (skip pack id)",
    Value = false,
    Callback = function(v)
        AutoBuyPack = v
        if not v then return end

        task.spawn(function()
            while AutoBuyPack do
                for _, folder in ipairs(workspace.Client.Packs:GetChildren()) do
                    for _, pack in ipairs(folder:GetChildren()) do
                        if table.find(SelectedPacks, pack.Name) then
                            pcall(function()
                                CardRemote:FireServer(
                                    "BuyPack",
                                    folder.Name -- pack id random
                                )
                            end)
                            task.wait(0.25)
                        end
                    end
                end
                task.wait(0.6)
            end
        end)
    end
})

local AutoPlace = false
local CardRemote = game:GetService("ReplicatedStorage").Remotes.Card

MainTab:Toggle({
    Title = "Auto Equip & Place Card",
    Desc = "Awas Ngeframe NGENTOT",
    Value = false,
    Callback = function(v)
        AutoPlace = v
        if not v then return end

        task.spawn(function()
            while AutoPlace do
                for _, cardName in ipairs(SelectedPacks) do
                    if not AutoPlace then break end

                    -- Equip dulu
                    pcall(function()
                        CardRemote:FireServer("Equip", cardName)
                    end)

                    task.wait(0.15)

                    -- Place ke Floor
                    pcall(function()
                        CardRemote:FireServer("Place", cardName)
                    end)

                    task.wait(0.25)
                end
                task.wait(0.6)
            end
        end)
    end
})

--------------------------------------------------
--// TOGGLE ANTI AFK
--------------------------------------------------
local AntiAFK = false
local IdleConn

local AntiAFKToggle = MiscTab:Toggle({
    Title = "Anti AFK",
    Desc = "Anti Kick Idle 20 menit",
    Value = false,
    Callback = function(v)
        AntiAFK = v

        if v then
            if not IdleConn then
                IdleConn = LocalPlayer.Idled:Connect(function()
                    -- cancel roblox idle
                    VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
                    task.wait(0.2)
                    VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
                end)
            end
        else
            if IdleConn then
                IdleConn:Disconnect()
                IdleConn = nil
            end
        end
    end
})

--// INPUT LOOP (INI KUNCI UTAMA)
task.spawn(function()
    while task.wait(60) do -- < 900 detik AMAN
        if not AntiAFK then continue end

        -- fake key (InputBegan TERPICU)
        VIM:SendKeyEvent(true, Enum.KeyCode.Unknown, false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, Enum.KeyCode.Unknown, false, game)
    end
end)
