-- Services
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Variables
local player = Players.LocalPlayer
local godMode = false

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GodModeMenu"
screenGui.Parent = player.PlayerGui

-- Create Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.BorderSizePixel = 2
frame.Parent = screenGui

-- Create Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "God Mode Menu"
title.TextSize = 18
title.Parent = frame

-- Create Checkbox Button
local checkbox = Instance.new("TextButton")
checkbox.Size = UDim2.new(0, 20, 0, 20)
checkbox.Position = UDim2.new(0.1, 0, 0.5, 0)
checkbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
checkbox.Text = ""
checkbox.Parent = frame

-- Create Label
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.6, 0, 0, 20)
label.Position = UDim2.new(0.3, 0, 0.5, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Text = "God Mode"
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = frame

-- Function to toggle God Mode
local function toggleGodMode()
    godMode = not godMode
    
    if godMode then
        checkbox.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        -- Enable God Mode
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        -- Make player immortal
        humanoid.MaxHealth = math.huge
        humanoid.Health = humanoid.MaxHealth
        
        -- Connect damage prevention
        humanoid.HealthChanged:Connect(function(health)
            if godMode and health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    else
        checkbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        -- Disable God Mode
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    end
end

-- Connect checkbox button
checkbox.MouseButton1Click:Connect(toggleGodMode)

-- Make frame draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Notify user
StarterGui:SetCore("SendNotification", {
    Title = "God Mode Menu",
    Text = "Menu loaded successfully!",
    Duration = 3
})
