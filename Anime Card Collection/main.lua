--// Services
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
    Desc = "Auto collect card slot 1 - 9",
    Value = false,
    Callback = function(v)
        AutoCollectCards = v
        if not v then return end

        task.spawn(function()
            while AutoCollectCards do
                local plot = workspace.Plots:FindFirstChild(PLOT_ID)
                if not plot then task.wait(0.5) continue end

                local left = plot:FindFirstChild("Map")
                    and plot.Map:FindFirstChild("Display")
                    and plot.Map.Display:FindFirstChild("Left")

                if not left then task.wait(0.5) continue end

                for i = 1, 9 do
                    if not AutoCollectCards then break end

                    local card = left:FindFirstChild(tostring(i))
                    if card then
                        pcall(function()
                            CardRemote:FireServer("Collect", card)
                        end)
                        task.wait(0.1)
                    end
                end

                task.wait(0.3)
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
