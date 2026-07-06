--[[
    TOOL TRANSFER SYSTEM - LOADSTRING VERSION (PC + MOBILE)
    Copy and paste into your executor:
    
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pdiddy445/Meme231/main/ToolTransfer.lua"))()
    
    Features:
    - Give tools to other players
    - GUI interface with player list
    - PC: Press K to open
    - Mobile: Tap button to open
    - Safety checks
    - Auto-refresh
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- ===== STATE VARIABLES =====
local selectedTool = nil
local selectedPlayer = nil
local toolTransferGUI = nil
local menuButton = nil

-- Forward declare the function
local createToolTransferGUI

-- ===== CREATE MAIN GUI =====
function createToolTransferGUI()
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ToolTransferGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Add shadow
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 2
    shadow.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "🎁 TOOL TRANSFER"
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 40, 1, 0)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.BackgroundTransparency = 0
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "✕"
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        toolTransferGUI = nil
    end)
    
    -- ===== TOOLS SECTION =====
    local toolsLabel = Instance.new("TextLabel")
    toolsLabel.Name = "ToolsLabel"
    toolsLabel.Size = UDim2.new(1, -20, 0, 25)
    toolsLabel.Position = UDim2.new(0, 10, 0, 50)
    toolsLabel.BackgroundTransparency = 1
    toolsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    toolsLabel.TextSize = 14
    toolsLabel.Font = Enum.Font.GothamBold
    toolsLabel.Text = "📦 YOUR TOOLS"
    toolsLabel.TextXAlignment = Enum.TextXAlignment.Left
    toolsLabel.Parent = mainFrame
    
    -- Tools Container
    local toolsContainer = Instance.new("Frame")
    toolsContainer.Name = "ToolsContainer"
    toolsContainer.Size = UDim2.new(1, -20, 0, 100)
    toolsContainer.Position = UDim2.new(0, 10, 0, 75)
    toolsContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toolsContainer.BorderSizePixel = 0
    toolsContainer.Parent = mainFrame
    
    local toolsCorner = Instance.new("UICorner")
    toolsCorner.CornerRadius = UDim.new(0, 8)
    toolsCorner.Parent = toolsContainer
    
    -- Tools Grid Layout
    local toolsScroll = Instance.new("UIGridLayout")
    toolsScroll.Parent = toolsContainer
    toolsScroll.CellPadding = UDim2.new(0, 5, 0, 5)
    toolsScroll.CellSize = UDim2.new(0.5, -3, 0, 40)
    toolsScroll.FillDirection = Enum.FillDirection.Vertical
    toolsScroll.FillDirectionMaxCells = 2
    
    -- ===== PLAYERS SECTION =====
    local playersLabel = Instance.new("TextLabel")
    playersLabel.Name = "PlayersLabel"
    playersLabel.Size = UDim2.new(1, -20, 0, 25)
    playersLabel.Position = UDim2.new(0, 10, 0, 190)
    playersLabel.BackgroundTransparency = 1
    playersLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    playersLabel.TextSize = 14
    playersLabel.Font = Enum.Font.GothamBold
    playersLabel.Text = "👥 PLAYERS"
    playersLabel.TextXAlignment = Enum.TextXAlignment.Left
    playersLabel.Parent = mainFrame
    
    -- Players Container
    local playersContainer = Instance.new("ScrollingFrame")
    playersContainer.Name = "PlayersContainer"
    playersContainer.Size = UDim2.new(1, -20, 0, 180)
    playersContainer.Position = UDim2.new(0, 10, 0, 215)
    playersContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    playersContainer.BorderSizePixel = 0
    playersContainer.ScrollBarThickness = 8
    playersContainer.Parent = mainFrame
    
    local playersCorner = Instance.new("UICorner")
    playersCorner.CornerRadius = UDim.new(0, 8)
    playersCorner.Parent = playersContainer
    
    -- Players List
    local playersList = Instance.new("UIListLayout")
    playersList.Parent = playersContainer
    playersList.Padding = UDim.new(0, 5)
    playersList.FillDirection = Enum.FillDirection.Vertical
    playersList.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- ===== TRANSFER BUTTON =====
    local transferBtn = Instance.new("TextButton")
    transferBtn.Name = "TransferBtn"
    transferBtn.Size = UDim2.new(1, -20, 0, 40)
    transferBtn.Position = UDim2.new(0, 10, 1, -50)
    transferBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    transferBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    transferBtn.TextSize = 14
    transferBtn.Font = Enum.Font.GothamBold
    transferBtn.Text = "✓ GIVE TOOL"
    transferBtn.BorderSizePixel = 0
    transferBtn.Parent = mainFrame
    
    local transferCorner = Instance.new("UICorner")
    transferCorner.CornerRadius = UDim.new(0, 8)
    transferCorner.Parent = transferBtn
    
    transferBtn.MouseEnter:Connect(function()
        transferBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    end)
    
    transferBtn.MouseLeave:Connect(function()
        transferBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)
    
    -- ===== UPDATE TOOLS LIST =====
    local function updateToolsList()
        -- Clear existing
        for _, child in pairs(toolsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Get tools from backpack
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local toolBtn = Instance.new("TextButton")
                    toolBtn.Size = UDim2.new(0.5, -3, 0, 40)
                    toolBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    toolBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    toolBtn.TextSize = 12
                    toolBtn.Font = Enum.Font.Gotham
                    toolBtn.Text = tool.Name
                    toolBtn.BorderSizePixel = 1
                    toolBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
                    toolBtn.Parent = toolsContainer
                    
                    local btnCorner = Instance.new("UICorner")
                    btnCorner.CornerRadius = UDim.new(0, 6)
                    btnCorner.Parent = toolBtn
                    
                    toolBtn.MouseButton1Click:Connect(function()
                        selectedTool = tool
                        
                        -- Update UI
                        for _, btn in pairs(toolsContainer:GetChildren()) do
                            if btn:IsA("TextButton") then
                                btn.BorderColor3 = Color3.fromRGB(100, 100, 100)
                            end
                        end
                        toolBtn.BorderColor3 = Color3.fromRGB(0, 200, 100)
                    end)
                    
                    toolBtn.MouseEnter:Connect(function()
                        toolBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    end)
                    
                    toolBtn.MouseLeave:Connect(function()
                        toolBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    end)
                end
            end
        end
    end
    
    -- ===== UPDATE PLAYERS LIST =====
    local function updatePlayersList()
        -- Clear existing
        for _, child in pairs(playersContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Add players
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local playerBtn = Instance.new("TextButton")
                playerBtn.Size = UDim2.new(1, -16, 0, 35)
                playerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                playerBtn.TextSize = 12
                playerBtn.Font = Enum.Font.Gotham
                playerBtn.Text = "👤 " .. plr.Name
                playerBtn.TextXAlignment = Enum.TextXAlignment.Left
                playerBtn.BorderSizePixel = 1
                playerBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
                playerBtn.Parent = playersContainer
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = playerBtn
                
                playerBtn.MouseButton1Click:Connect(function()
                    selectedPlayer = plr
                    
                    -- Update UI
                    for _, btn in pairs(playersContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BorderColor3 = Color3.fromRGB(100, 100, 100)
                        end
                    end
                    playerBtn.BorderColor3 = Color3.fromRGB(0, 200, 100)
                end)
                
                playerBtn.MouseEnter:Connect(function()
                    playerBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                end)
                
                playerBtn.MouseLeave:Connect(function()
                    playerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end)
            end
        end
    end
    
    -- ===== TRANSFER TOOL =====
    transferBtn.MouseButton1Click:Connect(function()
        if not selectedTool then
            print("❌ No tool selected!")
            return
        end
        if not selectedPlayer then
            print("❌ No player selected!")
            return
        end
        
        local targetBackpack = selectedPlayer:FindFirstChild("Backpack")
        if targetBackpack then
            selectedTool:Clone().Parent = targetBackpack
            print("✓ Gave " .. selectedTool.Name .. " to " .. selectedPlayer.Name)
            updateToolsList()
        end
    end)
    
    -- ===== REFRESH ON INTERVAL =====
    spawn(function()
        while screenGui.Parent do
            wait(1)
            updateToolsList()
            updatePlayersList()
        end
    end)
    
    updateToolsList()
    updatePlayersList()
    
    return screenGui
end

-- ===== CREATE MENU BUTTON (MOBILE) =====
local function createMenuButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ToolTransferMenuGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local button = Instance.new("TextButton")
    button.Name = "MenuButton"
    button.Size = UDim2.new(0, 80, 0, 50)
    button.Position = UDim2.new(0, 10, 0.5, -25)
    button.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    button.BackgroundTransparency = 0.2
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.Text = "🎁"
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(255, 150, 0)
    button.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        print("Button clicked!")
        if toolTransferGUI then
            toolTransferGUI:Destroy()
            toolTransferGUI = nil
            print("GUI closed")
        else
            toolTransferGUI = createToolTransferGUI()
            print("GUI opened")
        end
    end)
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    end)
    
    return button, screenGui
end

-- ===== PC KEYBOARD INPUT =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Press K to open Tool Transfer menu
    if input.KeyCode == Enum.KeyCode.K then
        if toolTransferGUI then
            toolTransferGUI:Destroy()
            toolTransferGUI = nil
        else
            toolTransferGUI = createToolTransferGUI()
        end
    end
end)

-- ===== INITIALIZATION =====
menuButton, _ = createMenuButton()

print("✓ Tool Transfer System Loaded!")
print("PC: Press K to open the Tool Transfer GUI")
print("Mobile: Tap the 🎁 button on the side")
