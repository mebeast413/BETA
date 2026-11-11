local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local existing = CoreGui:FindFirstChild("REDMAGIC_GUI")
if existing then existing:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "REDMAGIC_GUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999999
gui.Parent = CoreGui

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 320, 0, 260)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
main.BorderSizePixel = 0
main.ClipsDescendants = false
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(120, 0, 0)
stroke.Thickness = 1.5
stroke.Parent = main

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local headerTitle = Instance.new("TextLabel")
headerTitle.AnchorPoint = Vector2.new(0.5, 0.5)
headerTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
headerTitle.Size = UDim2.new(1, -20, 1, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Font = Enum.Font.GothamBlack
headerTitle.Text = "REDMAGIC"
headerTitle.TextColor3 = Color3.fromRGB(220, 20, 20)
headerTitle.TextSize = 18
headerTitle.Parent = header

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0, 10, 0, 50)
content.Size = UDim2.new(1, -20, 1, -60)
content.BackgroundTransparency = 1
content.Parent = main

local function makeSlot(yPos, labelText)
    local slot = Instance.new("Frame")
    slot.Name = "Slot"
    slot.Position = UDim2.new(0, 0, 0, yPos)
    slot.Size = UDim2.new(1, 0, 0, 85)
    slot.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
    slot.BorderSizePixel = 0
    slot.Parent = content

    local slotCorner = Instance.new("UICorner")
    slotCorner.CornerRadius = UDim.new(0, 10)
    slotCorner.Parent = slot

    local slotStroke = Instance.new("UIStroke")
    slotStroke.Color = Color3.fromRGB(90, 0, 0)
    slotStroke.Thickness = 1
    slotStroke.Parent = slot

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Position = UDim2.new(0, 12, 0, 8)
    label.Size = UDim2.new(1, -24, 0, 30)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 60, 60)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = slot

    local btn = Instance.new("TextButton")
    btn.Name = "Inject"
    btn.AnchorPoint = Vector2.new(0.5, 0)
    btn.Position = UDim2.new(0.5, 0, 0, 42)
    btn.Size = UDim2.new(1, -24, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Text = "ИНЖЕКТ"
    btn.TextColor3 = Color3.fromRGB(255, 200, 200)
    btn.TextSize = 15
    btn.AutoButtonColor = false
    btn.Parent = slot

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(140, 0, 0)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(100, 0, 0) }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(60, 0, 0) }):Play()
    end)

    return slot, btn
end

local slot1, inject1 = makeSlot(0, "1 Резерв")
local slot2, inject2 = makeSlot(95, "2 Резерв")

local function closeGui()
    local fade = TweenService:Create(main, TweenInfo.new(0.25), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0)
    })
    for _, obj in ipairs(main:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            TweenService:Create(obj, TweenInfo.new(0.2), { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
        elseif obj:IsA("UIStroke") then
            TweenService:Create(obj, TweenInfo.new(0.2), { Transparency = 1 }):Play()
        elseif obj:IsA("Frame") then
            TweenService:Create(obj, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
        end
    end
    fade:Play()
    fade.Completed:Wait()
    gui:Destroy()
end

local function doInject(url)
    local ok, src = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or type(src) ~= "string" or #src == 0 then return end
    closeGui()
    task.wait(0.3)
    local fn = loadstring(src)
    if fn then pcall(fn) end
end

inject1.MouseButton1Click:Connect(function()
    doInject("https://raw.githubusercontent.com/mebeast413/RED/refs/heads/main/RED.lua")
end)

inject2.MouseButton1Click:Connect(function()
    doInject("https://raw.githubusercontent.com/mebeast413/REDMAGIC/refs/heads/main/REDMAGIC.lua")
end)

local dragging = false
local dragStart, startPos

local function beginDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = main.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)