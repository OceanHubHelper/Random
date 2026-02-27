-- Vx Text (Stable + Customize Restored)

local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer

-- ================= SETTINGS =================

local settings = {
	TextSize = 30,
	TextColor = Color3.fromRGB(255,255,255),
	BackgroundColor = Color3.fromRGB(40,40,40)
}

local pixelEnabled = false
local multiEnabled = false
local foldingEnabled = false
local generatedTexts = {}
local activeDropdown = nil
local MAX_WIDTH = 500

-- ================= GUI =================

local gui = Instance.new("ScreenGui")
gui.Name = "VxText"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ================= OPEN BUTTON =================

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromScale(0.15,0.06)
openBtn.Position = UDim2.fromScale(0.03,0.05)
openBtn.Text = "Open Menu"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextScaled = true
openBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
openBtn.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", openBtn)

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.45,0.7)
main.Position = UDim2.fromScale(0.27,0.15)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.Visible = false
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

openBtn.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- ================= TABS =================

local tabText = Instance.new("TextButton", main)
tabText.Size = UDim2.fromScale(0.5,0.08)
tabText.Position = UDim2.fromScale(0,0)
tabText.Text = "Text"
tabText.Font = Enum.Font.GothamBold
tabText.TextScaled = true
tabText.BackgroundColor3 = Color3.fromRGB(30,30,30)
tabText.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", tabText)

local tabCustom = Instance.new("TextButton", main)
tabCustom.Size = UDim2.fromScale(0.5,0.08)
tabCustom.Position = UDim2.fromScale(0.5,0)
tabCustom.Text = "Customize"
tabCustom.Font = Enum.Font.GothamBold
tabCustom.TextScaled = true
tabCustom.BackgroundColor3 = Color3.fromRGB(30,30,30)
tabCustom.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", tabCustom)

local textPage = Instance.new("Frame", main)
textPage.Size = UDim2.fromScale(1,0.92)
textPage.Position = UDim2.fromScale(0,0.08)
textPage.BackgroundTransparency = 1

local customPage = Instance.new("Frame", main)
customPage.Size = UDim2.fromScale(1,0.92)
customPage.Position = UDim2.fromScale(0,0.08)
customPage.BackgroundTransparency = 1
customPage.Visible = false

tabText.MouseButton1Click:Connect(function()
	textPage.Visible = true
	customPage.Visible = false
end)

tabCustom.MouseButton1Click:Connect(function()
	textPage.Visible = false
	customPage.Visible = true
end)

-- ================= TEXT TAB =================

local textBox = Instance.new("TextBox", textPage)
textBox.Size = UDim2.fromScale(0.9,0.12)
textBox.Position = UDim2.fromScale(0.05,0.08)
textBox.PlaceholderText = "Enter text..."
textBox.Font = Enum.Font.GothamBold
textBox.TextSize = 20
textBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
textBox.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", textBox)

-- Multiple Toggle

local multiBtn = Instance.new("TextButton", textPage)
multiBtn.Size = UDim2.fromScale(0.9,0.12)
multiBtn.Position = UDim2.fromScale(0.05,0.25)
multiBtn.Text = "Multiple: OFF"
multiBtn.Font = Enum.Font.GothamBold
multiBtn.TextScaled = true
multiBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
multiBtn.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", multiBtn)

multiBtn.MouseButton1Click:Connect(function()
	multiEnabled = not multiEnabled
	multiBtn.Text = multiEnabled and "Multiple: ON" or "Multiple: OFF"

	if not multiEnabled then
		for i = #generatedTexts, 2, -1 do
			generatedTexts[i]:Destroy()
			table.remove(generatedTexts, i)
		end
	end
end)

-- Generate Function (unchanged logic)

local function generateText()

	if textBox.Text == "" then return end

	local finalText = foldingEnabled and textBox.Text or textBox.Text:gsub("\n"," ")
	local fontToUse = pixelEnabled and Enum.Font.Arcade or Enum.Font.GothamBold

	if not multiEnabled and #generatedTexts >= 1 then
		generatedTexts[1]:Destroy()
		generatedTexts = {}
	end

	local textSize = TextService:GetTextSize(
		finalText,
		settings.TextSize,
		fontToUse,
		foldingEnabled and Vector2.new(MAX_WIDTH,1000) or Vector2.new(1000,1000)
	)

	local padding = 40
	local width = foldingEnabled and MAX_WIDTH or (textSize.X + padding)
	local height = textSize.Y + padding

	local holder = Instance.new("Frame", gui)
	holder.Size = UDim2.fromOffset(width,height)
	holder.Position = UDim2.new(0.5,-width/2,0.5,-height/2)
	holder.BackgroundColor3 = settings.BackgroundColor
	holder.Active = true
	holder.Draggable = true
	holder.ZIndex = 1000
	Instance.new("UICorner", holder)

	local label = Instance.new("TextLabel", holder)
	label.Size = UDim2.new(1,-20,1,-20)
	label.Position = UDim2.new(0,10,0,10)
	label.BackgroundTransparency = 1
	label.Text = finalText
	label.TextWrapped = foldingEnabled
	label.TextColor3 = settings.TextColor
	label.TextSize = settings.TextSize
	label.Font = fontToUse
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.ZIndex = 1001

	table.insert(generatedTexts, holder)
end

local generateBtn = Instance.new("TextButton", textPage)
generateBtn.Size = UDim2.fromScale(0.9,0.12)
generateBtn.Position = UDim2.fromScale(0.05,0.42)
generateBtn.Text = "Generate"
generateBtn.Font = Enum.Font.GothamBold
generateBtn.TextScaled = true
generateBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
generateBtn.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", generateBtn)

generateBtn.MouseButton1Click:Connect(generateText)

-- ================= CUSTOMIZE TAB =================

-- Folding Toggle (moved here)

local foldingBtn = Instance.new("TextButton", customPage)
foldingBtn.Size = UDim2.fromScale(0.9,0.12)
foldingBtn.Position = UDim2.fromScale(0.05,0.08)
foldingBtn.Text = "Line Text: ON"
foldingBtn.Font = Enum.Font.GothamBold
foldingBtn.TextScaled = true
foldingBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
foldingBtn.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", foldingBtn)

foldingBtn.MouseButton1Click:Connect(function()
	foldingEnabled = not foldingEnabled
	foldingBtn.Text = foldingEnabled and "Folding Text: ON" or "Line Text: ON"
end)

-- Pixel Font Toggle

local pixelBtn = Instance.new("TextButton", customPage)
pixelBtn.Size = UDim2.fromScale(0.9,0.12)
pixelBtn.Position = UDim2.fromScale(0.05,0.25)
pixelBtn.Text = "Pixel Font: OFF"
pixelBtn.Font = Enum.Font.GothamBold
pixelBtn.TextScaled = true
pixelBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
pixelBtn.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", pixelBtn)

pixelBtn.MouseButton1Click:Connect(function()
	pixelEnabled = not pixelEnabled
	pixelBtn.Text = pixelEnabled and "Pixel Font: ON" or "Pixel Font: OFF"
end)

-- ================= DROPDOWNS =================

local colors = {
	{"White",Color3.fromRGB(255,255,255)},
	{"Red",Color3.fromRGB(255,0,0)},
	{"Green",Color3.fromRGB(0,255,0)},
	{"Blue",Color3.fromRGB(0,0,255)},
	{"Yellow",Color3.fromRGB(255,255,0)},
	{"Purple",Color3.fromRGB(150,0,255)},
	{"Orange",Color3.fromRGB(255,140,0)},
	{"Pink",Color3.fromRGB(255,105,180)}
}

local function createDropdown(button, settingKey)

	if activeDropdown then
		activeDropdown:Destroy()
	end

	local dropdown = Instance.new("Frame", gui)
	dropdown.Size = UDim2.fromOffset(200,#colors*30)
	dropdown.Position = UDim2.fromOffset(button.AbsolutePosition.X, button.AbsolutePosition.Y + button.AbsoluteSize.Y)
	dropdown.BackgroundColor3 = Color3.fromRGB(25,25,25)
	dropdown.ZIndex = 5000
	Instance.new("UICorner", dropdown)

	activeDropdown = dropdown

	for i,data in ipairs(colors) do
		local option = Instance.new("TextButton", dropdown)
		option.Size = UDim2.new(1,0,0,30)
		option.Position = UDim2.new(0,0,0,(i-1)*30)
		option.Text = data[1]
		option.Font = Enum.Font.GothamBold
		option.TextSize = 14
		option.BackgroundColor3 = Color3.fromRGB(40,40,40)
		option.TextColor3 = Color3.fromRGB(220,220,220)
		option.ZIndex = 5001

		option.MouseButton1Click:Connect(function()
			settings[settingKey] = data[2]
			button.Text = button.Name .. ": " .. data[1]
			dropdown:Destroy()
			activeDropdown = nil
		end)
	end
end

-- Text Color Button

local textColorBtn = Instance.new("TextButton", customPage)
textColorBtn.Name = "Text Color"
textColorBtn.Size = UDim2.fromScale(0.9,0.12)
textColorBtn.Position = UDim2.fromScale(0.05,0.42)
textColorBtn.Text = "Text Color"
textColorBtn.Font = Enum.Font.GothamBold
textColorBtn.TextScaled = true
textColorBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
textColorBtn.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", textColorBtn)

textColorBtn.MouseButton1Click:Connect(function()
	createDropdown(textColorBtn,"TextColor")
end)

-- Background Color Button

local bgColorBtn = Instance.new("TextButton", customPage)
bgColorBtn.Name = "Background Color"
bgColorBtn.Size = UDim2.fromScale(0.9,0.12)
bgColorBtn.Position = UDim2.fromScale(0.05,0.59)
bgColorBtn.Text = "Background Color"
bgColorBtn.Font = Enum.Font.GothamBold
bgColorBtn.TextScaled = true
bgColorBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
bgColorBtn.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", bgColorBtn)

bgColorBtn.MouseButton1Click:Connect(function()
	createDropdown(bgColorBtn,"BackgroundColor")
end)
