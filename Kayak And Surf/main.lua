--// Kayak And Surf - WalkToPos Advanced Loop
--// Author : Xapongg

--// Services
local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

--// Wind UI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--// Window
local Window = WindUI:CreateWindow({
    Title = "Kayak And Surf",
    Icon = "package",
    Author = "Xapongg",
    Folder = "KayakAndSurf",

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
    Title = "Kayak And Surf",
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

--// POSITIONS
local POS_A     = Vector3.new(0.779, 6.534, -7.202)
local POS_CHECK = Vector3.new(-1.156, 8456.942, -14653.345)
local POS_B     = Vector3.new(1.804, 8456.738, -14685.974)
local POS_C     = Vector3.new(-1.156, 8457.422, -14643.35)

local A_RADIUS     = 3
local CHECK_RADIUS = 4


--// Character Helpers
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    return getChar():WaitForChild("Humanoid")
end

local function getHRP()
    return getChar():WaitForChild("HumanoidRootPart")
end

--// Walk To
local function walkTo(pos)
    local hum = getHumanoid()
    hum:MoveTo(pos)
    hum.MoveToFinished:Wait()
end

--// Distance Check
local function isNear(pos, dist)
    return (getHRP().Position - pos).Magnitude <= dist
end

--// State
local walking = false
local AutoBoost = false


--// Tab
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "home"
})

--// Toggle
MainTab:Toggle({
    Title = "Auto Money",
    Desc = "Kaya nih Ajg",
    Default = false,
    Callback = function(state)
        walking = state

        if state then
            task.spawn(function()
                while walking do
                    -- SPAM KE POS A SAMPAI NYAMPE
                    while walking and not isNear(POS_A, A_RADIUS) do
                        getHumanoid():MoveTo(POS_A)
                        task.wait(0.25)
                    end
                    if not walking then break end

                    -- WAIT CHECK
                    repeat
                        task.wait(0.2)
                    until not walking or isNear(POS_CHECK, CHECK_RADIUS)
                    if not walking then break end

                    -- WALK B
                    walkTo(POS_B)
                    if not walking then break end

                    -- WALK C
                    walkTo(POS_C)
                    if not walking then break end

                    -- setelah C → otomatis balik spam ke A
                    task.wait(0.2)
                end
            end)
        end
    end
})

task.spawn(function()
    while task.wait(0.2) do
        if AutoBoost then
            local gui = LocalPlayer.PlayerGui:FindFirstChild("Hud")
            if gui then
                local boost = gui.MidRaceBoost.BoostIcon
                if boost and boost.AbsolutePosition then
                    local pos = boost.AbsolutePosition
                    local size = boost.AbsoluteSize

                    -- klik TENGAH icon bulat
                    local x = pos.X + size.X / 2
                    local y = pos.Y + size.Y / 2

                    VIM:SendMouseButtonEvent(x, y, 0, true, game, 1)
                    task.wait(0.05)
                    VIM:SendMouseButtonEvent(x, y, 0, false, game, 1)
                end
            end
        end
    end
end)

MainTab:Toggle({
    Title = "Auto Boost",
    Desc = "Klik boost otomatis (anti block)",
    Default = false,
    Callback = function(v)
        AutoBoost = v
    end
})

