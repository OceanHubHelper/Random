--// VxText Premuim - FINAL FULL BUILD

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

--------------------------------------------------
-- SETTINGS
--------------------------------------------------

local Settings = {
	TextSize = 28,
	TextColor = Color3.fromRGB(255,255,255),
	BackgroundColor = Color3.fromRGB(35,35,45),
	Folding = false,
	Multi = false,
	Pixel = false,
	FPSCorner = true
}

local Generated = {}
local activeDropdown

--------------------------------------------------
-- ZINDEX RULES
--------------------------------------------------
-- 1 main
-- 2 tabs
-- 3 content
-- 4 page
-- 5 controls
-- 20 generated
-- 50 dropdown
-- 100 reopen

--------------------------------------------------
-- THEME
--------------------------------------------------

local PurpleMain = Color3.fromRGB(28,18,45)
local PurpleDark = Color3.fromRGB(60,0,120)
local PurpleLight = Color3.fromRGB(170,100,255)

--------------------------------------------------
-- GUI ROOT
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player.PlayerGui

--------------------------------------------------
-- MAIN FRAME
--------------------------------------------------

local main = Instance.new("Frame",gui)
main.Size = UDim2.fromScale(0.55,0.8)
main.Position = UDim2.fromScale(0.22,0.1)
main.BackgroundColor3 = PurpleMain
main.Active = true
main.Draggable = true
main.ZIndex = 1
Instance.new("UICorner",main)

Instance.new("UIStroke",main).Color = PurpleLight

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0.08,0)
title.BackgroundTransparency = 1
title.Text = "VxText Premuim"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = PurpleLight
title.ZIndex = 5

--------------------------------------------------
-- CLOSE / REOPEN
--------------------------------------------------

local close = Instance.new("TextButton",main)
close.Size = UDim2.fromOffset(28,28)
close.Position = UDim2.new(1,-36,0,6)
close.Text = "X"
close.Font = Enum.Font.GothamBlack
close.TextScaled = true
close.BackgroundColor3 = PurpleDark
close.TextColor3 = Color3.new(1,1,1)
close.ZIndex = 6
Instance.new("UICorner",close)

local reopen = close:Clone()
reopen.Parent = gui
reopen.Text = "+"
reopen.Position = UDim2.new(1,-36,0,6)
reopen.Visible = false
reopen.ZIndex = 100

close.MouseButton1Click:Connect(function()
	main.Visible = false
	reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
	main.Visible = true
	reopen.Visible = false
end)

--------------------------------------------------
-- TABS
--------------------------------------------------

local tabs = {"Text","Customize","Performance","Images"}
local Pages = {}

local tabBar = Instance.new("Frame",main)
tabBar.Size = UDim2.new(1,0,0.08,0)
tabBar.Position = UDim2.new(0,0,0.08,0)
tabBar.BackgroundTransparency = 1
tabBar.ZIndex = 2

local content = Instance.new("Frame",main)
content.Size = UDim2.new(1,0,0.84,0)
content.Position = UDim2.new(0,0,0.16,0)
content.BackgroundTransparency = 1
content.ZIndex = 3

for i,name in ipairs(tabs) do
	local tab = Instance.new("TextButton",tabBar)
	tab.Size = UDim2.new(1/#tabs,0,1,0)
	tab.Position = UDim2.new((i-1)/#tabs,0,0,0)
	tab.Text = name
	tab.BackgroundColor3 = PurpleDark
	tab.TextColor3 = Color3.new(1,1,1)
	tab.Font = Enum.Font.GothamBold
	tab.TextScaled = true
	tab.ZIndex = 3
	Instance.new("UICorner",tab)

	local page = Instance.new("Frame",content)
	page.Size = UDim2.new(1,0,1,0)
	page.BackgroundTransparency = 1
	page.Visible = (i==1)
	page.ZIndex = 4
	Pages[name] = page

	tab.MouseButton1Click:Connect(function()
		for _,p in pairs(Pages) do p.Visible = false end
		page.Visible = true
	end)
end

--------------------------------------------------
-- 80+ COLORS
--------------------------------------------------

local Colors = {
{"White",Color3.fromRGB(255,255,255)},{"Black",Color3.fromRGB(0,0,0)},
{"Red",Color3.fromRGB(255,0,0)},{"Crimson",Color3.fromRGB(220,20,60)},
{"Orange",Color3.fromRGB(255,140,0)},{"Gold",Color3.fromRGB(255,200,60)},
{"Yellow",Color3.fromRGB(255,255,0)},{"Lime",Color3.fromRGB(50,205,50)},
{"Green",Color3.fromRGB(0,255,0)},{"Emerald",Color3.fromRGB(0,201,87)},
{"Teal",Color3.fromRGB(0,128,128)},{"Cyan",Color3.fromRGB(0,255,255)},
{"Blue",Color3.fromRGB(0,0,255)},{"Royal Blue",Color3.fromRGB(65,105,225)},
{"Navy",Color3.fromRGB(0,0,128)},{"Purple",Color3.fromRGB(150,0,255)},
{"Violet",Color3.fromRGB(143,0,255)},{"Magenta",Color3.fromRGB(255,0,255)},
{"Pink",Color3.fromRGB(255,20,147)},{"Hot Pink",Color3.fromRGB(255,105,180)},
{"Brown",Color3.fromRGB(139,69,19)},{"Chocolate",Color3.fromRGB(210,105,30)},
{"Beige",Color3.fromRGB(245,245,220)},{"Gray",Color3.fromRGB(128,128,128)},
{"Silver",Color3.fromRGB(192,192,192)},{"Charcoal",Color3.fromRGB(54,69,79)},
{"Midnight",Color3.fromRGB(25,25,40)},{"Neon Green",Color3.fromRGB(57,255,20)},
{"Neon Pink",Color3.fromRGB(255,16,240)},{"Neon Cyan",Color3.fromRGB(0,255,255)},
{"Neon Yellow",Color3.fromRGB(255,255,33)},{"Sky Blue",Color3.fromRGB(135,206,235)},
{"Baby Blue",Color3.fromRGB(137,207,240)},{"Lavender",Color3.fromRGB(230,230,250)},
{"Indigo",Color3.fromRGB(75,0,130)},{"Plum",Color3.fromRGB(142,69,133)},
{"Orchid",Color3.fromRGB(218,112,214)},{"Blush",Color3.fromRGB(222,93,131)},
{"Mocha",Color3.fromRGB(112,66,20)},{"Storm",Color3.fromRGB(70,130,180)}
}

--------------------------------------------------
-- DROPDOWN FUNCTION
--------------------------------------------------

local function CreateDropdown(button,key)
	if activeDropdown then activeDropdown:Destroy() end

	local frame = Instance.new("Frame",gui)
	frame.Size = UDim2.fromOffset(220,250)
	frame.Position = UDim2.fromOffset(button.AbsolutePosition.X,
		button.AbsolutePosition.Y + button.AbsoluteSize.Y)
	frame.BackgroundColor3 = PurpleDark
	frame.ZIndex = 50
	Instance.new("UICorner",frame)
	activeDropdown = frame

	local scroll = Instance.new("ScrollingFrame",frame)
	scroll.Size = UDim2.new(1,0,1,0)
	scroll.CanvasSize = UDim2.new(0,0,0,#Colors*28)
	scroll.ScrollBarThickness = 6
	scroll.BackgroundTransparency = 1
	scroll.ZIndex = 51

	for i,data in ipairs(Colors) do
		local opt = Instance.new("TextButton",scroll)
		opt.Size = UDim2.new(1,0,0,25)
		opt.Position = UDim2.new(0,0,0,(i-1)*28)
		opt.Text = data[1]
		opt.BackgroundColor3 = data[2]
		opt.TextColor3 = Color3.new(1,1,1)
		opt.Font = Enum.Font.GothamBold
		opt.TextScaled = true
		opt.ZIndex = 52
		Instance.new("UICorner",opt)

		opt.MouseButton1Click:Connect(function()
			Settings[key] = data[2]
			button.Text = key.." : "..data[1]
			frame:Destroy()
		end)
	end
end
--------------------------------------------------
-- TEXT TAB
--------------------------------------------------

local textPage = Pages["Text"]

local input = Instance.new("TextBox",textPage)
input.Size = UDim2.fromScale(0.9,0.12)
input.Position = UDim2.fromScale(0.05,0.05)
input.PlaceholderText = "Enter text..."
input.TextScaled = true
input.Font = Enum.Font.GothamBold
input.BackgroundColor3 = Color3.fromRGB(40,40,60)
input.TextColor3 = Settings.TextColor
input.ZIndex = 5
Instance.new("UICorner",input)

local function GenerateText()
	if input.Text == "" then return end

	if not Settings.Multi then
		for _,v in pairs(Generated) do v:Destroy() end
		Generated = {}
	end

	local size = TextService:GetTextSize(
		input.Text,
		Settings.TextSize,
		Settings.Pixel and Enum.Font.Arcade or Enum.Font.GothamBold,
		Vector2.new(1000,1000)
	)

	local frame = Instance.new("Frame",gui)
	frame.Size = UDim2.fromOffset(size.X+40,size.Y+40)
	frame.Position = UDim2.new(0.5,-(size.X+40)/2,0.5,-(size.Y+40)/2)
	frame.BackgroundColor3 = Settings.BackgroundColor
	frame.Active = true
	frame.Draggable = true
	frame.ZIndex = 20
	Instance.new("UICorner",frame)

	local tinyDelete = Instance.new("TextButton",frame)
	tinyDelete.Size = UDim2.fromOffset(20,20)
	tinyDelete.Position = UDim2.new(1,-22,0,2)
	tinyDelete.Text = "X"
	tinyDelete.Font = Enum.Font.GothamBold
	tinyDelete.TextScaled = true
	tinyDelete.BackgroundColor3 = Color3.fromRGB(200,50,50)
	tinyDelete.TextColor3 = Color3.new(1,1,1)
	tinyDelete.ZIndex = 21
	Instance.new("UICorner",tinyDelete)

	local lock = Instance.new("TextButton",frame)
	lock.Size = UDim2.fromOffset(20,20)
	lock.Position = UDim2.new(0,2,1,-22)
	lock.Text = "🔓"
	lock.TextScaled = true
	lock.BackgroundColor3 = Color3.fromRGB(80,80,120)
	lock.ZIndex = 21
	Instance.new("UICorner",lock)

	lock.MouseButton1Click:Connect(function()
		frame.Draggable = not frame.Draggable
		lock.Text = frame.Draggable and "🔓" or "🔒"
	end)

	tinyDelete.MouseButton1Click:Connect(function()
		frame:Destroy()
	end)

	local label = Instance.new("TextLabel",frame)
	label.Size = UDim2.new(1,-20,1,-20)
	label.Position = UDim2.new(0,10,0,10)
	label.BackgroundTransparency = 1
	label.Text = input.Text
	label.TextColor3 = Settings.TextColor
	label.TextSize = Settings.TextSize
	label.TextWrapped = Settings.Folding
	label.Font = Settings.Pixel and Enum.Font.Arcade or Enum.Font.GothamBold
	label.ZIndex = 21

	table.insert(Generated,frame)
end

local genBtn = Instance.new("TextButton",textPage)
genBtn.Size = UDim2.fromScale(0.9,0.08)
genBtn.Position = UDim2.fromScale(0.05,0.2)
genBtn.Text = "Generate"
genBtn.Font = Enum.Font.GothamBold
genBtn.TextScaled = true
genBtn.BackgroundColor3 = PurpleDark
genBtn.TextColor3 = Color3.new(1,1,1)
genBtn.ZIndex = 5
Instance.new("UICorner",genBtn)

genBtn.MouseButton1Click:Connect(GenerateText)

local multiBtn = genBtn:Clone()
multiBtn.Parent = textPage
multiBtn.Position = UDim2.fromScale(0.05,0.3)
multiBtn.Text = "Multiple: OFF"
multiBtn.ZIndex = 5
multiBtn.MouseButton1Click:Connect(function()
	Settings.Multi = not Settings.Multi
	multiBtn.Text = "Multiple: "..(Settings.Multi and "ON" or "OFF")
end)

--------------------------------------------------
-- CUSTOMIZE TAB
--------------------------------------------------

local customPage = Pages["Customize"]

local textColorBtn = Instance.new("TextButton",customPage)
textColorBtn.Size = UDim2.fromScale(0.9,0.08)
textColorBtn.Position = UDim2.fromScale(0.05,0.05)
textColorBtn.Text = "TextColor"
textColorBtn.Font = Enum.Font.GothamBold
textColorBtn.TextScaled = true
textColorBtn.BackgroundColor3 = PurpleDark
textColorBtn.TextColor3 = Color3.new(1,1,1)
textColorBtn.ZIndex = 5
Instance.new("UICorner",textColorBtn)

textColorBtn.MouseButton1Click:Connect(function()
	CreateDropdown(textColorBtn,"TextColor")
end)

local bgColorBtn = textColorBtn:Clone()
bgColorBtn.Parent = customPage
bgColorBtn.Position = UDim2.fromScale(0.05,0.17)
bgColorBtn.Text = "BackgroundColor"
bgColorBtn.ZIndex = 5
bgColorBtn.MouseButton1Click:Connect(function()
	CreateDropdown(bgColorBtn,"BackgroundColor")
end)

local foldBtn = textColorBtn:Clone()
foldBtn.Parent = customPage
foldBtn.Position = UDim2.fromScale(0.05,0.29)
foldBtn.Text = "Line Text"
foldBtn.MouseButton1Click:Connect(function()
	Settings.Folding = not Settings.Folding
	foldBtn.Text = Settings.Folding and "Folding Text" or "Line Text"
end)

local pixelBtn = textColorBtn:Clone()
pixelBtn.Parent = customPage
pixelBtn.Position = UDim2.fromScale(0.05,0.41)
pixelBtn.Text = "Pixel Font: OFF"
pixelBtn.MouseButton1Click:Connect(function()
	Settings.Pixel = not Settings.Pixel
	pixelBtn.Text = "Pixel Font: "..(Settings.Pixel and "ON" or "OFF")
end)

--------------------------------------------------
-- PERFORMANCE TAB
--------------------------------------------------

local perfPage = Pages["Performance"]

local fpsLabel = Instance.new("TextLabel",gui)
fpsLabel.Size = UDim2.fromOffset(150,30)
fpsLabel.Position = UDim2.new(1,-160,0,10)
fpsLabel.BackgroundColor3 = PurpleDark
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextScaled = true
fpsLabel.ZIndex = 30
Instance.new("UICorner",fpsLabel)

local frames = 0
local last = tick()

RunService.RenderStepped:Connect(function()
	frames += 1
	if tick()-last >= 1 then
		local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		fpsLabel.Text = "FPS: "..frames.." | "..ping.."ms"
		frames = 0
		last = tick()
	end
end)

local fpsToggle = Instance.new("TextButton",perfPage)
fpsToggle.Size = UDim2.fromScale(0.9,0.08)
fpsToggle.Position = UDim2.fromScale(0.05,0.05)
fpsToggle.Text = "FPS In Menu"
fpsToggle.Font = Enum.Font.GothamBold
fpsToggle.TextScaled = true
fpsToggle.BackgroundColor3 = PurpleDark
fpsToggle.TextColor3 = Color3.new(1,1,1)
fpsToggle.ZIndex = 5
Instance.new("UICorner",fpsToggle)

fpsToggle.MouseButton1Click:Connect(function()
	Settings.FPSCorner = not Settings.FPSCorner
	fpsLabel.Visible = Settings.FPSCorner
end)

--------------------------------------------------
-- IMAGES TAB
--------------------------------------------------

local imagePage = Pages["Images"]

local imgInput = Instance.new("TextBox",imagePage)
imgInput.Size = UDim2.fromScale(0.9,0.12)
imgInput.Position = UDim2.fromScale(0.05,0.05)
imgInput.PlaceholderText = "Enter Roblox Image ID"
imgInput.TextScaled = true
imgInput.Font = Enum.Font.GothamBold
imgInput.BackgroundColor3 = Color3.fromRGB(40,40,60)
imgInput.ZIndex = 5
Instance.new("UICorner",imgInput)

local imgBtn = Instance.new("TextButton",imagePage)
imgBtn.Size = UDim2.fromScale(0.9,0.08)
imgBtn.Position = UDim2.fromScale(0.05,0.2)
imgBtn.Text = "Generate Image"
imgBtn.Font = Enum.Font.GothamBold
imgBtn.TextScaled = true
imgBtn.BackgroundColor3 = PurpleDark
imgBtn.TextColor3 = Color3.new(1,1,1)
imgBtn.ZIndex = 5
Instance.new("UICorner",imgBtn)

imgBtn.MouseButton1Click:Connect(function()
	if imgInput.Text == "" then return end

	local frame = Instance.new("Frame",gui)
	frame.Size = UDim2.fromOffset(200,200)
	frame.Position = UDim2.fromScale(0.4,0.4)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
	frame.Active = true
	frame.Draggable = true
	frame.ZIndex = 20
	Instance.new("UICorner",frame)

	local img = Instance.new("ImageLabel",frame)
	img.Size = UDim2.new(1,-10,1,-10)
	img.Position = UDim2.new(0,5,0,5)
	img.Image = "rbxassetid://"..imgInput.Text
	img.BackgroundTransparency = 1
	img.ZIndex = 21

	local del = Instance.new("TextButton",frame)
	del.Size = UDim2.fromOffset(20,20)
	del.Position = UDim2.new(1,-22,0,2)
	del.Text = "X"
	del.BackgroundColor3 = Color3.fromRGB(200,50,50)
	del.TextColor3 = Color3.new(1,1,1)
	del.ZIndex = 21
	Instance.new("UICorner",del)

	del.MouseButton1Click:Connect(function()
		frame:Destroy()
	end)
end)
