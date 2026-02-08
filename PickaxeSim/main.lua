--// Wind UI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Window = WindUI:CreateWindow({
    Title = "Pickaxe Simulator",
    Icon = "package", -- lucide icon
    Author = "Xapongg",
    Folder = "PickaxeSimulator",

    -- ↓ This all is Optional. You can remove it.
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

    -- ↓ Optional. You can remove it.
    --[[ You can set 'rbxassetid://' or video to Background.
        'rbxassetid://':
            Background = "rbxassetid://", -- rbxassetid
        Video:
            Background = "video:YOUR-RAW-LINK-TO-VIDEO.webm", -- video 
    --]]

    -- ↓ Optional. You can remove it.
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
})

Window:EditOpenButton({
    Title = "Pickaxe Sim",
    Icon = "package",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

--------------------------------------------------
--// SERVICES
--------------------------------------------------
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage
    :WaitForChild("Paper")
    :WaitForChild("Remotes")
    :WaitForChild("__remotefunction")

--------------------------------------------------
--// TAB
--------------------------------------------------
local MainTab = Window:Tab({Title = "Main", Icon = "home" })
local EventTab = Window:Tab({Title = "Event", Icon = "Package" })
local MiscTab = Window:Tab({Title = "Misc", Icon = "settings"})

--------------------------------------------------
--// STATES
--------------------------------------------------
local AutoBuy = false
local AutoSell = false
local AutoRebirth = false
local SelectedRebirth = 1
local AutoPickaxe = false
local AutoMineResetUpgrade = false
local AutoUnlockNextWorld = false
local AutoMiner = false
local AutoBuyEvent = false
local AutoClaimTime = false
local AutoRoll = false
local AutoDiceChest = false
local AutoDailyChest = false
local AutoJungleChest = false
local AutoEventUpgrade = false
local SelectedUpgrades = {}
local AutoCraft = false
local SelectedDice = {}
local AutoLuckyBlock = false
local AntiAFK = false
local IdleConn


--------------------------------------------------
--// FUNCTIONS
--------------------------------------------------
local function Buy(slot)
    pcall(function()
        Remote:InvokeServer("Buy Merchant", slot)
    end)
end

local function Sell()
    pcall(function()
        Remote:InvokeServer("Sell All Ores")
    end)
end

local function Rebirth(amount)
    pcall(function()
        Remote:InvokeServer("Rebirth", amount)
    end)
end

local function ClaimTimeReward()
    pcall(function()
        Remote:InvokeServer("Claim Time Reward")
    end)
end

local function BuyPickaxe()
    pcall(function()
        Remote:InvokeServer("Buy Pickaxe")
    end)
end

local function BuyMiner()
    pcall(function()
        Remote:InvokeServer("Buy Miner")
    end)
end

local function Roll()
    pcall(function()
        Remote:InvokeServer("Roll")
    end)
end

local function BuyEvent(slot)
    pcall(function()
        Remote:InvokeServer("Buy Event Merchant", slot)
    end)
end

local function BuyMineResetUpgrade()
    pcall(function()
        Remote:InvokeServer("Buy MineReset Upgrade")
    end)
end

local function BuyUnlockNextWorld()
    pcall(function()
        Remote:InvokeServer("Unlock Next World")
    end)
end

local function ClaimDailyChest()
    pcall(function()
        Remote:InvokeServer("Claim Chest", "DailyChest")
    end)
end

local function ClaimJungleChest()
    pcall(function()
        Remote:InvokeServer("Claim Chest", "JungleChest")
    end)
end

local function ClaimDiceChest()
    pcall(function()
        Remote:InvokeServer("Claim Chest", "DiceChest")
    end)
end

local function EventUpgrade(name)
    pcall(function()
        Remote:InvokeServer("Event Upgrade", name)
    end)
end

local function CraftDice(diceName)
    pcall(function()
        Remote:InvokeServer("Craft Dice", diceName)
    end)
end

local function ClaimAllLuckyBlocks()
    local objects = workspace:FindFirstChild("Objects")
    if not objects then return end

    for _, v in pairs(objects:GetChildren()) do
        local id

        -- attribute
        if v:GetAttribute("Id") then
            id = v:GetAttribute("Id")

        -- StringValue
        elseif v:FindFirstChild("Id") and v.Id:IsA("StringValue") then
            id = v.Id.Value

        elseif v:FindFirstChild("UUID") and v.UUID:IsA("StringValue") then
            id = v.UUID.Value

        -- fallback name
        elseif typeof(v.Name) == "string" and #v.Name > 10 then
            id = v.Name
        end

        if id then
            pcall(function()
                Remote:InvokeServer("Claim LuckyBlock", id)
            end)
            task.wait(0.1)
        end
    end
end

--------------------------------------------------
--// TOGGLE AUTO SELL
--------------------------------------------------
local AutoSellToggle = MainTab:Toggle({
    Title = "Auto Sell",
    Desc = "Auto Sell All Ores",
    Default = false,
    Callback = function(state)
        AutoSell = state
        if state then
            task.spawn(function()
                while AutoSell do
                    Sell()
                    task.wait(5)
                end
            end)
        end
    end
})

MainTab:Space()
--------------------------------------------------
--// DROPDOWN AND TOGGLE AUTO REBIRTH
--------------------------------------------------
local RebirthMap = {
    ["1"] = 1,
    ["5"] = 2,
    ["20"] = 3,
    ["50"] = 4,
    ["100"] = 5,
    ["250"] = 6,
    ["500"] = 7,
    ["1K"] = 8,
    ["2.5K"] = 9,
    ["5K"] = 10,
    ["10K"] = 11,
    ["25K"] = 12,
    ["50K"] = 13,
    ["100K"] = 14,
    ["250K"] = 15,
    ["500K"] = 16,
    ["1M"] = 17,
    ["2.5M"] = 18,
    ["10M"] = 19,
    ["25M"] = 20,
    ["100M"] = 21,
    ["1B"] = 22,
    ["50B"] = 23,
    ["500B"] = 24,
    ["5T"] = 25,
    ["100T"] = 26,
    ["1Qd"] = 27,
    ["50Qd"] = 28,
    ["500Qd"] = 29,
    ["2.5Qn"] = 30,
    ["50Qn"] = 31,
    ["500Qn"] = 32,
    ["5Sx"] = 33,
    ["100Sx"] = 34,
    ["1Sp"] = 35,
    ["50Sp"] = 36,
    ["500Sp"] = 37,
    ["25Oc"] = 38,
    ["500Oc"] = 39,
    ["25No"] = 40,
    ["500No"] = 41,
    ["25De"] = 42,
    ["500De"] = 43,
    ["25UDe"] = 44,
    ["500UDe"] = 45,
    ["25DDe"] = 46,
    ["500DDe"] = 47,
}

local RebirthLabels = {}
for label in pairs(RebirthMap) do
    table.insert(RebirthLabels, label)
end

table.sort(RebirthLabels, function(a, b)
    return RebirthMap[a] < RebirthMap[b]
end)

MainTab:Dropdown({
    Title = "Rebirth Amount",
    Desc = "Tampilan K / M (value asli hidden)",
    Values = RebirthLabels,
    Value = "",
    Multi = false,
    AllowNone = false,
    Callback = function(label)
        SelectedRebirth = RebirthMap[label]
    end
})

MainTab:Toggle({
    Title = "Auto Rebirth",
    Desc = "Auto rebirth sesuai amount",
    Default = false,
    Callback = function(state)
        AutoRebirth = state
        if state then
            task.spawn(function()
                while AutoRebirth do
                    Rebirth(SelectedRebirth)
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Space()
--------------------------------------------------
--// TOGGLE AUTO CLAIM TIME REWARD
--------------------------------------------------
local AutoClaimToggle = MainTab:Toggle({
    Title = "Auto Claim Time Reward",
    Desc = "Auto claim reward waktu tersedia",
    Default = false,
    Callback = function(state)
        AutoClaimTime = state
        if state then
            task.spawn(function()
                while AutoClaimTime do
                    ClaimTimeReward()
                    task.wait(30)
                end
            end)
        end
    end
})

MainTab:Space()
--------------------------------------------------
--// TOGGLE AUTO CLAIM LUCKY BLOCK
--------------------------------------------------
local AutoClaimLuckyBlock = MainTab:Toggle({
    Title = "Auto Claim Lucky Block",
    Desc = "Auto claim semua LuckyBlock di map",
    Default = false,
    Callback = function(state)
        AutoLuckyBlock = state
        if state then
            task.spawn(function()
                while AutoLuckyBlock do
                    ClaimAllLuckyBlocks()
                    task.wait(0.3) -- aman & stabil
                end
            end)
        end
    end
})

MainTab:Space()
--------------------------------------------------
--// TOGGLE AUTO BUY
--------------------------------------------------
local AutoBuyToggle = MainTab:Toggle({
    Title = "Auto Buy Merchant",
    Desc = "Auto beli Slot 1 - 3",
    Default = false,
    Callback = function(state)
        AutoBuy = state
        if state then
            task.spawn(function()
                while AutoBuy do
                    Buy("Slot1")
                    task.wait(0.3)
                    Buy("Slot2")
                    task.wait(0.3)
                    Buy("Slot3")
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Space()
--------------------------------------------------
--// TOGGLE AUTO BUY PICKAXE
--------------------------------------------------
local AutoBuyPickaxeToggle = MainTab:Toggle({
    Title = "Auto Buy Pickaxe",
    Desc = "Auto Upgrade Pickaxe",
    Default = false,
    Callback = function(state)
        AutoBuyPickaxe = state
        if state then
            task.spawn(function()
                while AutoBuyPickaxe do
                    BuyPickaxe()
                    task.wait(5)
                end
            end)
        end
    end
})

MainTab:Space()
--------------------------------------------------
--// TOGGLE AUTO BUY MINER
--------------------------------------------------
local AutoBuyMinerToggle = MainTab:Toggle({
    Title = "Auto Buy Miner",
    Desc = "Auto Upgrade Miner",
    Default = false,
    Callback = function(state)
        AutoBuyMiner = state
        if state then
            task.spawn(function()
                while AutoBuyMiner do
                    BuyMiner()
                    task.wait(5)
                end
            end)
        end
    end
})

MainTab:Space()
--------------------------------------------------
--// TOGGLE AUTO DAILY CHEST
--------------------------------------------------
local AutoDailyChestToggle = MainTab:Toggle({
    Title = "Auto Claim Daily Chest",
    Desc = "Auto Claim Daiy Chest",
    Default = false,
    Callback = function(state)
        AutoDailyChest = state
        if state then
            task.spawn(function()
                while AutoDailyChest do
                    ClaimDailyChest()
                    task.wait(10)
                end
            end)
        end
    end
})

MainTab:Space()
--------------------------------------------------
--// TOGGLE AUTO JUNGLE CHEST
--------------------------------------------------
local AutoJungleChestToggle = MainTab:Toggle({
    Title = "Auto Claim Jungle Chest",
    Desc = "Auto Claim Jungle Chest",
    Default = false,
    Callback = function(state)
        AutoJungleChest = state
        if state then
            task.spawn(function()
                while AutoJungleChest do
                    ClaimJungleChest()
                    task.wait(10)
                end
            end)
        end
    end
})

MainTab:Space()
--------------------------------------------------
--// TOGGLE AUTO BUY MineResetUpgrade
--------------------------------------------------
local AutoBuyMineResetUpgradeToggle = MainTab:Toggle({
    Title = "Auto Buy MineResetUpgrade",
    Desc = "Auto Upgrade MineResetUpgrade",
    Default = false,
    Callback = function(state)
        AutoBuyMineResetUpgrade = state
        if state then
            task.spawn(function()
                while AutoBuyMineResetUpgrade do
                    BuyMineResetUpgrade()
                    task.wait(5)
                end
            end)
        end
    end
})

MainTab:Space()
--------------------------------------------------
--// TOGGLE AUTO BUY UnlockNextWorld
--------------------------------------------------
local AutoBuyUnlockNextWorldToggle = MainTab:Toggle({
    Title = "Auto Buy UnlockNextWorld",
    Desc = "Auto Upgrade UnlockNextWorld",
    Default = false,
    Callback = function(state)
        AutoBuyUnlockNextWorld = state
        if state then
            task.spawn(function()
                while AutoBuyUnlockNextWorld do
                    BuyUnlockNextWorld()
                    task.wait(5)
                end
            end)
        end
    end
})

MainTab:Space()










--------------------------------------------------
--// TOGGLE AUTO ROLL
--------------------------------------------------
local AutoRollToggle = EventTab:Toggle({
    Title = "Auto Roll",
    Desc = "Auto roll terus",
    Default = false,
    Callback = function(state)
        AutoRoll = state
        if state then
            task.spawn(function()
                while AutoRoll do
                    Roll()
                    task.wait(0.25)
                end
            end)
        end
    end
})

EventTab:Space()
--------------------------------------------------
--// TOGGLE AUTO BUY EVENT
--------------------------------------------------
local AutoBuyEventToggle = EventTab:Toggle({
    Title = "Auto Buy Event Merchant",
    Desc = "Auto beli Slot 1 - 3",
    Default = false,
    Callback = function(state)
        AutoBuyEvent = state
        if state then
            task.spawn(function()
                while AutoBuyEvent do
                    BuyEvent("Slot1")
                    task.wait(0.3)
                    BuyEvent("Slot2")
                    task.wait(0.3)
                    BuyEvent("Slot3")
                    task.wait(1)
                end
            end)
        end
    end
})

EventTab:Space()
--------------------------------------------------
--// TOGGLE AUTO CLAIM DICE CHEST
--------------------------------------------------
local AutoDiceChestToggle = EventTab:Toggle({
    Title = "Auto Claim Dice Chest",
    Desc = "Auto claim Dice Chest",
    Default = false,
    Callback = function(state)
        AutoDiceChest = state
        if state then
            task.spawn(function()
                while AutoDiceChest do
                    ClaimDiceChest()
                    task.wait(10)
                end
            end)
        end
    end
})

EventTab:Space()
--------------------------------------------------
--// DROPDOWN AND TOGGLE AUTO UPGRADE
--------------------------------------------------
EventTab:Dropdown({
    Title = "Event Upgrades",
    Desc = "Pilih upgrade event",
    Values = {
        "Auto Rolls",
        "More Clovers",
        "Lucky Rolls",
        "Speedy Rolls",
        "Lucky Secret Rolls",
        "Faster Event Merchant",
        "Better Event Stocks",
    },
    Value = {}, -- default selected
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        SelectedUpgrades = option
    end
})


EventTab:Toggle({
    Title = "Auto Event Upgrade",
    Desc = "Auto upgrade sesuai pilihan",
    Default = false,
    Callback = function(state)
        AutoEventUpgrade = state
        if state then
            task.spawn(function()
                while AutoEventUpgrade do
                    for _, upgrade in ipairs(SelectedUpgrades) do
                        EventUpgrade(upgrade)
                        task.wait(0.15) -- delay aman
                    end
                    task.wait(0.3)
                end
            end)
        end
    end
})

EventTab:Space()
--------------------------------------------------
--// DROPDOWN AND TOGGLE AUTO CRAFT
--------------------------------------------------
EventTab:Dropdown({
    Title = "Craft Dice Selection",
    Desc = "Pilih dice yang mau di-craft",
    Values = {
        "Speed Dice",
        "Matrix Dice",
        "Golden Dice",
        "Rainbow Dice",
        "Magic Dice",
        "Ice Dice",
        "Ruby Dice",
        "Fire Dice",
        "Galaxy Dice",
    },
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        SelectedDice = option
    end
})

EventTab:Toggle({
    Title = "Auto Craft Dice",
    Desc = "Auto craft dice terpilih",
    Default = false,
    Callback = function(state)
        AutoCraft = state
        if state then
            task.spawn(function()
                while AutoCraft do
                    for _, dice in ipairs(SelectedDice) do
                        if not AutoCraft then break end
                        CraftDice(dice)
                        task.wait(0.15)
                    end
                    task.wait(0.3)
                end
            end)
        end
    end
})

EventTab:Space()

--------------------------------------------------
--// TOGGLE ANTI AFK
--------------------------------------------------
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

task.defer(function()
    AutoBuyToggle:Set(true)
    AutoSellToggle:Set(false)
    AutoBuyPickaxeToggle:Set(false)
    AutoBuyMinerToggle:Set(false)
    AutoDailyChestToggle:Set(true)
    AutoJungleChestToggle:Set(true)
    AntiAFKToggle:Set(true)
    AutoClaimLuckyBlock:Set(true)
    AutoBuyMineResetUpgradeToggle:Set(true)
    AutoBuyUnlockNextWorldToggle:Set(true)

    --//Eventttt
    AutoBuyEventToggle:Set(true)
    AutoClaimToggle:Set(true)
    AutoRollToggle:Set(false)
    AutoDiceChestToggle:Set(true)
    -- sengaja TIDAK:
    -- AutoEventUpgradeToggle
    -- AutoCraftToggle
end)
