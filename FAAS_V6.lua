-- FAAS Admin Panel - V6
-- Logic by SAE5964

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleCircle = Instance.new("TextButton")
local PageHome = Instance.new("Frame")
local PageSettings = Instance.new("Frame")
local PagePresets = Instance.new("Frame")
local PageGhamid = Instance.new("Frame")

local currentCommands = {"explode", "res", "ice", "jc", "loopwarp", "blur", "loopkill"}
local spamRunning = false
local protectRunning = false
local currentPrefix = ";"
local stealthConnection

local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
ScreenGui.Name = "FAAS_V6_Stealth"
ScreenGui.ResetOnSpawn = false

ToggleCircle.Name = "ToggleCircle"
ToggleCircle.Parent = ScreenGui
ToggleCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleCircle.Position = UDim2.new(0, 30, 0.5, -30)
ToggleCircle.Size = UDim2.new(0, 55, 0, 55)
ToggleCircle.Font = Enum.Font.GothamBold
ToggleCircle.Text = "FAAS"
ToggleCircle.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleCircle.Visible = false
ToggleCircle.Draggable = true
Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)
local CStroke = Instance.new("UIStroke", ToggleCircle)
CStroke.Color = Color3.fromRGB(255, 255, 255)
CStroke.Thickness = 1.5

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -165)
MainFrame.Size = UDim2.new(0, 260, 0, 330)
MainFrame.Draggable = false
Instance.new("UICorner", MainFrame)
local MStroke = Instance.new("UIStroke", MainFrame)
MStroke.Color = Color3.fromRGB(255, 255, 255)
MStroke.Thickness = 1

local function makeDraggable(dragHandle, targetFrame)
    local dragging, dragInput, dragStart, startPosition = false, nil, nil, nil

    local function updatePosition(input)
        local delta = input.Position - dragStart
        targetFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end

    dragHandle.Active = true
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = true
        dragInput = nil
        dragStart = input.Position
        startPosition = targetFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                dragInput = nil
            end
        end)
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput and dragStart and startPosition then updatePosition(input) end
    end)
end

local DragHandle = Instance.new("Frame")
DragHandle.Name = "DragHandle"
DragHandle.Parent = MainFrame
DragHandle.BackgroundTransparency = 1
DragHandle.BorderSizePixel = 0
DragHandle.Position = UDim2.new(0, 5, 0, 0)
DragHandle.Size = UDim2.new(1, -60, 0, 30)
DragHandle.Active = true
makeDraggable(DragHandle, MainFrame)

PageHome.Name = "PageHome"
PageHome.Parent = MainFrame
PageHome.BackgroundTransparency = 1
PageHome.Size = UDim2.new(1, 0, 1, 0)

local HomeTitle = Instance.new("TextLabel", PageHome)
HomeTitle.BackgroundTransparency = 1
HomeTitle.Position = UDim2.new(0, 10, 0, 5)
HomeTitle.Size = UDim2.new(0.6, 0, 0, 20)
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.Text = "FAAS V6"
HomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", PageHome)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -25, 0, 5)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local SettingsBtn = Instance.new("TextButton", PageHome)
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.Position = UDim2.new(1, -50, 0, 5)
SettingsBtn.Size = UDim2.new(0, 20, 0, 20)
SettingsBtn.Text = "⚙️"
SettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local UsernameInput = Instance.new("TextBox", PageHome)
UsernameInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
UsernameInput.Position = UDim2.new(0.05, 0, 0.1, 0)
UsernameInput.Size = UDim2.new(0.9, 0, 0, 35)
UsernameInput.Text = ""
UsernameInput.PlaceholderText = "أدخل اسم المستخدم هنا"
UsernameInput.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
UsernameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", UsernameInput)

local ResultBox = Instance.new("TextBox", PageHome)
ResultBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ResultBox.Position = UDim2.new(0.05, 0, 0.24, 0)
ResultBox.Size = UDim2.new(0.9, 0, 0, 60)
ResultBox.Text = "—"
ResultBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ResultBox.TextSize = 10
ResultBox.TextWrapped = true
ResultBox.TextEditable = false
Instance.new("UICorner", ResultBox)

local CopyButton = Instance.new("TextButton", PageHome)
CopyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Position = UDim2.new(0.05, 0, 0.45, 0)
CopyButton.Size = UDim2.new(0.9, 0, 0, 35)
CopyButton.Text = "نسخ 📋"
CopyButton.TextColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", CopyButton)

local SpamButton = Instance.new("TextButton", PageHome)
SpamButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpamButton.Position = UDim2.new(0.05, 0, 0.60, 0)
SpamButton.Size = UDim2.new(0.9, 0, 0, 35)
SpamButton.Text = "تشغيل سبام 📢"
SpamButton.TextColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", SpamButton)

local ProtectButton = Instance.new("TextButton", PageHome)
ProtectButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProtectButton.Position = UDim2.new(0.05, 0, 0.75, 0)
ProtectButton.Size = UDim2.new(0.9, 0, 0, 35)
ProtectButton.Text = "تشغيل الحماية 🛡️"
ProtectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", ProtectButton)

PageSettings.Name = "PageSettings"
PageSettings.Parent = MainFrame
PageSettings.BackgroundTransparency = 1
PageSettings.Size = UDim2.new(1, 0, 1, 0)
PageSettings.Visible = false

local SettingsBack = Instance.new("TextButton", PageSettings)
SettingsBack.BackgroundTransparency = 1
SettingsBack.Position = UDim2.new(0, 5, 0, 5)
SettingsBack.Size = UDim2.new(0, 20, 0, 20)
SettingsBack.Text = "<"
SettingsBack.TextColor3 = Color3.fromRGB(255, 255, 255)

local PrefixInput = Instance.new("TextBox", PageSettings)
PrefixInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PrefixInput.Position = UDim2.new(0.45, 0, 0.1, 0)
PrefixInput.Size = UDim2.new(0.5, 0, 0, 20)
PrefixInput.Text = ";"
PrefixInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", PrefixInput)

local AddInput = Instance.new("TextBox", PageSettings)
AddInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AddInput.Position = UDim2.new(0.05, 0, 0.22, 0)
AddInput.Size = UDim2.new(0.55, 0, 0, 25)
AddInput.Text = ""
AddInput.PlaceholderText = "أدخل الأمر المراد إضافته"
AddInput.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
AddInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", AddInput)

local AddBtn = Instance.new("TextButton", PageSettings)
AddBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AddBtn.Position = UDim2.new(0.65, 0, 0.22, 0)
AddBtn.Size = UDim2.new(0.3, 0, 0, 25)
AddBtn.Text = "إضافة"
AddBtn.TextSize = 11
AddBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", AddBtn)

local CmdListFrame = Instance.new("ScrollingFrame", PageSettings)
CmdListFrame.BackgroundTransparency = 1
CmdListFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
CmdListFrame.Size = UDim2.new(0.9, 0, 0, 140)
CmdListFrame.ScrollBarThickness = 2
Instance.new("UIListLayout", CmdListFrame).Padding = UDim.new(0, 5)

local PresetsBtn = Instance.new("TextButton", PageSettings)
PresetsBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PresetsBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
PresetsBtn.Size = UDim2.new(0.9, 0, 0, 25)
PresetsBtn.Text = "⭐ أفضل النسخ"
Instance.new("UICorner", PresetsBtn)

PagePresets.Name = "PagePresets"
PagePresets.Parent = MainFrame
PagePresets.BackgroundTransparency = 1
PagePresets.Size = UDim2.new(1, 0, 1, 0)
PagePresets.Visible = false

local PresetsBack = Instance.new("TextButton", PagePresets)
PresetsBack.BackgroundTransparency = 1
PresetsBack.Position = UDim2.new(0, 5, 0, 5)
PresetsBack.Size = UDim2.new(0, 20, 0, 20)
PresetsBack.Text = "<"
PresetsBack.TextColor3 = Color3.fromRGB(255, 255, 255)

local Btn1 = Instance.new("TextButton", PagePresets)
Btn1.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Btn1.Position = UDim2.new(0.1, 0, 0.2, 0)
Btn1.Size = UDim2.new(0.8, 0, 0, 35)
Btn1.Text = "مشرف + ادمن"
Btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Btn1)

local Btn2 = Instance.new("TextButton", PagePresets)
Btn2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Btn2.Position = UDim2.new(0.1, 0, 0.45, 0)
Btn2.Size = UDim2.new(0.8, 0, 0, 35)
Btn2.Text = "هيد ادمن"
Btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Btn2)

local Btn3 = Instance.new("TextButton", PagePresets)
Btn3.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Btn3.Position = UDim2.new(0.1, 0, 0.7, 0)
Btn3.Size = UDim2.new(0.8, 0, 0, 35)
Btn3.Text = "غامض"
Btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Btn3)

PageGhamid.Name = "PageGhamid"
PageGhamid.Parent = MainFrame
PageGhamid.BackgroundTransparency = 1
PageGhamid.Size = UDim2.new(1, 0, 1, 0)
PageGhamid.Visible = false

local GhamidBack = Instance.new("TextButton", PageGhamid)
GhamidBack.BackgroundTransparency = 1
GhamidBack.Position = UDim2.new(0, 5, 0, 5)
GhamidBack.Size = UDim2.new(0, 20, 0, 20)
GhamidBack.Text = "<"
GhamidBack.TextColor3 = Color3.fromRGB(255, 255, 255)

local GBtn1 = Instance.new("TextButton", PageGhamid)
GBtn1.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GBtn1.Position = UDim2.new(0.1, 0, 0.18, 0)
GBtn1.Size = UDim2.new(0.8, 0, 0, 35)
GBtn1.Text = "نسخة رقم 1"
GBtn1.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", GBtn1)

local GBtn2 = Instance.new("TextButton", PageGhamid)
GBtn2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GBtn2.Position = UDim2.new(0.1, 0, 0.43, 0)
GBtn2.Size = UDim2.new(0.8, 0, 0, 35)
GBtn2.Text = "نسخة رقم 2"
GBtn2.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", GBtn2)

local GBtn3 = Instance.new("TextButton", PageGhamid)
GBtn3.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GBtn3.Position = UDim2.new(0.1, 0, 0.68, 0)
GBtn3.Size = UDim2.new(0.8, 0, 0, 35)
GBtn3.Text = "نسخة رقم 3"
GBtn3.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", GBtn3)

local function activateStealthGuard(state)
    if not state then return end

    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "FAAS V6",
            Text = "تم تفعيل حماية FAAS",
            Duration = 5
        })
    end)

    task.spawn(function()
        while protectRunning do
            for _, v in pairs(CoreGui:GetDescendants()) do
                if v:IsA("TextLabel") then
                    if v.Text:find("BLUE HUB") then
                        v.Text = "FAAS V6"
                    elseif v.Text:find("PROTECTION ACTIVATED") then
                        v.Text = "تم تفعيل حماية FAAS"
                    end
                end
            end
            task.wait(0.5)
        end
    end)

    if stealthConnection then stealthConnection:Disconnect() end
    stealthConnection = CoreGui.ChildAdded:Connect(function(child)
        if child:IsA("ScreenGui") and child.Name ~= "FAAS_V6_Stealth" then
            child.Enabled = false
            task.spawn(function()
                local startBtn, timer = nil, 0
                while not startBtn and timer < 5 and protectRunning do
                    for _, v in pairs(child:GetDescendants()) do
                        if v:IsA("TextButton") and v.Text:upper():find("START PROTECTION") then startBtn = v break end
                    end
                    task.wait(0.1)
                    timer = timer + 0.1
                end
                if startBtn and protectRunning then
                    pcall(function()
                        for _, c in pairs(getconnections(startBtn.MouseButton1Click)) do c:Fire() end
                        for _, c in pairs(getconnections(startBtn.Activated)) do c:Fire() end
                    end)
                    task.wait(0.5)
                    child:Destroy()
                end
            end)
        end
    end)

    pcall(function() loadstring(game:HttpGet("https://pastefy.app/hgoHw4LA/raw"))() end)

    task.spawn(function()
        while protectRunning do
            for _, v in pairs(CoreGui:GetChildren()) do
                if v:IsA("ScreenGui") and v.Name ~= "FAAS_V6_Stealth" then
                    if v.Name:find("Blue") or v.Name:find("Hub") then v:Destroy() end
                end
            end
            task.wait(0.5)
        end
    end)
end

local function showPage(page)
    PageHome.Visible = false
    PageSettings.Visible = false
    PagePresets.Visible = false
    PageGhamid.Visible = false
    page.Visible = true
end

local function updateResult()
    local user = UsernameInput.Text
    currentPrefix = PrefixInput.Text
    if user ~= "" and #currentCommands > 0 then
        local str = ""
        for i, cmd in ipairs(currentCommands) do
            str = str .. (i == 1 and "" or " ") .. currentPrefix .. cmd .. " " .. user
        end
        ResultBox.Text = str
    else
        ResultBox.Text = "—"
    end
end

local function refreshList()
    for _, v in pairs(CmdListFrame:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    for i, cmd in ipairs(currentCommands) do
        local row = Instance.new("Frame", CmdListFrame)
        row.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        row.Size = UDim2.new(1, 0, 0, 25)
        Instance.new("UICorner", row)

        local label = Instance.new("TextLabel", row)
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0.05, 0, 0, 0)
        label.Size = UDim2.new(0.65, 0, 1, 0)
        label.Text = currentPrefix .. cmd
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left

        local del = Instance.new("TextButton", row)
        del.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        del.Position = UDim2.new(0.72, 0, 0.1, 0)
        del.Size = UDim2.new(0.25, 0, 0.8, 0)
        del.Text = "حذف"
        del.TextSize = 11
        del.TextColor3 = Color3.fromRGB(0, 0, 0)
        Instance.new("UICorner", del)

        del.MouseButton1Click:Connect(function()
            table.remove(currentCommands, i)
            refreshList()
            updateResult()
        end)
    end
end

local function sendToChat(msg)
    if msg == "" or msg == "—" then return end

    local sent = false
    pcall(function()
        local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        local dataService = remoteEvents and remoteEvents:FindFirstChild("DataService")
        if dataService then
            dataService:FireServer(msg)
            sent = true
        end
    end)

    pcall(function()
        local hdClient = ReplicatedStorage:FindFirstChild("HDAdminHDClient")
        local signals = hdClient and hdClient:FindFirstChild("Signals")
        local requestCommand = signals and signals:FindFirstChild("RequestCommandModification")
        if requestCommand then
            requestCommand:InvokeServer(msg)
            sent = true
        end
    end)

    if not sent then
        pcall(function()
            local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            local sayMessage = chatEvents and chatEvents:FindFirstChild("SayMessageRequest")
            if sayMessage then sayMessage:FireServer(msg, "All") end
        end)
    end
end

UsernameInput:GetPropertyChangedSignal("Text"):Connect(updateResult)
PrefixInput:GetPropertyChangedSignal("Text"):Connect(function() updateResult(); refreshList() end)

CopyButton.MouseButton1Click:Connect(function()
    local t = ResultBox.Text
    if t ~= "—" and t ~= "" then
        pcall(function() if setclipboard then setclipboard(t) end end)
        local old = CopyButton.Text
        CopyButton.Text = "✅ تم!"
        task.wait(1.5)
        CopyButton.Text = old
    end
end)

SpamButton.MouseButton1Click:Connect(function()
    if not spamRunning then
        if ResultBox.Text == "—" or ResultBox.Text == "" then return end
        spamRunning = true
        SpamButton.Text = "إيقاف 🛑"
        SpamButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        SpamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        task.spawn(function()
            while spamRunning do
                sendToChat(ResultBox.Text)
                task.wait(0.1)
            end
        end)
    else
        spamRunning = false
        SpamButton.Text = "تشغيل سبام 📢"
        SpamButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SpamButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    end
end)

ProtectButton.Active = true
ProtectButton.Activated:Connect(function()
    if protectRunning then return end
    protectRunning = true
    ProtectButton.Text = "الحماية مفعّلة — لإيقافها، يرجى مغادرة اللعبة ثم إعادة الدخول."
    ProtectButton.TextSize = 11
    ProtectButton.TextWrapped = true
    ProtectButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ProtectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    activateStealthGuard(true)
end)

SettingsBtn.MouseButton1Click:Connect(function() showPage(PageSettings) end)
SettingsBack.MouseButton1Click:Connect(function() showPage(PageHome) end)
PresetsBtn.MouseButton1Click:Connect(function() showPage(PagePresets) end)
PresetsBack.MouseButton1Click:Connect(function() showPage(PageSettings) end)
GhamidBack.MouseButton1Click:Connect(function() showPage(PagePresets) end)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleCircle.Visible = true
end)
ToggleCircle.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleCircle.Visible = false
    showPage(PageHome)
end)

local presetData = {
    ["مشرف + ادمن"] = {"cmdbar", "fling", "dog", "jc", "ice", "kill", "ping", "nv"},
    ["هيد ادمن"] = {"explode", "res", "jc", "ice", "cmdbar", "loopkill", "logs", "nv", "loopfling", "explode", "res"},
    ["g1"] = {"explode", "res", "jc", "ice", "loopwarp", "dog", "blur", "cmdbar", "logs", "explode", "res"},
    ["g2"] = {"jc", "ice", "loopwarp", "explode", "res", "re", "explode", "res", "re", "explode", "res", "re"},
    ["g3"] = {"explode", "res", "re", "explode", "res", "re", "explode", "res", "re"}
}

local function applyPreset(key)
    currentCommands = {}
    for _, c in ipairs(presetData[key]) do table.insert(currentCommands, c) end
    refreshList()
    updateResult()
    showPage(PageHome)
end

Btn1.MouseButton1Click:Connect(function() applyPreset("مشرف + ادمن") end)
Btn2.MouseButton1Click:Connect(function() applyPreset("هيد ادمن") end)
Btn3.MouseButton1Click:Connect(function() showPage(PageGhamid) end)
GBtn1.MouseButton1Click:Connect(function() applyPreset("g1") end)
GBtn2.MouseButton1Click:Connect(function() applyPreset("g2") end)
GBtn3.MouseButton1Click:Connect(function() applyPreset("g3") end)

AddBtn.MouseButton1Click:Connect(function()
    local newCmd = AddInput.Text:gsub(";", ""):gsub(" ", "")
    if newCmd ~= "" then
        table.insert(currentCommands, newCmd)
        AddInput.Text = ""
        refreshList()
        updateResult()
    end
end)

refreshList()
updateResult()
