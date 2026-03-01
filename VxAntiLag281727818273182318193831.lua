--// Vx-AntiLag Final Stable Edition by Adrien

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

if player:FindFirstChild("VxAntiLagLoaded") then return end
Instance.new("BoolValue", player).Name = "VxAntiLagLoaded"

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "VxAntiLag"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--------------------------------------------------
-- TOP RIGHT PERFORMANCE
--------------------------------------------------

local perfFrame = Instance.new("Frame", gui)
perfFrame.Size = UDim2.new(0,160,0,70)
perfFrame.Position = UDim2.new(1,-170,0,15)
perfFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
perfFrame.BackgroundTransparency = 0.2
Instance.new("UICorner", perfFrame)

local fpsLabel = Instance.new("TextLabel", perfFrame)
fpsLabel.Size = UDim2.new(1,0,0.5,0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 15
fpsLabel.Text = "FPS: --"

local pingLabel = Instance.new("TextLabel", perfFrame)
pingLabel.Size = UDim2.new(1,0,0.5,0)
pingLabel.Position = UDim2.new(0,0,0.5,0)
pingLabel.BackgroundTransparency = 1
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 15
pingLabel.Text = "Ping: --"

--------------------------------------------------
-- MAIN MENU
--------------------------------------------------

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,250,0,140)
frame.Position = UDim2.new(0.5,-125,0.5,-70)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-30,0,0)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255,80,80)
close.BackgroundTransparency = 1

local reopen = Instance.new("TextButton", gui)
reopen.Size = UDim2.new(0,110,0,35)
reopen.Position = UDim2.new(0,10,1,-45)
reopen.Text = "Open Vx"
reopen.Visible = false
reopen.BackgroundColor3 = Color3.fromRGB(20,20,20)
reopen.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", reopen)

close.MouseButton1Click:Connect(function()
	frame.Visible = false
	reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
	frame.Visible = true
	reopen.Visible = false
end)

local antiLag = Instance.new("TextButton", frame)
antiLag.Size = UDim2.new(0.85,0,0,40)
antiLag.Position = UDim2.new(0.075,0,0.35,0)
antiLag.Text = "Enable Anti Lag"
antiLag.BackgroundColor3 = Color3.fromRGB(35,35,35)
antiLag.TextColor3 = Color3.new(1,1,1)
antiLag.Font = Enum.Font.GothamBold
antiLag.TextSize = 14
Instance.new("UICorner", antiLag)

--------------------------------------------------
-- SAFE OPTIMIZATION
--------------------------------------------------

local enabled = false

local function optimizePart(part)
	if not part:IsA("BasePart") then return end
	if part:IsDescendantOf(player.Character) then return end
	
	-- Skip already transparent
	if part.Transparency > 0 then return end
	
	-- Skip neon & glass
	if part.Material == Enum.Material.Neon then return end
	if part.Material == Enum.Material.Glass then return end
	
	part.Transparency = 0.48
	part.CastShadow = false
end

local function applyOptimization()

	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

	-- Disable heavy lighting effects
	for _,v in pairs(Lighting:GetChildren()) do
		if v:IsA("BloomEffect")
		or v:IsA("SunRaysEffect")
		or v:IsA("DepthOfFieldEffect")
		or v:IsA("BlurEffect") then
			v.Enabled = false
		end
	end

	-- Soft dark mode (NOT too dark)
	local darkEffect = Instance.new("ColorCorrectionEffect")
	darkEffect.Brightness = -0.1
	darkEffect.Contrast = -0.05
	darkEffect.Saturation = -0.05
	darkEffect.Parent = Lighting

	Lighting.ExposureCompensation = -0.2

	-- Remove particles & decals
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Enabled = false
		elseif v:IsA("Decal") or v:IsA("Texture") then
			v:Destroy()
		end

		optimizePart(v)
	end

	-- Auto apply to new spawns
	workspace.DescendantAdded:Connect(function(obj)
		if not enabled then return end
		
		if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
			obj.Enabled = false
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj:Destroy()
		end
		
		optimizePart(obj)
	end)
end

antiLag.MouseButton1Click:Connect(function()
	if enabled then return end
	enabled = true
	antiLag.Text = "Enabled ✓"
	antiLag.BackgroundColor3 = Color3.fromRGB(0,130,0)
	applyOptimization()
end)

--------------------------------------------------
-- TRUE 1 SECOND FPS COUNTER
--------------------------------------------------

local frameCounter = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
	frameCounter += 1
	
	local now = tick()
	if now - lastTime >= 1 then
		
		local fps = frameCounter
		frameCounter = 0
		lastTime = now
		
		local ping = 0
		pcall(function()
			ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		end)
		
		fpsLabel.Text = "FPS: "..fps
		pingLabel.Text = "Ping: "..ping.." ms"
		
		-- FPS color
		if fps >= 50 then
			fpsLabel.TextColor3 = Color3.fromRGB(0,255,0)
		elseif fps >= 30 then
			fpsLabel.TextColor3 = Color3.fromRGB(255,170,0)
		else
			fpsLabel.TextColor3 = Color3.fromRGB(255,0,0)
		end
		
		-- Ping color
		if ping <= 100 then
			pingLabel.TextColor3 = Color3.fromRGB(0,170,255)
		elseif ping <= 200 then
			pingLabel.TextColor3 = Color3.fromRGB(255,170,0)
		else
			pingLabel.TextColor3 = Color3.fromRGB(255,0,0)
		end
	end
end)
