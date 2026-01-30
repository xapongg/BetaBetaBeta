--// Wind UI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Window = WindUI:CreateWindow({
    Title = "Container RNG",
    Icon = "package", -- lucide icon
    Author = "Xapongg",
    Folder = "ContainerRNG",
    
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
    Title = "Container RNG",
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Remote = ReplicatedStorage
    :WaitForChild("Paper")
    :WaitForChild("Remotes")
    :WaitForChild("__remotefunction")

--------------------------------------------------
--// TAB
--------------------------------------------------
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "home"
})

--------------------------------------------------
--// STATES
--------------------------------------------------
local AutoBuy = false
local AntiAFK = false

--------------------------------------------------
--// ANTI AFK (METODE BARU)
--------------------------------------------------
LocalPlayer.Idled:Connect(function()
    if AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)

--------------------------------------------------
--// BUY FUNCTION
--------------------------------------------------
local function Buy(slot)
    pcall(function()
        Remote:InvokeServer("Buy Event Merchant", slot)
    end)
end

--------------------------------------------------
--// TOGGLE AUTO BUY
--------------------------------------------------
MainTab:Toggle({
    Title = "Auto Buy Event Merchant",
    Desc = "Auto beli Slot 1 - 3",
    Default = false,
    Callback = function(state)
        AutoBuy = state
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
})

--------------------------------------------------
--// TOGGLE ANTI AFK
--------------------------------------------------
MainTab:Toggle({
    Title = "Anti AFK",
    Desc = "Anti kick AFK (VirtualUser method)",
    Default = true,
    Callback = function(state)
        AntiAFK = state
    end
})
