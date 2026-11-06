local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local COL_BG = Color3.fromRGB(39, 39, 39)
local COL_ELEM = Color3.fromRGB(50, 50, 50)
local COL_ELEM_HOVER = Color3.fromRGB(60, 60, 60)
local COL_ELEM_PRESS = Color3.fromRGB(43, 43, 43)
local COL_STROKE = Color3.fromRGB(0, 0, 0)
local COL_CORRECT = Color3.fromRGB(3, 39, 0)
local COL_WRONG = Color3.fromRGB(39, 0, 0)
local COL_KNOB = Color3.fromRGB(235, 235, 235)
local TRANS = 0.2
local CORNER = 8
local FONT = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Bold)

local IMG_CLOSE = "rbxassetid://132261474823036"
local IMG_ENTER = "rbxassetid://8893303613"

local SOUND_HOVER = "rbxassetid://8755541422"
local SOUND_CLICK = "rbxassetid://6895079853"

local AppearInfo = TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local FadeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local ColorInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local PressInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local SlideInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local FillInfo = TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local function applyCorner(inst)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, CORNER)
	c.Parent = inst
	return c
end

local function applyStroke(inst)
	local s = Instance.new("UIStroke")
	s.Color = COL_STROKE
	s.Thickness = 1
	s.Parent = inst
	return s
end

local function style(inst, isElem)
	inst.BackgroundColor3 = isElem and COL_ELEM or COL_BG
	inst.BackgroundTransparency = TRANS
	inst.BorderSizePixel = 0
	applyCorner(inst)
	applyStroke(inst)
	return inst
end

local function playSound(id, volume)
	local s = Instance.new("Sound")
	s.SoundId = id
	s.Volume = volume or 0.5
	s.Parent = SoundService
	s.Ended:Once(function()
		s.Parent = nil
	end)
	task.delay(3, function()
		s.Parent = nil
	end)
	SoundService:PlayLocalSound(s)
end

local function addBtnAnimations(btn)
	if not btn:IsA("GuiButton") then return end
	local scale = Instance.new("UIScale")
	scale.Parent = btn
	btn.MouseEnter:Connect(function()
		playSound(SOUND_HOVER, 0.25)
		TweenService:Create(btn, ColorInfo, {BackgroundColor3 = COL_ELEM_HOVER}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, ColorInfo, {BackgroundColor3 = COL_ELEM}):Play()
	end)
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			TweenService:Create(scale, PressInfo, {Scale = 0.95}):Play()
			TweenService:Create(btn, PressInfo, {BackgroundColor3 = COL_ELEM_PRESS}):Play()
		end
	end)
	btn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			TweenService:Create(scale, PressInfo, {Scale = 1}):Play()
			TweenService:Create(btn, PressInfo, {BackgroundColor3 = COL_ELEM_HOVER}):Play()
		end
	end)
	btn.MouseButton1Click:Connect(function()
		playSound(SOUND_CLICK)
	end)
end

local function fadeInElement(el, delayTime)
	task.delay(delayTime or 0, function()
		if not el.Parent then return end
		el.BackgroundTransparency = 1
		local stroke = el:FindFirstChildOfClass("UIStroke")
		if stroke then stroke.Transparency = 1 end
		TweenService:Create(el, FadeInfo, {BackgroundTransparency = TRANS}):Play()
		if stroke then
			TweenService:Create(stroke, FadeInfo, {Transparency = 0}):Play()
		end
	end)
end

local function makeDraggable(dragHandle, dragTarget)
	dragHandle.Active = true
	local dragging, dragStart, startPos
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = dragTarget.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			dragTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

local AmogusUI = {}

function AmogusUI.Notify(info)
	info = info or {}
	local ng = PlayerGui:FindFirstChild("AmogusUI_Notifications")
	if not ng then
		ng = Instance.new("ScreenGui")
		ng.Name = "AmogusUI_Notifications"
		ng.ResetOnSpawn = false
		ng.Parent = PlayerGui
		local holder = Instance.new("Frame")
		holder.Name = "Holder"
		holder.AnchorPoint = Vector2.new(1, 1)
		holder.Position = UDim2.new(1, -8, 1, -8)
		holder.Size = UDim2.fromOffset(320, 500)
		holder.BackgroundTransparency = 1
		holder.Parent = ng
		local list = Instance.new("UIListLayout")
		list.Padding = UDim.new(0, 6)
		list.VerticalAlignment = Enum.VerticalAlignment.Bottom
		list.HorizontalAlignment = Enum.HorizontalAlignment.Right
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.Parent = holder
	end
	local holder = ng:FindFirstChild("Holder")
	if not holder then return end

	local n = Instance.new("Frame")
	n.Size = UDim2.new(1, 0, 0, 74)
	n.BackgroundColor3 = COL_BG
	n.BackgroundTransparency = 1
	n.BorderSizePixel = 0
	applyCorner(n)
	local nStroke = applyStroke(n)
	nStroke.Transparency = 1
	n.Parent = holder

	local scale = Instance.new("UIScale")
	scale.Scale = 0.8
	scale.Parent = n

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -12, 0, 28)
	title.Position = UDim2.new(0, 6, 0, 4)
	title.BackgroundTransparency = 1
	title.FontFace = FONT
	title.Text = info.Title or "Notification"
	title.TextScaled = true
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = n

	local content = Instance.new("TextLabel")
	content.Size = UDim2.new(1, -12, 1, -34)
	content.Position = UDim2.new(0, 6, 0, 32)
	content.BackgroundTransparency = 1
	content.FontFace = FONT
	content.RichText = true
	content.Text = info.Content or ""
	content.TextScaled = true
	content.TextColor3 = Color3.fromRGB(200, 200, 200)
	content.TextXAlignment = Enum.TextXAlignment.Left
	content.TextYAlignment = Enum.TextYAlignment.Top
	content.Parent = n

	playSound(SOUND_CLICK, 0.3)
	TweenService:Create(n, SlideInfo, {BackgroundTransparency = TRANS}):Play()
	TweenService:Create(nStroke, SlideInfo, {Transparency = 0}):Play()
	TweenService:Create(scale, SlideInfo, {Scale = 1}):Play()

	task.delay(info.Duration or 5, function()
		if not n.Parent then return end
		TweenService:Create(n, FadeInfo, {BackgroundTransparency = 1}):Play()
		TweenService:Create(nStroke, FadeInfo, {Transparency = 1}):Play()
		TweenService:Create(scale, FadeInfo, {Scale = 0.8}):Play()
		task.delay(0.3, function()
			n.Parent = nil
		end)
	end)
end

function AmogusUI.CreateWindow(config)
	config = config or {}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "AmogusUI_" .. (config.Name or "Window")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui

	local Window = Instance.new("Frame")
	Window.Name = "Window"
	Window.Size = UDim2.fromOffset(455, 392)
	Window.Position = UDim2.new(0.166, 0, 0.214, 0)
	style(Window, false)
	Window.Visible = false
	Window.Parent = ScreenGui

	local WindowScale = Instance.new("UIScale")
	WindowScale.Scale = 1
	WindowScale.Parent = Window

	local function showWindow()
		Window.Visible = true
		Window.BackgroundTransparency = 1
		WindowScale.Scale = 0.9
		local stroke = Window:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Transparency = 1
			TweenService:Create(stroke, AppearInfo, {Transparency = 0}):Play()
		end
		TweenService:Create(Window, AppearInfo, {BackgroundTransparency = TRANS}):Play()
		TweenService:Create(WindowScale, AppearInfo, {Scale = 1}):Play()
	end

	local function hideWindow()
		TweenService:Create(Window, FadeInfo, {BackgroundTransparency = 1}):Play()
		TweenService:Create(WindowScale, FadeInfo, {Scale = 0.9}):Play()
		local stroke = Window:FindFirstChildOfClass("UIStroke")
		if stroke then
			TweenService:Create(stroke, FadeInfo, {Transparency = 1}):Play()
		end
		task.delay(0.3, function()
			if Window.BackgroundTransparency >= 0.99 then
				Window.Visible = false
			end
		end)
	end

	local Header = Instance.new("Frame")
	Header.Name = "Header"
	Header.Size = UDim2.new(1, -11, 0, 46)
	Header.Position = UDim2.new(0, 6, 0, 8)
	style(Header, true)
	Header.Parent = Window

	local Title = Instance.new("TextLabel")
	Title.Name = "Label"
	Title.Size = UDim2.new(1, -60, 1, -12)
	Title.Position = UDim2.new(0, 12, 0, 6)
	Title.BackgroundTransparency = 1
	Title.FontFace = FONT
	Title.Text = config.Name or "Amogus UI"
	Title.TextScaled = true
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Header

	local Close = Instance.new("ImageButton")
	Close.Name = "Close"
	Close.Size = UDim2.fromOffset(35, 35)
	Close.Position = UDim2.new(1, -40, 0, 5)
	Close.BackgroundColor3 = COL_ELEM
	Close.BackgroundTransparency = TRANS
	Close.BorderSizePixel = 0
	Close.Image = IMG_CLOSE
	applyCorner(Close)
	applyStroke(Close)
	Close.Parent = Header
	addBtnAnimations(Close)
	Close.MouseButton1Click:Connect(hideWindow)

	local TabHolder = Instance.new("Frame")
	TabHolder.Name = "TabHolder"
	TabHolder.Size = UDim2.new(1, -11, 0, 36)
	TabHolder.Position = UDim2.new(0, 6, 0, 58)
	TabHolder.BackgroundTransparency = 1
	TabHolder.Parent = Window

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.FillDirection = Enum.FillDirection.Horizontal
	TabLayout.Padding = UDim.new(0, 6)
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Parent = TabHolder

	local Content = Instance.new("ScrollingFrame")
	Content.Name = "Content"
	Content.Size = UDim2.new(1, -11, 1, -104)
	Content.Position = UDim2.new(0, 6, 0, 100)
	Content.BackgroundTransparency = 1
	Content.BorderSizePixel = 0
	Content.ScrollBarThickness = 4
	Content.CanvasSize = UDim2.new(0, 0, 0, 0)
	Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Content.Parent = Window

	local ContentLayout = Instance.new("UIListLayout")
	ContentLayout.Padding = UDim.new(0, 6)
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContentLayout.Parent = Content

	local ContentPadding = Instance.new("UIPadding")
	ContentPadding.PaddingRight = UDim.new(0, 6)
	ContentPadding.Parent = Content

	makeDraggable(Header, Window)

	local WindowObj = {}
	local tabs = {}
	local currentTab = nil

	local function selectTab(record)
		if currentTab == record then return end
		local old = currentTab
		if old then
			TweenService:Create(old.Btn, ColorInfo, {BackgroundColor3 = COL_ELEM}):Play()
			TweenService:Create(old.Page, FadeInfo, {GroupTransparency = 1}):Play()
			task.delay(0.3, function()
				if currentTab ~= old then
					old.Page.Visible = false
				end
			end)
		end
		record.Page.Visible = true
		record.Page.GroupTransparency = 1
		TweenService:Create(record.Page, FadeInfo, {GroupTransparency = 0}):Play()
		TweenService:Create(record.Btn, ColorInfo, {BackgroundColor3 = COL_ELEM_HOVER}):Play()
		currentTab = record
	end

	function WindowObj:CreateTab(tabName)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Name = tabName
		TabBtn.Size = UDim2.fromOffset(90, 36)
		TabBtn.BackgroundColor3 = COL_ELEM
		TabBtn.BackgroundTransparency = TRANS
		TabBtn.BorderSizePixel = 0
		TabBtn.FontFace = FONT
		TabBtn.Text = tabName
		TabBtn.TextScaled = true
		TabBtn.TextColor3 = Color3.new(1, 1, 1)
		applyCorner(TabBtn)
		applyStroke(TabBtn)
		TabBtn.Parent = TabHolder
		addBtnAnimations(TabBtn)

		local Page = Instance.new("CanvasGroup")
		Page.Name = tabName
		Page.Size = UDim2.new(1, 0, 0, 0)
		Page.AutomaticSize = Enum.AutomaticSize.Y
		Page.BackgroundTransparency = 1
		Page.GroupTransparency = 1
		Page.Visible = false
		Page.Parent = Content

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Padding = UDim.new(0, 6)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Parent = Page

		local Tab = {}
		local tabRecord = { Tab = Tab, Page = Page, Btn = TabBtn }

		TabBtn.MouseButton1Click:Connect(function()
			selectTab(tabRecord)
		end)

		local function newElement(height)
			local el = Instance.new("Frame")
			el.Size = UDim2.new(1, 0, 0, height)
			el.BackgroundColor3 = COL_ELEM
			el.BackgroundTransparency = TRANS
			el.BorderSizePixel = 0
			applyCorner(el)
			applyStroke(el)
			el.Parent = Page
			if currentTab == tabRecord then
				local count = 0
				for _, c in ipairs(Page:GetChildren()) do
					if c:IsA("GuiObject") then count += 1 end
				end
				fadeInElement(el, count * 0.035)
			end
			return el
		end

		function Tab:CreateSection(name)
			local el = newElement(32)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -12, 1, 0)
			lbl.Position = UDim2.new(0, 6, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.FontFace = FONT
			lbl.Text = name
			lbl.TextScaled = true
			lbl.TextColor3 = Color3.new(1, 1, 1)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = el
			return el
		end

		function Tab:CreateParagraph(par)
			par = par or {}
			local el = newElement(60)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -12, 1, 0)
			lbl.Position = UDim2.new(0, 6, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.FontFace = FONT
			lbl.RichText = true
			lbl.Text = "<b>" .. (par.Title or "") .. "</b>\n" .. (par.Content or "")
			lbl.TextScaled = true
			lbl.TextColor3 = Color3.new(1, 1, 1)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = el
			return el
		end

		function Tab:CreateButton(btn)
			btn = btn or {}
			local el = Instance.new("TextButton")
			el.Size = UDim2.new(1, 0, 0, 44)
			el.BackgroundColor3 = COL_ELEM
			el.BackgroundTransparency = TRANS
			el.BorderSizePixel = 0
			el.FontFace = FONT
			el.Text = btn.Name or "Button"
			el.TextScaled = true
			el.TextColor3 = Color3.new(1, 1, 1)
			applyCorner(el)
			applyStroke(el)
			el.Parent = Page
			addBtnAnimations(el)
			el.MouseButton1Click:Connect(function()
				if btn.Callback then btn.Callback() end
			end)
			if currentTab == tabRecord then fadeInElement(el, 0) end
			return el
		end

		function Tab:CreateToggle(tog)
			tog = tog or {}
			local el = Instance.new("TextButton")
			el.Size = UDim2.new(1, 0, 0, 44)
			el.BackgroundColor3 = COL_ELEM
			el.BackgroundTransparency = TRANS
			el.BorderSizePixel = 0
			el.Text = ""
			applyCorner(el)
			applyStroke(el)
			el.Parent = Page
			addBtnAnimations(el)

			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -70, 1, 0)
			lbl.Position = UDim2.new(0, 6, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.FontFace = FONT
			lbl.Text = tog.Name or "Toggle"
			lbl.TextScaled = true
			lbl.TextColor3 = Color3.new(1, 1, 1)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = el

			local track = Instance.new("Frame")
			track.Size = UDim2.fromOffset(48, 26)
			track.Position = UDim2.new(1, -54, 0.5, -13)
			track.BackgroundColor3 = COL_BG
			track.BackgroundTransparency = TRANS
			track.BorderSizePixel = 0
			applyCorner(track)
			track.Parent = el

			local knob = Instance.new("Frame")
			knob.Size = UDim2.fromOffset(20, 20)
			knob.Position = UDim2.new(0, 3, 0.5, -10)
			knob.BackgroundColor3 = COL_KNOB
			knob.BorderSizePixel = 0
			applyCorner(knob)
			knob.Parent = track

			local state = false
			local function setState(v, skipTween)
				state = v
				local goal = {
					Position = v and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
				}
				if skipTween then
					knob.Position = goal.Position
				else
					TweenService:Create(knob, SlideInfo, goal):Play()
				end
				TweenService:Create(track, ColorInfo, {BackgroundColor3 = v and COL_CORRECT or COL_BG}):Play()
			end

			el.MouseButton1Click:Connect(function()
				setState(not state)
				if tog.Callback then tog.Callback(state) end
			end)

			if tog.CurrentValue then setState(tog.CurrentValue, true) end
			if currentTab == tabRecord then fadeInElement(el, 0) end
			return el
		end

		function Tab:CreateSlider(sld)
			sld = sld or {}
			local el = newElement(56)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -12, 0, 24)
			lbl.Position = UDim2.new(0, 6, 0, 4)
			lbl.BackgroundTransparency = 1
			lbl.FontFace = FONT
			lbl.Text = (sld.Name or "Slider") .. ": 0"
			lbl.TextScaled = true
			lbl.TextColor3 = Color3.new(1, 1, 1)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = el

			local bar = Instance.new("TextButton")
			bar.Size = UDim2.new(1, -12, 0, 16)
			bar.Position = UDim2.new(0, 6, 0, 34)
			bar.BackgroundColor3 = COL_BG
			bar.BackgroundTransparency = TRANS
			bar.BorderSizePixel = 0
			bar.Text = ""
			bar.AutoButtonColor = false
			applyCorner(bar)
			applyStroke(bar)
			bar.Parent = el

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(0, 0, 1, 0)
			fill.BackgroundColor3 = COL_ELEM_HOVER
			fill.BackgroundTransparency = 0
			fill.BorderSizePixel = 0
			applyCorner(fill)
			fill.Parent = bar

			local min = (sld.Range and sld.Range[1]) or 0
			local max = (sld.Range and sld.Range[2]) or 100
			local value = sld.CurrentValue or min

			local function setValue(v, skipTween)
				v = math.clamp(v, min, max)
				value = v
				local size = UDim2.new((v - min) / math.max(max - min, 1), 0, 1, 0)
				if skipTween then
					fill.Size = size
				else
					TweenService:Create(fill, FillInfo, {Size = size}):Play()
				end
				lbl.Text = (sld.Name or "Slider") .. ": " .. tostring(math.floor(v))
				if sld.Callback then sld.Callback(v) end
			end

			local sliding = false
			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					setValue(min + rel * (max - min))
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				sliding = false
				end
			end)

			setValue(value, true)
			return el
		end

		table.insert(tabs, Tab)
		if not currentTab then
			selectTab(tabRecord)
		end
		return Tab
	end

	if config.Keybind then
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then return end
			if input.KeyCode == config.Keybind then
				if Window.Visible then
					hideWindow()
				else
				showWindow()
			end
			end
		end)
	end

	if config.KeySystem then
		local key = config.Key or ""
		local storeName = config.SavedKeyStoreName or "AmogusUI_Key"

		local KeyScreen = Instance.new("Frame")
		KeyScreen.Name = "KeySystem"
		KeyScreen.Size = UDim2.fromOffset(455, 392)
		KeyScreen.Position = Window.Position
		style(KeyScreen, false)
		KeyScreen.Parent = ScreenGui

		local KScale = Instance.new("UIScale")
		KScale.Parent = KeyScreen

		local KHeader = Instance.new("Frame")
		KHeader.Size = UDim2.new(1, -11, 0, 46)
		KHeader.Position = UDim2.new(0, 6, 0, 8)
		style(KHeader, true)
		KHeader.Parent = KeyScreen

		local KLabel = Instance.new("TextLabel")
		KLabel.Size = UDim2.new(1, -60, 1, -12)
		KLabel.Position = UDim2.new(0, 12, 0, 6)
		KLabel.BackgroundTransparency = 1
		KLabel.FontFace = FONT
		KLabel.Text = "Amogus UI Key System"
		KLabel.TextScaled = true
		KLabel.TextColor3 = Color3.new(1, 1, 1)
		KLabel.Parent = KHeader

		local KClose = Instance.new("ImageButton")
		KClose.Size = UDim2.fromOffset(35, 35)
		KClose.Position = UDim2.new(1, -40, 0, 5)
		KClose.BackgroundColor3 = COL_ELEM
		KClose.BackgroundTransparency = TRANS
		KClose.BorderSizePixel = 0
		KClose.Image = IMG_CLOSE
		applyCorner(KClose)
		applyStroke(KClose)
		KClose.Parent = KHeader
		addBtnAnimations(KClose)
		KClose.MouseButton1Click:Connect(function()
			ScreenGui.Enabled = false
		end)

		local KMain = Instance.new("Frame")
		KMain.Size = UDim2.new(1, -12, 1, -74)
		KMain.Position = UDim2.new(0, 6, 0, 64)
		style(KMain, true)
		KMain.Parent = KeyScreen

		local KeyText = Instance.new("TextBox")
		KeyText.Size = UDim2.fromOffset(355, 60)
		KeyText.Position = UDim2.new(0.025, 0, 0.167, 0)
		KeyText.BackgroundColor3 = COL_ELEM
		KeyText.BackgroundTransparency = TRANS
		KeyText.BorderSizePixel = 0
		KeyText.FontFace = FONT
		KeyText.Text = ""
		KeyText.PlaceholderText = "Enter a key"
		KeyText.PlaceholderColor3 = Color3.fromRGB(128, 128, 128)
		KeyText.TextScaled = true
		KeyText.TextColor3 = Color3.new(1, 1, 1)
		applyCorner(KeyText)
		applyStroke(KeyText)
		KeyText.Parent = KMain

		local EnterKey = Instance.new("ImageButton")
		EnterKey.Size = UDim2.fromOffset(60, 60)
		EnterKey.Position = UDim2.new(0.844, 0, 0.167, 0)
		EnterKey.BackgroundColor3 = COL_ELEM
		EnterKey.BackgroundTransparency = TRANS
		EnterKey.BorderSizePixel = 0
		EnterKey.Image = IMG_ENTER
		applyCorner(EnterKey)
		applyStroke(EnterKey)
		EnterKey.Parent = KMain
		addBtnAnimations(EnterKey)

		local GetKey = Instance.new("TextButton")
		GetKey.Size = UDim2.fromOffset(170, 50)
		GetKey.Position = UDim2.new(0.025, 0, 0.42, 0)
		GetKey.BackgroundColor3 = COL_ELEM
		GetKey.BackgroundTransparency = TRANS
		GetKey.BorderSizePixel = 0
		GetKey.FontFace = FONT
		GetKey.Text = "Get Key"
		GetKey.TextScaled = true
		GetKey.TextColor3 = Color3.new(1, 1, 1)
		applyCorner(GetKey)
		applyStroke(GetKey)
		GetKey.Parent = KMain
		addBtnAnimations(GetKey)
		if config.GetKeyCallback then
			GetKey.MouseButton1Click:Connect(config.GetKeyCallback)
		end

		local Check = Instance.new("Frame")
		Check.Size = UDim2.fromOffset(244, 50)
		Check.Position = UDim2.new(0.428, 0, 0.418, 0)
		Check.BackgroundColor3 = COL_BG
		Check.BackgroundTransparency = TRANS
		Check.BorderSizePixel = 0
		applyCorner(Check)
		applyStroke(Check)
		Check.Parent = KMain

		local function tweenColor(color)
			TweenService:Create(Check, ColorInfo, {BackgroundColor3 = color}):Play()
		end

		local function saveKey(input)
			if writefile then
				pcall(function()
					if makefolder and not isfile("KeySystem") then pcall(makefolder, "KeySystem") end
					writefile("KeySystem/" .. storeName .. ".json", input)
				end)
			elseif getgenv then
				getgenv()[storeName] = input
			end
		end

		local function getSavedKey()
				if readfile then
					local ok, result = pcall(function()
						local exists = true
						if isfile then exists = isfile("KeySystem/" .. storeName .. ".json") end
						if exists then return readfile("KeySystem/" .. storeName .. ".json") end
						return nil
					end)
					if ok and type(result) == "string" and result ~= "" then return result end
				elseif getgenv then
					local v = getgenv()[storeName]
					if type(v) == "string" and v ~= "" then return v end
				end
				return nil
		end

		local function unlock()
			KeyText.Text = ""
			TweenService:Create(KeyScreen, FadeInfo, {BackgroundTransparency = 1}):Play()
			TweenService:Create(KScale, FadeInfo, {Scale = 0.9}):Play()
			task.delay(0.3, function()
				KeyScreen.Visible = false
				showWindow()
			end)
		end

		local function checkKey()
			local input = KeyText.Text:gsub("^%s+", ""):gsub("%s+$", "")
			if input == "" then
				tweenColor(COL_BG)
				return
			end
			if input == key then
				tweenColor(COL_CORRECT)
				saveKey(input)
				task.wait(0.4)
				unlock()
			else
				tweenColor(COL_WRONG)
				task.delay(0.6, function()
					tweenColor(COL_BG)
				end)
			end
		end

		EnterKey.MouseButton1Click:Connect(checkKey)
		KeyText.FocusLost:Connect(function(enterPressed)
			if enterPressed then checkKey() end
		end)

		if getSavedKey() == key then
			KeyScreen.Visible = false
			showWindow()
		else
			KeyScreen.BackgroundTransparency = 1
			KScale.Scale = 0.9
			local kStroke = KeyScreen:FindFirstChildOfClass("UIStroke")
			if kStroke then
				kStroke.Transparency = 1
				TweenService:Create(kStroke, AppearInfo, {Transparency = 0}):Play()
			end
			TweenService:Create(KeyScreen, AppearInfo, {BackgroundTransparency = TRANS}):Play()
			TweenService:Create(KScale, AppearInfo, {Scale = 1}):Play()
			Window.Visible = false
		end
	else
		showWindow()
	end

	return WindowObj
end

return AmogusUI
