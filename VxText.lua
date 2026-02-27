-- Vx Text (FULL WORKING VERSION + Pixel Font)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ================= GUI =================

local gui = Instance.new("ScreenGui")
gui.Name = "VxText"
gui.Parent = player.PlayerGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Overlay (prevents dropdown overlap)
local overlay = Instance.new("Frame")
overlay.Parent = gui
overlay.Size = UDim2.fromScale(1,1)
overlay.BackgroundTransparency = 1
overlay.ZIndex = 500

-- ================= TOGGLE BUTTON =================

local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = gui
toggleBtn.Size = UDim2.fromScale(0.12,0.06)
toggleBtn.Position = UDim2.fromScale(0.03,0.05)
toggleBtn.Text = "Open Menu"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(95,0,255)
toggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0.4,0)

-- ================= MAIN FRAME =================

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.fromScale(0.42,0.72)
main.Position = UDim2.fromScale(0.29,0.14)
main.BackgroundColor3 = Color3.fromRGB(18,18,25)
main.Visible = false
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0.03,0)

toggleBtn.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
	toggleBtn.Text = main.Visible and "Close Menu" or "Open Menu"
end)

-- ================= SETTINGS =================

local currentSettings = {
	TextColor = Color3.new(1,1,1),
	BackgroundColor = Color3.fromRGB(40,40,60),
	TextSize = 18,
	BackgroundHeight = 100
}

local multiTextEnabled = false
local generatedTexts = {}

-- ================= LAYOUT =================

local padding = Instance.new("UIPadding", main)
padding.PaddingLeft = UDim.new(0.04,0)
padding.PaddingRight = UDim.new(0.04,0)
padding.PaddingTop = UDim.new(0.04,0)

local layout = Instance.new("UIListLayout", main)
layout.Padding = UDim.new(0.04,0)

-- ================= TITLE =================

local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.fromScale(1,0.08)
title.Text = "Vx Text"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(170,100,255)

-- ================= TEXT INPUT =================

local textBox = Instance.new("TextBox")
textBox.Parent = main
textBox.Size = UDim2.fromScale(1,0.1)
textBox.PlaceholderText = "Enter your text..."
textBox.Font = Enum.Font.Gotham
textBox.TextScaled = true
textBox.BackgroundColor3 = Color3.fromRGB(30,30,40)
textBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0.2,0)

-- ================= MULTIPLE TEXT TOGGLE =================

local multiToggle = Instance.new("TextButton")
multiToggle.Parent = main
multiToggle.Size = UDim2.fromScale(1,0.08)
multiToggle.Text = "Multiple Text: OFF"
multiToggle.Font = Enum.Font.GothamBold
multiToggle.TextScaled = true
multiToggle.BackgroundColor3 = Color3.fromRGB(150,50,50)
multiToggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", multiToggle).CornerRadius = UDim.new(0.3,0)

multiToggle.MouseButton1Click:Connect(function()
	multiTextEnabled = not multiTextEnabled
	
	if multiTextEnabled then
		multiToggle.Text = "Multiple Text: ON"
		multiToggle.BackgroundColor3 = Color3.fromRGB(0,170,100)
	else
		multiToggle.Text = "Multiple Text: OFF"
		multiToggle.BackgroundColor3 = Color3.fromRGB(150,50,50)
		
		for i = #generatedTexts, 2, -1 do
			generatedTexts[i]:Destroy()
			table.remove(generatedTexts, i)
		end
	end
end)

-- ================= PIXEL FONT TOGGLE =================

local pixelEnabled = false
local defaultFonts = {}
local pixelFont = Enum.Font.Arcade

local pixelBtn = Instance.new("TextButton")
pixelBtn.Parent = main
pixelBtn.Size = UDim2.fromScale(1,0.08)
pixelBtn.Text = "Pixel Font: OFF"
pixelBtn.Font = Enum.Font.GothamBold
pixelBtn.TextScaled = true
pixelBtn.BackgroundColor3 = Color3.fromRGB(70,70,90)
pixelBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", pixelBtn).CornerRadius = UDim.new(0.3,0)

local function applyPixelFont(state)
	for _,obj in ipairs(game:GetDescendants()) do
		if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
			if state then
				if not defaultFonts[obj] then
					defaultFonts[obj] = obj.Font
				end
				obj.Font = pixelFont
			else
				if defaultFonts[obj] then
					obj.Font = defaultFonts[obj]
				end
			end
		end
	end
end

game.DescendantAdded:Connect(function(obj)
	if pixelEnabled then
		if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
			task.wait()
			obj.Font = pixelFont
		end
	end
end)

pixelBtn.MouseButton1Click:Connect(function()
	pixelEnabled = not pixelEnabled
	
	if pixelEnabled then
		pixelBtn.Text = "Pixel Font: ON"
		pixelBtn.BackgroundColor3 = Color3.fromRGB(0,200,120)
		applyPixelFont(true)
	else
		pixelBtn.Text = "Pixel Font: OFF"
		pixelBtn.BackgroundColor3 = Color3.fromRGB(70,70,90)
		applyPixelFont(false)
	end
end)

-- ================= GENERATE + DELETE =================

local buttonRow = Instance.new("Frame")
buttonRow.Parent = main
buttonRow.Size = UDim2.fromScale(1,0.1)
buttonRow.BackgroundTransparency = 1

local rowLayout = Instance.new("UIListLayout", buttonRow)
rowLayout.FillDirection = Enum.FillDirection.Horizontal
rowLayout.Padding = UDim.new(0.04,0)

local function createButton(text,color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromScale(0.48,1)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0.3,0)
	return btn
end

local generateBtn = createButton("Generate", Color3.fromRGB(0,170,255))
generateBtn.Parent = buttonRow

local deleteBtn = createButton("Delete", Color3.fromRGB(200,50,50))
deleteBtn.Parent = buttonRow

generateBtn.MouseButton1Click:Connect(function()
	if textBox.Text == "" then return end
	
	if not multiTextEnabled then
		for _,obj in pairs(generatedTexts) do
			obj:Destroy()
		end
		generatedTexts = {}
	end
	
	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(0,400,0,currentSettings.BackgroundHeight)
	label.Position = UDim2.new(0.5,-200,0.5,-60 + (#generatedTexts * 120))
	label.TextWrapped = true
	label.Text = textBox.Text
	label.TextSize = currentSettings.TextSize
	label.TextColor3 = currentSettings.TextColor
	label.BackgroundColor3 = currentSettings.BackgroundColor
	label.Active = true
	label.Draggable = true
	label.ZIndex = 100
	
	Instance.new("UICorner", label).CornerRadius = UDim.new(0,16)
	table.insert(generatedTexts, label)
end)

deleteBtn.MouseButton1Click:Connect(function()
	for _,obj in pairs(generatedTexts) do
		obj:Destroy()
	end
	generatedTexts = {}
end)

-- ================= SIZE PRESETS =================

local sizeRow = Instance.new("Frame")
sizeRow.Parent = main
sizeRow.Size = UDim2.fromScale(1,0.1)
sizeRow.BackgroundTransparency = 1

local sizeLayout = Instance.new("UIListLayout", sizeRow)
sizeLayout.FillDirection = Enum.FillDirection.Horizontal
sizeLayout.Padding = UDim.new(0.04,0)

local selectedSizeBtn

local function createSizeButton(name,textSize,bgHeight)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromScale(0.3,1)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
	btn.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0.4,0)

	btn.MouseButton1Click:Connect(function()
		currentSettings.TextSize = textSize
		currentSettings.BackgroundHeight = bgHeight

		if selectedSizeBtn then
			selectedSizeBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
		end

		btn.BackgroundColor3 = Color3.fromRGB(0,255,0)
		selectedSizeBtn = btn
	end)

	return btn
end

local small = createSizeButton("Small",18,100)
small.Parent = sizeRow
small.BackgroundColor3 = Color3.fromRGB(0,255,0)
selectedSizeBtn = small

createSizeButton("Medium",32,120).Parent = sizeRow
createSizeButton("Large",48,160).Parent = sizeRow
