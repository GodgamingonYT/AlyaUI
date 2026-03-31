local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local pgui = pcall(function() return CoreGui end) and CoreGui or player:WaitForChild("PlayerGui")

local AlyaUI = {}

-- Color Palette
local COLORS = {
	Background = Color3.fromRGB(12, 10, 25),
	Sidebar = Color3.fromRGB(18, 16, 35),
	TabIdle = Color3.fromRGB(25, 23, 45),
	TabHover = Color3.fromRGB(40, 36, 70),
	TabActive = Color3.fromRGB(85, 75, 255),
	RowBg = Color3.fromRGB(20, 18, 40),
	TextMain = Color3.fromRGB(240, 240, 255),
	TextMuted = Color3.fromRGB(150, 150, 180),
	ToggleOff = Color3.fromRGB(50, 45, 70),
	ToggleOn = Color3.fromRGB(85, 255, 130),
	Accent = Color3.fromRGB(85, 75, 255),
	CloseBtn = Color3.fromRGB(255, 60, 60),
	ElementBg = Color3.fromRGB(15, 13, 30)
}

local function tween(obj, properties, duration)
	duration = duration or 0.2
	local t = TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
	t:Play()
	return t
end

function AlyaUI:CreateWindow(config)
	config = config or {}
	local titleTextString = config.Title or "AlyaUI"
	local versionTextString = config.Version or ""
	
	local Window = { Pages = {}, TabButtons = {}, FirstTab = nil, IsMinimized = false, CurrentSize = UDim2.new(0, 680, 0, 420) }
	
	if pgui:FindFirstChild("AlyaUI_Library") then pgui.AlyaUI_Library:Destroy() end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AlyaUI_Library"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = pgui

	-- NOTIFICATION CONTAINER
	local notifContainer = Instance.new("Frame", screenGui)
	notifContainer.Size = UDim2.new(0, 300, 1, -40)
	notifContainer.Position = UDim2.new(1, -320, 0, 20)
	notifContainer.BackgroundTransparency = 1
	
	local notifLayout = Instance.new("UIListLayout", notifContainer)
	notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	notifLayout.Padding = UDim.new(0, 10)

	function Window:Notify(options)
		local title = options.Title or "Notification"
		local content = options.Content or ""
		local duration = options.Duration or 3

		local notif = Instance.new("Frame")
		notif.Size = UDim2.new(0, 300, 0, 80)
		notif.BackgroundColor3 = COLORS.Background
		notif.BackgroundTransparency = 0.1
		notif.ClipsDescendants = true
		Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
		
		local stroke = Instance.new("UIStroke", notif)
		stroke.Color = COLORS.Accent
		stroke.Thickness = 1.5
		stroke.Transparency = 0.5

		local titleLbl = Instance.new("TextLabel", notif)
		titleLbl.Size = UDim2.new(1, -30, 0, 25)
		titleLbl.Position = UDim2.new(0, 15, 0, 10)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = title
		titleLbl.TextColor3 = COLORS.TextMain
		titleLbl.Font = Enum.Font.GothamBold
		titleLbl.TextSize = 14
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left

		local contentLbl = Instance.new("TextLabel", notif)
		contentLbl.Size = UDim2.new(1, -30, 0, 35)
		contentLbl.Position = UDim2.new(0, 15, 0, 35)
		contentLbl.BackgroundTransparency = 1
		contentLbl.Text = content
		contentLbl.TextColor3 = COLORS.TextMuted
		contentLbl.Font = Enum.Font.Gotham
		contentLbl.TextSize = 12
		contentLbl.TextWrapped = true
		contentLbl.TextXAlignment = Enum.TextXAlignment.Left
		contentLbl.TextYAlignment = Enum.TextYAlignment.Top

		local barBg = Instance.new("Frame", notif)
		barBg.Size = UDim2.new(1, 0, 0, 3)
		barBg.Position = UDim2.new(0, 0, 1, -3)
		barBg.BackgroundColor3 = COLORS.ElementBg
		barBg.BorderSizePixel = 0

		local barFill = Instance.new("Frame", barBg)
		barFill.Size = UDim2.new(1, 0, 1, 0)
		barFill.BackgroundColor3 = COLORS.Accent
		barFill.BorderSizePixel = 0

		notif.Parent = notifContainer
		notif.Position = UDim2.new(1, 350, 0, 0)
		tween(notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.4)
		tween(barFill, {Size = UDim2.new(0, 0, 1, 0)}, duration)

		task.delay(duration, function()
			tween(notif, {Position = UDim2.new(1, 350, 0, 0), BackgroundTransparency = 1}, 0.4)
			task.wait(0.4)
			notif:Destroy()
		end)
	end

	-- MAIN FRAME
	local mainFrame = Instance.new("CanvasGroup", screenGui)
	mainFrame.Size = UDim2.new(0, 640, 0, 400) 
	mainFrame.Position = UDim2.new(0.5, -320, 0.5, -190)
	mainFrame.BackgroundColor3 = COLORS.Background
	mainFrame.BackgroundTransparency = 0.25 
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.ClipsDescendants = true
	mainFrame.GroupTransparency = 1 
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
	local mainStroke = Instance.new("UIStroke", mainFrame)
	mainStroke.Thickness = 1.5
	mainStroke.Color = COLORS.Accent
	mainStroke.Transparency = 0.4 

	-- TITLE BAR
	local titleBar = Instance.new("Frame", mainFrame)
	titleBar.Size = UDim2.new(1, 0, 0, 40)
	titleBar.BackgroundTransparency = 1
	local titleLabel = Instance.new("TextLabel", titleBar)
	titleLabel.Size = UDim2.new(1, -100, 1, 0)
	titleLabel.Position = UDim2.new(0, 20, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = titleTextString .. "  <font color='#554BFF'>" .. versionTextString .. "</font>"
	titleLabel.RichText = true
	titleLabel.TextColor3 = COLORS.TextMain
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left

	local divider = Instance.new("Frame", titleBar)
	divider.Size = UDim2.new(1, 0, 0, 1)
	divider.Position = UDim2.new(0, 0, 1, 0)
	divider.BackgroundColor3 = COLORS.Accent
	divider.BackgroundTransparency = 0.5
	divider.BorderSizePixel = 0

	-- WINDOW CONTROLS
	local controlContainer = Instance.new("Frame", titleBar)
	controlContainer.Size = UDim2.new(0, 80, 1, 0)
	controlContainer.Position = UDim2.new(1, -80, 0, 0)
	controlContainer.BackgroundTransparency = 1
	local controlLayout = Instance.new("UIListLayout", controlContainer)
	controlLayout.FillDirection = Enum.FillDirection.Horizontal
	controlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	controlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	controlLayout.Padding = UDim.new(0, 5)
	local controlPadding = Instance.new("UIPadding", controlContainer)
	controlPadding.PaddingRight = UDim.new(0, 15)

	local minBtn = Instance.new("TextButton", controlContainer)
	minBtn.Size = UDim2.new(0, 24, 0, 24)
	minBtn.BackgroundTransparency = 1
	minBtn.Text = "-"
	minBtn.TextColor3 = COLORS.TextMain
	minBtn.TextSize = 18
	minBtn.Font = Enum.Font.GothamBold

	local closeBtn = Instance.new("TextButton", controlContainer)
	closeBtn.Size = UDim2.new(0, 24, 0, 24)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "X"
	closeBtn.TextColor3 = COLORS.TextMain
	closeBtn.TextSize = 14
	closeBtn.Font = Enum.Font.GothamBold

	closeBtn.MouseEnter:Connect(function() tween(closeBtn, {TextColor3 = COLORS.CloseBtn}, 0.1) end)
	closeBtn.MouseLeave:Connect(function() tween(closeBtn, {TextColor3 = COLORS.TextMain}, 0.1) end)
	minBtn.MouseEnter:Connect(function() tween(minBtn, {TextColor3 = COLORS.Accent}, 0.1) end)
	minBtn.MouseLeave:Connect(function() tween(minBtn, {TextColor3 = COLORS.TextMain}, 0.1) end)

	closeBtn.MouseButton1Click:Connect(function()
		tween(mainFrame, {Size = UDim2.new(0, mainFrame.Size.X.Offset - 40, 0, mainFrame.Size.Y.Offset - 40), GroupTransparency = 1}, 0.3)
		task.wait(0.3)
		screenGui:Destroy()
	end)

	minBtn.MouseButton1Click:Connect(function()
		Window.IsMinimized = not Window.IsMinimized
		if Window.IsMinimized then
			Window.CurrentSize = mainFrame.Size
			tween(mainFrame, {Size = UDim2.new(0, Window.CurrentSize.X.Offset, 0, 40)}, 0.3)
		else
			tween(mainFrame, {Size = Window.CurrentSize}, 0.3)
		end
	end)

	-- DRAGGING
	local dragging, dragInput, dragStart, startPos
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = mainFrame.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	titleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	
	-- RESIZE GRIP
	local resizeHandle = Instance.new("TextButton", mainFrame)
	resizeHandle.Size = UDim2.new(0, 25, 0, 25)
	resizeHandle.Position = UDim2.new(1, -20, 1, -20)
	resizeHandle.BackgroundTransparency = 1
	resizeHandle.Text = ")"
	resizeHandle.Font = Enum.Font.GothamBold
	resizeHandle.TextSize = 22
	resizeHandle.TextColor3 = COLORS.TextMuted
	resizeHandle.TextTransparency = 0.5
	resizeHandle.Rotation = 45 
	resizeHandle.ZIndex = 10

	resizeHandle.MouseEnter:Connect(function() tween(resizeHandle, {TextTransparency = 0}, 0.2) end)
	resizeHandle.MouseLeave:Connect(function() tween(resizeHandle, {TextTransparency = 0.5}, 0.2) end)

	local resizing, resizeStart, startSize
	resizeHandle.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not Window.IsMinimized then
			resizing = true; resizeStart = input.Position; startSize = mainFrame.Size
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then resizing = false end end)
		end
	end)
	resizeHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			tween(mainFrame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.08)
		end
		if input == dragInput and resizing then
			local delta = input.Position - resizeStart
			local newX = math.clamp(startSize.X.Offset + delta.X, 450, 1200)
			local newY = math.clamp(startSize.Y.Offset + delta.Y, 250, 800)
			Window.CurrentSize = UDim2.new(0, newX, 0, newY)
			tween(mainFrame, {Size = Window.CurrentSize}, 0.08)
		end
	end)

	-- LAYOUT CONTAINERS
	local sidebar = Instance.new("Frame", mainFrame)
	sidebar.Size = UDim2.new(0, 160, 1, -41)
	sidebar.Position = UDim2.new(0, 0, 0, 41)
	sidebar.BackgroundColor3 = COLORS.Sidebar
	sidebar.BackgroundTransparency = 0.4
	sidebar.BorderSizePixel = 0
	local sideLayout = Instance.new("UIListLayout", sidebar)
	sideLayout.Padding = UDim.new(0, 5)
	local sidePadding = Instance.new("UIPadding", sidebar)
	sidePadding.PaddingTop = UDim.new(0, 10); sidePadding.PaddingLeft = UDim.new(0, 10); sidePadding.PaddingRight = UDim.new(0, 10)

	local contentContainer = Instance.new("Frame", mainFrame)
	contentContainer.Size = UDim2.new(1, -160, 1, -41)
	contentContainer.Position = UDim2.new(0, 160, 0, 41)
	contentContainer.BackgroundTransparency = 1

	function Window:SelectTab(name)
		for pageName, frame in pairs(self.Pages) do
			if pageName == name then
				frame.Visible = true; frame.Position = UDim2.new(0, 20, 0, 0); frame.GroupTransparency = 1
				tween(frame, {Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0}, 0.3)
			else frame.Visible = false end
		end
		for btnName, btn in pairs(self.TabButtons) do
			if btnName == name then
				tween(btn, {BackgroundColor3 = COLORS.TabActive, BackgroundTransparency = 0})
				tween(btn.TextLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)})
			else
				tween(btn, {BackgroundColor3 = COLORS.TabIdle, BackgroundTransparency = 0.5})
				tween(btn.TextLabel, {TextColor3 = COLORS.TextMuted})
			end
		end
	end

	-- [[ DYNAMIC ELEMENT BUILDER ]] --
	local function BuildElements(targetParent)
		local Elements = {}

		function Elements:AddDivider()
			local row = Instance.new("Frame", targetParent)
			row.Size = UDim2.new(1, 0, 0, 10)
			row.BackgroundTransparency = 1
			local line = Instance.new("Frame", row)
			line.Size = UDim2.new(1, -20, 0, 1)
			line.Position = UDim2.new(0, 10, 0.5, 0)
			line.BackgroundColor3 = COLORS.TextMuted
			line.BackgroundTransparency = 0.8
			line.BorderSizePixel = 0
		end

		function Elements:AddLabel(options)
			local text = type(options) == "string" and options or options.Name or "Label"
			local lbl = Instance.new("TextLabel", targetParent)
			lbl.Size = UDim2.new(1, 0, 0, 25)
			lbl.BackgroundTransparency = 1
			lbl.Text = "  " .. text
			lbl.TextColor3 = COLORS.TextMuted
			lbl.Font = Enum.Font.GothamMedium
			lbl.TextSize = 13
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			return lbl
		end

		function Elements:AddButton(options)
			local callback = options.Callback or function() end
			local row = Instance.new("Frame", targetParent)
			row.Size = UDim2.new(1, 0, 0, 45)
			row.BackgroundColor3 = COLORS.RowBg
			row.BackgroundTransparency = 0.4
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

			local title = Instance.new("TextLabel", row)
			title.Size = UDim2.new(0.6, 0, 1, 0)
			title.Position = UDim2.new(0, 15, 0, 0)
			title.BackgroundTransparency = 1
			title.Text = options.Name or "Button"
			title.TextColor3 = COLORS.TextMain
			title.Font = Enum.Font.GothamMedium
			title.TextSize = 13
			title.TextXAlignment = Enum.TextXAlignment.Left
			
			local customText = options.Text or "EXECUTE"
			local textLength = string.len(customText)
			local btnWidth = math.clamp(textLength * 9 + 20, 90, 200)

			local btnExe = Instance.new("TextButton", row)
			btnExe.Size = UDim2.new(0, btnWidth, 0, 26)
			btnExe.Position = UDim2.new(1, -(btnWidth + 15), 0.5, -13)
			btnExe.BackgroundColor3 = COLORS.Accent
			btnExe.Text = customText
			btnExe.Font = Enum.Font.GothamBold
			btnExe.TextColor3 = Color3.fromRGB(255, 255, 255)
			btnExe.TextSize = 11
			btnExe.AutoButtonColor = false
			Instance.new("UICorner", btnExe).CornerRadius = UDim.new(0, 6)
			
			btnExe.MouseButton1Down:Connect(function() tween(btnExe, {Size = UDim2.new(0, btnWidth - 4, 0, 24), Position = UDim2.new(1, -(btnWidth + 13), 0.5, -12)}, 0.1) end)
			btnExe.MouseButton1Up:Connect(function() tween(btnExe, {Size = UDim2.new(0, btnWidth, 0, 26), Position = UDim2.new(1, -(btnWidth + 15), 0.5, -13)}, 0.1) end)
			btnExe.MouseButton1Click:Connect(callback)
		end

		function Elements:AddToggle(options)
			local state = options.Default or false
			local callback = options.Callback or function() end
			local row = Instance.new("Frame", targetParent)
			row.Size = UDim2.new(1, 0, 0, 45)
			row.BackgroundColor3 = COLORS.RowBg
			row.BackgroundTransparency = 0.4
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

			local title = Instance.new("TextLabel", row)
			title.Size = UDim2.new(0.7, 0, 1, 0)
			title.Position = UDim2.new(0, 15, 0, 0)
			title.BackgroundTransparency = 1
			title.Text = options.Name or "Toggle"
			title.TextColor3 = COLORS.TextMain
			title.Font = Enum.Font.GothamMedium
			title.TextSize = 13
			title.TextXAlignment = Enum.TextXAlignment.Left
			
			local toggleBg = Instance.new("TextButton", row)
			toggleBg.Size = UDim2.new(0, 44, 0, 22)
			toggleBg.Position = UDim2.new(1, -59, 0.5, -11)
			toggleBg.BackgroundColor3 = state and COLORS.ToggleOn or COLORS.ToggleOff
			toggleBg.Text = ""
			toggleBg.AutoButtonColor = false
			Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
			
			local indicator = Instance.new("Frame", toggleBg)
			indicator.Size = UDim2.new(0, 16, 0, 16)
			indicator.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
			indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
			
			toggleBg.MouseButton1Click:Connect(function()
				state = not state
				if state then tween(toggleBg, {BackgroundColor3 = COLORS.ToggleOn}); tween(indicator, {Position = UDim2.new(1, -19, 0.5, -8)})
				else tween(toggleBg, {BackgroundColor3 = COLORS.ToggleOff}); tween(indicator, {Position = UDim2.new(0, 3, 0.5, -8)}) end
				callback(state)
			end)
		end

		function Elements:AddSlider(options)
			local min = options.Min or 0
			local max = options.Max or 100
			local default = options.Default or min
			local callback = options.Callback or function() end
			
			local row = Instance.new("Frame", targetParent)
			row.Size = UDim2.new(1, 0, 0, 60)
			row.BackgroundColor3 = COLORS.RowBg
			row.BackgroundTransparency = 0.4
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

			local title = Instance.new("TextLabel", row)
			title.Size = UDim2.new(1, -30, 0, 30)
			title.Position = UDim2.new(0, 15, 0, 0)
			title.BackgroundTransparency = 1
			title.Text = options.Name or "Slider"
			title.TextColor3 = COLORS.TextMain
			title.Font = Enum.Font.GothamMedium
			title.TextSize = 13
			title.TextXAlignment = Enum.TextXAlignment.Left

			local valLabel = Instance.new("TextLabel", row)
			valLabel.Size = UDim2.new(0, 50, 0, 30)
			valLabel.Position = UDim2.new(1, -65, 0, 0)
			valLabel.BackgroundTransparency = 1
			valLabel.Text = tostring(default)
			valLabel.TextColor3 = COLORS.TextMuted
			valLabel.Font = Enum.Font.Gotham
			valLabel.TextSize = 12
			valLabel.TextXAlignment = Enum.TextXAlignment.Right

			local sliderBg = Instance.new("TextButton", row)
			sliderBg.Size = UDim2.new(1, -30, 0, 6)
			sliderBg.Position = UDim2.new(0, 15, 0, 40)
			sliderBg.BackgroundColor3 = COLORS.ElementBg
			sliderBg.Text = ""
			sliderBg.AutoButtonColor = false
			Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

			local fill = Instance.new("Frame", sliderBg)
			fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			fill.BackgroundColor3 = COLORS.Accent
			Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

			local dragging = false
			local function updateSlider(input)
				local percentage = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
				local value = math.floor(min + (max - min) * percentage)
				tween(fill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
				valLabel.Text = tostring(value)
				callback(value)
			end

			sliderBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; updateSlider(input) end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
			end)
		end

		function Elements:AddInput(options)
			local callback = options.Callback or function() end
			local row = Instance.new("Frame", targetParent)
			row.Size = UDim2.new(1, 0, 0, 45)
			row.BackgroundColor3 = COLORS.RowBg
			row.BackgroundTransparency = 0.4
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

			local title = Instance.new("TextLabel", row)
			title.Size = UDim2.new(0.5, 0, 1, 0)
			title.Position = UDim2.new(0, 15, 0, 0)
			title.BackgroundTransparency = 1
			title.Text = options.Name or "Input"
			title.TextColor3 = COLORS.TextMain
			title.Font = Enum.Font.GothamMedium
			title.TextSize = 13
			title.TextXAlignment = Enum.TextXAlignment.Left
			
			local box = Instance.new("TextBox", row)
			box.Size = UDim2.new(0, 140, 0, 26)
			box.Position = UDim2.new(1, -155, 0.5, -13)
			box.BackgroundColor3 = COLORS.ElementBg
			box.Text = ""
			box.PlaceholderText = options.Placeholder or "Type here..."
			box.Font = Enum.Font.Gotham
			box.TextColor3 = COLORS.TextMain
			box.PlaceholderColor3 = COLORS.TextMuted
			box.TextSize = 12
			box.ClearTextOnFocus = false
			Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

			box.FocusLost:Connect(function() callback(box.Text) end)
		end

		function Elements:AddKeybind(options)
			local key = options.Default or Enum.KeyCode.E
			local callback = options.Callback or function() end
			
			local row = Instance.new("Frame", targetParent)
			row.Size = UDim2.new(1, 0, 0, 45)
			row.BackgroundColor3 = COLORS.RowBg
			row.BackgroundTransparency = 0.4
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

			local title = Instance.new("TextLabel", row)
			title.Size = UDim2.new(0.5, 0, 1, 0)
			title.Position = UDim2.new(0, 15, 0, 0)
			title.BackgroundTransparency = 1
			title.Text = options.Name or "Keybind"
			title.TextColor3 = COLORS.TextMain
			title.Font = Enum.Font.GothamMedium
			title.TextSize = 13
			title.TextXAlignment = Enum.TextXAlignment.Left
			
			local keyBtn = Instance.new("TextButton", row)
			keyBtn.Size = UDim2.new(0, 80, 0, 26)
			keyBtn.Position = UDim2.new(1, -95, 0.5, -13)
			keyBtn.BackgroundColor3 = COLORS.ElementBg
			keyBtn.Text = key.Name
			keyBtn.Font = Enum.Font.GothamBold
			keyBtn.TextColor3 = COLORS.Accent
			keyBtn.TextSize = 12
			keyBtn.AutoButtonColor = false
			Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)
			
			local binding = false
			keyBtn.MouseButton1Click:Connect(function()
				binding = true
				keyBtn.Text = "..."
				tween(keyBtn, {BackgroundColor3 = COLORS.TabHover}, 0.1)
			end)
			
			UserInputService.InputBegan:Connect(function(input)
				if binding and input.UserInputType == Enum.UserInputType.Keyboard then
					key = input.KeyCode
					keyBtn.Text = key.Name
					binding = false
					tween(keyBtn, {BackgroundColor3 = COLORS.ElementBg}, 0.1)
					callback(key)
				elseif not binding and input.KeyCode == key and not UserInputService:GetFocusedTextBox() then
					callback(key)
				end
			end)
		end

		function Elements:AddColorpicker(options)
			local defaultColor = options.Default or Color3.fromRGB(255, 255, 255)
			local callback = options.Callback or function() end
			
			local row = Instance.new("Frame", targetParent)
			row.Size = UDim2.new(1, 0, 0, 45)
			row.BackgroundColor3 = COLORS.RowBg
			row.BackgroundTransparency = 0.4
			row.ClipsDescendants = true
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

			local title = Instance.new("TextLabel", row)
			title.Size = UDim2.new(0.5, 0, 0, 45)
			title.Position = UDim2.new(0, 15, 0, 0)
			title.BackgroundTransparency = 1
			title.Text = options.Name or "Colorpicker"
			title.TextColor3 = COLORS.TextMain
			title.Font = Enum.Font.GothamMedium
			title.TextSize = 13
			title.TextXAlignment = Enum.TextXAlignment.Left
			
			local colorDisplay = Instance.new("TextButton", row)
			colorDisplay.Size = UDim2.new(0, 40, 0, 26)
			colorDisplay.Position = UDim2.new(1, -55, 0, 9)
			colorDisplay.BackgroundColor3 = defaultColor
			colorDisplay.Text = ""
			Instance.new("UICorner", colorDisplay).CornerRadius = UDim.new(0, 6)
			
			local rgbContainer = Instance.new("Frame", row)
			rgbContainer.Size = UDim2.new(1, -30, 0, 30)
			rgbContainer.Position = UDim2.new(0, 15, 0, 50)
			rgbContainer.BackgroundTransparency = 1
			
			local rBox = Instance.new("TextBox", rgbContainer)
			rBox.Size = UDim2.new(0.3, -5, 1, 0)
			rBox.Position = UDim2.new(0, 0, 0, 0)
			rBox.BackgroundColor3 = COLORS.ElementBg
			rBox.Text = tostring(math.floor(defaultColor.R * 255))
			rBox.TextColor3 = Color3.fromRGB(255, 100, 100)
			rBox.Font = Enum.Font.GothamBold
			Instance.new("UICorner", rBox).CornerRadius = UDim.new(0, 4)
			
			local gBox = Instance.new("TextBox", rgbContainer)
			gBox.Size = UDim2.new(0.3, -5, 1, 0)
			gBox.Position = UDim2.new(0.33, 0, 0, 0)
			gBox.BackgroundColor3 = COLORS.ElementBg
			gBox.Text = tostring(math.floor(defaultColor.G * 255))
			gBox.TextColor3 = Color3.fromRGB(100, 255, 100)
			gBox.Font = Enum.Font.GothamBold
			Instance.new("UICorner", gBox).CornerRadius = UDim.new(0, 4)
			
			local bBox = Instance.new("TextBox", rgbContainer)
			bBox.Size = UDim2.new(0.3, -5, 1, 0)
			bBox.Position = UDim2.new(0.66, 0, 0, 0)
			bBox.BackgroundColor3 = COLORS.ElementBg
			bBox.Text = tostring(math.floor(defaultColor.B * 255))
			bBox.TextColor3 = Color3.fromRGB(100, 100, 255)
			bBox.Font = Enum.Font.GothamBold
			Instance.new("UICorner", bBox).CornerRadius = UDim.new(0, 4)
			
			local isOpen = false
			colorDisplay.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				tween(row, {Size = UDim2.new(1, 0, 0, isOpen and 90 or 45)}, 0.2)
			end)
			
			local function updateColor()
				local r = tonumber(rBox.Text) or 255
				local g = tonumber(gBox.Text) or 255
				local b = tonumber(bBox.Text) or 255
				r, g, b = math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255)
				local newColor = Color3.fromRGB(r, g, b)
				tween(colorDisplay, {BackgroundColor3 = newColor}, 0.2)
				callback(newColor)
			end
			
			rBox.FocusLost:Connect(updateColor)
			gBox.FocusLost:Connect(updateColor)
			bBox.FocusLost:Connect(updateColor)
		end

		function Elements:AddSection(options)
			local secBg = Instance.new("Frame", targetParent)
			secBg.Size = UDim2.new(1, 0, 0, 40)
			secBg.BackgroundColor3 = COLORS.RowBg
			secBg.BackgroundTransparency = 0.7
			secBg.ClipsDescendants = true
			Instance.new("UICorner", secBg).CornerRadius = UDim.new(0, 8)
			
			local header = Instance.new("TextButton", secBg)
			header.Size = UDim2.new(1, 0, 0, 40)
			header.BackgroundTransparency = 1
			header.Text = "  " .. (options.Name or "Section")
			header.Font = Enum.Font.GothamBold
			header.TextColor3 = COLORS.Accent
			header.TextSize = 13
			header.TextXAlignment = Enum.TextXAlignment.Left
			
			local content = Instance.new("Frame", secBg)
			content.Size = UDim2.new(1, 0, 1, -40)
			content.Position = UDim2.new(0, 0, 0, 40)
			content.BackgroundTransparency = 1
			
			local layout = Instance.new("UIListLayout", content)
			layout.Padding = UDim.new(0, 6)
			local pad = Instance.new("UIPadding", content)
			pad.PaddingTop = UDim.new(0, 5); pad.PaddingBottom = UDim.new(0, 5); pad.PaddingLeft = UDim.new(0, 10); pad.PaddingRight = UDim.new(0, 10)
			
			local isOpen = options.Default == nil and true or options.Default
			
			local function updateSize()
				if isOpen then tween(secBg, {Size = UDim2.new(1, 0, 0, 40 + layout.AbsoluteContentSize.Y + 10)}, 0.2)
				else tween(secBg, {Size = UDim2.new(1, 0, 0, 40)}, 0.2) end
			end
			
			header.MouseButton1Click:Connect(function() isOpen = not isOpen; updateSize() end)
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() if isOpen then secBg.Size = UDim2.new(1, 0, 0, 40 + layout.AbsoluteContentSize.Y + 10) end end)
			
			-- Wait a frame to process sizes properly
			task.delay(0.05, function() updateSize() end)
			
			-- Returns a localized build element function so everything adds INSIDE the section!
			return BuildElements(content)
		end

		return Elements
	end

	function Window:CreateTab(name)
		local btn = Instance.new("TextButton", sidebar)
		btn.Size = UDim2.new(1, 0, 0, 36)
		btn.BackgroundColor3 = COLORS.TabIdle
		btn.BackgroundTransparency = 0.5
		btn.Text = ""
		btn.AutoButtonColor = false
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
		
		local label = Instance.new("TextLabel", btn)
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = name
		label.Font = Enum.Font.GothamMedium
		label.TextColor3 = COLORS.TextMuted
		label.TextSize = 13
		
		local pageGroup = Instance.new("CanvasGroup", contentContainer)
		pageGroup.Size = UDim2.new(1, 0, 1, 0)
		pageGroup.BackgroundTransparency = 1
		pageGroup.Visible = false
		
		local scroll = Instance.new("ScrollingFrame", pageGroup)
		scroll.Size = UDim2.new(1, 0, 1, 0)
		scroll.BackgroundTransparency = 1
		scroll.ScrollBarThickness = 2
		scroll.ScrollBarImageColor3 = COLORS.Accent
		scroll.BorderSizePixel = 0
		
		local layout = Instance.new("UIListLayout", scroll)
		layout.Padding = UDim.new(0, 8)
		local padding = Instance.new("UIPadding", scroll)
		padding.PaddingTop = UDim.new(0, 15); padding.PaddingLeft = UDim.new(0, 15); padding.PaddingRight = UDim.new(0, 20); padding.PaddingBottom = UDim.new(0, 15)
		
		self.Pages[name] = pageGroup
		self.TabButtons[name] = btn
		if not self.FirstTab then self.FirstTab = name end
		
		btn.MouseEnter:Connect(function() if btn.BackgroundColor3 ~= COLORS.TabActive then tween(btn, {BackgroundColor3 = COLORS.TabHover, BackgroundTransparency = 0.2}) end end)
		btn.MouseLeave:Connect(function() if btn.BackgroundColor3 ~= COLORS.TabActive then tween(btn, {BackgroundColor3 = COLORS.TabIdle, BackgroundTransparency = 0.5}) end end)
		btn.MouseButton1Click:Connect(function() self:SelectTab(name) end)

		-- Return the elements mapped to the scroll frame
		return BuildElements(scroll)
	end

	function Window:Init()
		if self.FirstTab then self:SelectTab(self.FirstTab) end
		tween(mainFrame, {
			Size = self.CurrentSize,
			Position = UDim2.new(0.5, -(self.CurrentSize.X.Offset/2), 0.5, -(self.CurrentSize.Y.Offset/2)),
			GroupTransparency = 0
		}, 0.5)
	end

	return Window
end

return AlyaUI
