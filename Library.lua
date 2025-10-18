for _, UI in ipairs(game.CoreGui:GetChildren()) do
	if UI.Name == "Orion" then 
		UI:Destroy() 
	end
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local OrionLib = {
	Elements = {},
	ThemeObjects = {},
	Connections = {},
	Flags = {},
	Themes = {
		Default = {
			Main = Color3.fromRGB(100, 100, 100),
			Stroke = Color3.fromRGB(100, 100, 100),
			Divider = Color3.fromRGB(50, 50, 50),
			Text = Color3.fromRGB(255, 255, 255),
			TextDark = Color3.fromRGB(200, 200, 200),
         Elements = Color3.fromRGB(80, 80, 80),
		}
	},
	SelectedTheme = "Default",
	Folder = nil,
}

-- Icons
	local Icons = {}
	local LucideIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/orion-2/refs/heads/main/Icons.lua"))().assets

-- Core
	getgenv().gethui = function() return game.CoreGui end
	local Orion = Instance.new("ScreenGui")
	Orion.Name = "Orion"
	Orion.Parent = gethui() or CoreGui

	function OrionLib:IsRunning()
		return Orion.Parent == gethui() or Orion.Parent == CoreGui
	end

-- Local functions --
	local function GetOrionIcon(IconName)
		if Icons[IconName] ~= nil then return Icons[IconName] else return nil end
	end   
	local function GetLucideIcon(IconName)
		if IconName ~= nil then
			return LucideIcons["lucide-"..IconName]
		else 
			return nil 
		end
	end

	local function AddConnection(Signal, Function)
		if (not OrionLib:IsRunning()) then return end
		local SignalConnect = Signal:Connect(Function)
		table.insert(OrionLib.Connections, SignalConnect)
		return SignalConnect
	end

	task.spawn(function()
		while (OrionLib:IsRunning()) do wait() end
		for _, Connection in next, OrionLib.Connections do Connection:Disconnect() end
	end)

	local function Create(Name, Properties, Children)
		local Object = Instance.new(Name)
		for i, v in next, Properties or {} do Object[i] = v end
		for i, v in next, Children or {} do v.Parent = Object end
		return Object
	end

	local function CreateElement(ElementName, ElementFunction)
		OrionLib.Elements[ElementName] = function(...) return ElementFunction(...) end
	end

	local function MakeElement(ElementName, ...)
		local NewElement = OrionLib.Elements[ElementName](...)
		return NewElement
	end

	local function SetProps(Element, Props)
		table.foreach(Props, function(Property, Value) Element[Property] = Value end)
		return Element
	end

	local function SetChildren(Element, Children)
		table.foreach(Children, function(_, Child) Child.Parent = Element end)
		return Element
	end

	local function Round(Number, Factor)
		local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
		if Result < 0 then Result = Result + Factor end
		return Result
	end

	local function ReturnProperty(Object)
		if Object:IsA("Frame") or Object:IsA("TextButton") then return "BackgroundColor3" end 
		if Object:IsA("ScrollingFrame") then return "ScrollBarImageColor3" end 
		if Object:IsA("UIStroke") then return "Color" end 
		if Object:IsA("TextLabel") or Object:IsA("TextBox") then return "TextColor3" end   
		if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then return "ImageColor3" end   
	end

	local function AddThemeObject(Object, Type)
		if not OrionLib.ThemeObjects[Type] then OrionLib.ThemeObjects[Type] = {} end    
		table.insert(OrionLib.ThemeObjects[Type], Object)
		Object[ReturnProperty(Object)] = OrionLib.Themes[OrionLib.SelectedTheme][Type]
		return Object
	end    

	local function SetTheme()
		for Name, Type in pairs(OrionLib.ThemeObjects) do
			for _, Object in pairs(Type) do Object[ReturnProperty(Object)] = OrionLib.Themes[OrionLib.SelectedTheme][Name] end    
		end    
	end

	local function PackColor(Color)
		return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
	end    

	local function UnpackColor(Color)
		return Color3.fromRGB(Color.R, Color.G, Color.B)
	end

	local WhitelistedMouse = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2,Enum.UserInputType.MouseButton3}
	local BlacklistedKeys = {Enum.KeyCode.Unknown,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Up,Enum.KeyCode.Left,Enum.KeyCode.Down,Enum.KeyCode.Right,Enum.KeyCode.Slash,Enum.KeyCode.Backspace,Enum.KeyCode.Escape}

	local function CheckKey(Table, Key)
		for _, v in next, Table do
			if v == Key then return true end
		end
	end

-- Create Elements -- 
	CreateElement("Corner", function(Scale, Offset)
		local Corner = Create("UICorner", {CornerRadius = UDim.new(Scale or 0, Offset or 10)})
		return Corner
	end)

	CreateElement("Stroke", function(Color, Thickness)
		local Stroke = Create("UIStroke", {
			Color = Color or Color3.fromRGB(255, 255, 255),
			Thickness = Thickness or 1
		})
		return Stroke
	end)

	CreateElement("List", function(Scale, Offset)
		local List = Create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(Scale or 0, Offset or 0)
		})
		return List
	end)

	CreateElement("Padding", function(Bottom, Left, Right, Top)
		local Padding = Create("UIPadding", {
			PaddingBottom = UDim.new(0, Bottom or 4),
			PaddingLeft = UDim.new(0, Left or 4),
			PaddingRight = UDim.new(0, Right or 4),
			PaddingTop = UDim.new(0, Top or 4)
		})
		return Padding
	end)

	CreateElement("TFrame", function()
		local TFrame = Create("Frame", {
			BackgroundTransparency = 1
		})
		return TFrame
	end)

	CreateElement("Frame", function(Color)
		local Frame = Create("Frame", {
			BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0
		})
		return Frame
	end)

	CreateElement("RoundFrame", function(Color, Scale, Offset)
		local Frame = Create("Frame", {
			BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0
		}, {
			Create("UICorner", {CornerRadius = UDim.new(Scale, Offset)})
		})
		return Frame
	end)

	CreateElement("Button", function()
		local Button = Create("TextButton", {
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		})
		return Button
	end)

	CreateElement("ScrollFrame", function(Color)
		local ScrollFrame = Create("ScrollingFrame", {
			BackgroundTransparency = 1,
			MidImage = "rbxassetid://7445543667",
			BottomImage = "rbxassetid://7445543667",
			TopImage = "rbxassetid://7445543667",
			ScrollBarImageColor3 = Color,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
		})
		return ScrollFrame
	end)

	CreateElement("Image", function(ImageID)
		local ImageNew = Create("ImageLabel", {Image = ImageID, BackgroundTransparency = 1})
		if GetOrionIcon(ImageID) ~= nil then ImageNew.Image = GetOrionIcon(ImageID) end	
		return ImageNew
	end)

	CreateElement("ImageButton", function(ImageID)
		local Image = Create("ImageButton", {Image = ImageID, BackgroundTransparency = 1})
		return Image
	end)

	CreateElement("Label", function(Text, TextSize, Transparency)
		local Label = Create("TextLabel", {
			Text = Text or "",
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextTransparency = Transparency or 0,
			TextSize = TextSize or 15,
			Font = Enum.Font.Gotham,
			RichText = true,
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left
		})
		return Label
	end)

local NotificationHolder = SetProps(SetChildren(MakeElement("TFrame"), {
	SetProps(MakeElement("List"), {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Padding = UDim.new(0, 5)
	})
}), {
	Position = UDim2.new(1, -25, 1, -25),
	Size = UDim2.new(0, 300, 1, -25),
	AnchorPoint = Vector2.new(1, 1),
	Parent = Orion
})

function OrionLib:MakeNotification(NotificationConfig)
	spawn(function()
		NotificationConfig.Name = NotificationConfig.Name or "Notification"
		NotificationConfig.Content = NotificationConfig.Content or "Test"
		NotificationConfig.Image = NotificationConfig.Image or "rbxassetid://4384403532"
		NotificationConfig.Time = NotificationConfig.Time or 15
		NotificationConfig.Color = NotificationConfig.Color or Color3.fromRGB(100, 100, 100)

		local NotificationParent = SetProps(MakeElement("TFrame"), {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = NotificationHolder
		})

		local NotificationFrame = SetChildren(SetProps(MakeElement("RoundFrame", NotificationConfig.Color, 0, 10), {
			Parent = NotificationParent, 
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(1, -55, 0, 0),
			BackgroundTransparency = 0.4,
			AutomaticSize = Enum.AutomaticSize.Y
		}), {
			MakeElement("Stroke", Color3.fromRGB(0, 80, 80), 1.2),
			MakeElement("Padding", 12, 12, 12, 12),
			SetProps(MakeElement("Image", NotificationConfig.Image), {
				Size = UDim2.new(0, 20, 0, 20),
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				Name = "Icon",
				BackgroundTransparency = 1,
			}),
			SetProps(MakeElement("Label", NotificationConfig.Name, 15), {
				Size = UDim2.new(1, -30, 0, 20),
				Position = UDim2.new(0, 30, 0, 0),
				Font = Enum.Font.GothamBold,
				Name = "Title",
				BackgroundTransparency = 1,
			}),
			SetProps(MakeElement("Label", NotificationConfig.Content, 14), {
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 25),
				Font = Enum.Font.GothamSemibold,
				Name = "Content",
				AutomaticSize = Enum.AutomaticSize.Y,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextWrapped = true,
				BackgroundTransparency = 1,
			})
		})

		TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()

		wait(NotificationConfig.Time - 0.88)
		TweenService:Create(NotificationFrame.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
		TweenService:Create(NotificationFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.6}):Play()
		wait(0.3)
		TweenService:Create(NotificationFrame.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Transparency = 0.9}):Play()
		TweenService:Create(NotificationFrame.Title, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0.4}):Play()
		TweenService:Create(NotificationFrame.Content, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0.5}):Play()
		wait(0.05)

		NotificationFrame:TweenPosition(UDim2.new(1, 20, 0, 0),'In','Quint',0.8,true)
		wait(1.35)
		NotificationFrame:Destroy()
	end)
end    

function OrionLib:MakeWindow(WindowConfig)
	-- Config --
		local FirstTab = true
		local Minimized = false
		local Loaded = false
		local UIHidden = false
		local Tab = ""

		WindowConfig = WindowConfig or {}
		WindowConfig.Name = WindowConfig.Name or "Better Orion"
		WindowConfig.SubName = WindowConfig.SubName or ""
		WindowConfig.Size = WindowConfig.Size or UDim2.fromOffset(600, 400)
		WindowConfig.MinSize = WindowConfig.MinSize or UDim2.fromOffset(400, 200)
		WindowConfig.MaxSize = WindowConfig.MaxSize or UDim2.fromOffset(4000, 2000)
		WindowConfig.Theme = WindowConfig.Theme or "Default"
		WindowConfig.IntroEnabled = WindowConfig.IntroEnabled or false
		WindowConfig.IntroText = WindowConfig.IntroText or "Better Orion"
		WindowConfig.ShowIcon = WindowConfig.ShowIcon or false
		WindowConfig.Icon = GetLucideIcon(WindowConfig.Icon) or ""
		WindowConfig.IntroIcon = GetLucideIcon(WindowConfig.IntroIcon) or ""
		WindowConfig.Transparency = WindowConfig.Transparency or 0
		WindowConfig.ElementsTransparency = WindowConfig.ElementsTransparency or 0
		WindowConfig.ToggleUIKey = WindowConfig.ToggleUIKey or Enum.KeyCode.Tab

	-- Elements
		local TabHolder = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255)), {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}), {
			MakeElement("List"),
			MakeElement("Padding", 8, 0, 0, 8)
		}), "Divider")

		AddConnection(TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabHolder.UIListLayout.AbsoluteContentSize.Y + 16)
		end)

		local CloseBtn = SetChildren(SetProps(MakeElement("Button"), {
			Size = UDim2.new(0.5, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1
		}), {
			AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072725342"), {
				Position = UDim2.new(0, 9, 0, 6),
				Size = UDim2.new(0, 18, 0, 18),
			}), "Text")
		})

		local MinimizeBtn = SetChildren(SetProps(MakeElement("Button"), {
			Size = UDim2.new(0.5, 0, 1, 0),
			BackgroundTransparency = 1
		}), {
			AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072719338"), {
				Position = UDim2.new(0, 9, 0, 6),
				Size = UDim2.new(0, 18, 0, 18),
				Name = "Ico"
			}), "Text")
		})

		local DragPoint = SetProps(MakeElement("TFrame"), {
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundTransparency = 1
		})

		local ResizePoint = SetProps(MakeElement("RoundFrame", Color3.fromRGB(20, 20, 20), 0, 10), {
			Size = UDim2.new(0, 12, 0, 30),
			Position = UDim2.new(1, -12, 1, -30),
			BackgroundTransparency = 0.9
		})

		local WindowStuff = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 10), {
			Size = UDim2.new(0.2, 0, 1, -50),
			Position = UDim2.new(0, 0, 0, 50),
			BackgroundTransparency = 1,
		}), {
			AddThemeObject(SetProps(MakeElement("Frame"), {
				Size = UDim2.new(1, 0, 0, 10),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
			}), "Elements"), 
			AddThemeObject(SetProps(MakeElement("Frame"), {
				Size = UDim2.new(0, 10, 1, 0),
				Position = UDim2.new(1, -10, 0, 0),
				BackgroundTransparency = 1,
			}), "Elements"), 
			AddThemeObject(SetProps(MakeElement("Frame"), {
				Size = UDim2.new(0, 1, 1, 0),
				Position = UDim2.new(1, -1, 0, 0),
				BackgroundTransparency = 1,
			}), "Stroke"), 
			TabHolder,
		}), "Elements")

		local WindowName = AddThemeObject(SetProps(MakeElement("Label", WindowConfig.Name, 14), {
			Size = UDim2.new(1, -30, 2, 0),
			Position = UDim2.new(0, 25, 0, -24),
			Font = Enum.Font.GothamBlack,
			TextSize = 20
		}), "Text")

		local WindowSubName = AddThemeObject(SetProps(MakeElement("Label", WindowConfig.SubName, 14), {
			Size = UDim2.new(1, WindowName.TextBounds.X - 240, 1, 0),
			Position = UDim2.new(0, WindowName.TextBounds.X + 140, 0, -18),
			Font = Enum.Font.GothamSemibold,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center
		}), "TextDark")

		local WindowTopBarLine = AddThemeObject(SetProps(MakeElement("Frame"), {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, -1),
			BackgroundTransparency = 1,
		}), "Stroke")

		local MainWindow = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 10), {
			Parent = Orion,
			Position = UDim2.fromScale(0.3, 0),
			Size = WindowConfig.Size,
			ClipsDescendants = true,
			BackgroundTransparency = WindowConfig.Transparency,
		}), {
			SetChildren(SetProps(MakeElement("TFrame"), {
				Size = UDim2.new(1, 0, 0, 50),
				Name = "TopBar",
				BackgroundTransparency = 1,
			}), {
				WindowName,
				WindowTopBarLine,
				AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 7), {
					Size = UDim2.new(0, 70, 0, 30),
					Position = UDim2.new(1, -90, 0, 10),
					BackgroundTransparency = 1,
				}), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					AddThemeObject(SetProps(MakeElement("Frame"), {
						Size = UDim2.new(0, 1, 1, 0),
						Position = UDim2.new(0.5, 0, 0, 0),
						BackgroundTransparency = 0,
					}), "Stroke"), 
					CloseBtn,
					MinimizeBtn
				}), "Elements"),
				AddThemeObject(SetChildren(SetProps(MakeElement("TFrame", Color3.fromRGB(255, 255, 255), 0, 7), {
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, 0, 0, 20),
				}), {
					WindowSubName,
				}), "Elements"),
			}),
			SetProps(MakeElement("Button"), {
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 0,
			}),
			DragPoint,
			ResizePoint,
			WindowStuff
		}), "Main")

	-- Local window functions
		if WindowConfig.ShowIcon then
			WindowName.Position = UDim2.new(0, 50, 0, -24)
			local WindowIcon = SetProps(MakeElement("Image", WindowConfig.Icon), {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 25, 0, 15)})
			WindowIcon.Parent = MainWindow.TopBar
		end	

		local function AddDraggingFunctionality(DragPoint, Main)
			pcall(function()
				local Dragging, DragInput, MousePos, FramePos = false
				DragPoint.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1  or Input.UserInputType == Enum.UserInputType.Touch then
						Dragging = true
						MousePos = Input.Position
						FramePos = Main.Position

						Input.Changed:Connect(function()
							if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
						end)
					end
				end)
				DragPoint.InputChanged:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then DragInput = Input end
				end)
				UserInputService.InputChanged:Connect(function(Input)
					if Input == DragInput and Dragging then
						local Delta = Input.Position - MousePos
						TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position  = UDim2.new(FramePos.X.Scale,FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)}):Play()
					end
				end)
			end)
		end   

		local function AddResizingFunctionality(ResizePoint, Main)
			pcall(function()  
				local Dragging, DragInput, MousePos, FrameSize = false
				ResizePoint.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1  or Input.UserInputType == Enum.UserInputType.Touch then
						Dragging = true
						MousePos = Input.Position
						FrameSize = Main.Size

						Input.Changed:Connect(function()
							if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
						end)
					end
				end)
				ResizePoint.InputChanged:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then DragInput = Input end
				end)
				UserInputService.InputChanged:Connect(function(Input)
					if Input == DragInput and Dragging then
						local Delta = Input.Position - MousePos
						local size = UDim2.new(
							FrameSize.X.Scale, math.clamp(FrameSize.X.Offset + Delta.X, WindowConfig.MinSize.X.Offset, WindowConfig.MaxSize.X.Offset),
							FrameSize.Y.Scale, math.clamp(FrameSize.Y.Offset + Delta.Y, WindowConfig.MinSize.Y.Offset, WindowConfig.MaxSize.Y.Offset)
						)
						TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = size}):Play()
						WindowConfig.Size = size
					end
				end)
			end)
		end

		AddDraggingFunctionality(DragPoint, MainWindow)
		AddResizingFunctionality(ResizePoint, MainWindow)

	-- Local window connections
		AddConnection(CloseBtn.MouseButton1Up, function()
			MainWindow.Visible = false
			UIHidden = true
			OrionLib:MakeNotification({
				Name = "Interface Hidden",
				Content = "Tap "..tostring(WindowConfig.ToggleUIKey):split(".")[3].." to reopen the interface",
				Time = 5
			})
			WindowConfig.CloseCallback()
		end)

		AddConnection(UserInputService.InputBegan, function(Input)
			if Input.KeyCode == WindowConfig.ToggleUIKey then 
				UIHidden = not UIHidden
				MainWindow.Visible = not UIHidden 
			end
		end)

		local VisibleContainers = {}
		AddConnection(MinimizeBtn.MouseButton1Up, function()
			if Minimized then
				TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = WindowConfig.Size}):Play()
				ResizePoint.Visible = true
				MinimizeBtn.Ico.Image = "rbxassetid://7072719338"
				WindowSubName.Visible = true
				wait(.02)
				MainWindow.ClipsDescendants = false
				WindowStuff.Visible = true
				WindowTopBarLine.Visible = true
				for i, v in pairs(VisibleContainers) do
					v.Visible = true
				end
				VisibleContainers = {}
			else
				MainWindow.ClipsDescendants = true
				WindowTopBarLine.Visible = false
				MinimizeBtn.Ico.Image = "rbxassetid://7072720870"

				TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, WindowName.TextBounds.X + 140, 0, 50)}):Play()
				WindowSubName.Visible = false
				ResizePoint.Visible = false
				wait(0.1)
				WindowStuff.Visible = false
				for i, Container in pairs(MainWindow:GetChildren()) do
					if Container.Name == "ItemContainerLeft" or Container.Name == "ItemContainerRight" then
						if Container.Visible then
							Container.Visible = false
							table.insert(VisibleContainers, Container)
						end
					end
				end
			end
			Minimized = not Minimized    
		end)
		local function LoadSequence()
			MainWindow.Visible = false
			local LoadSequenceLogo = SetProps(MakeElement("Image", WindowConfig.IntroIcon), {
				Parent = Orion,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.4, 0),
				Size = UDim2.new(0, 28, 0, 28),
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				ImageTransparency = 1
			})

			local LoadSequenceText = SetProps(MakeElement("Label", WindowConfig.IntroText, 14), {
				Parent = Orion,
				Size = UDim2.new(1, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 19, 0.5, 0),
				TextXAlignment = Enum.TextXAlignment.Center,
				Font = Enum.Font.GothamBold,
				TextTransparency = 1
			})

			TweenService:Create(LoadSequenceLogo, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
			wait(0.8)
			TweenService:Create(LoadSequenceLogo, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -(LoadSequenceText.TextBounds.X/2), 0.5, 0)}):Play()
			wait(0.3)
			TweenService:Create(LoadSequenceText, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
			wait(2)
			TweenService:Create(LoadSequenceText, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
			MainWindow.Visible = true
			LoadSequenceLogo:Destroy()
			LoadSequenceText:Destroy()
		end 

		if WindowConfig.IntroEnabled then LoadSequence() end	

	-- Local set functions
		local TabFunction = {}
			
		function TabFunction:SetSize(Size)
			MainWindow.Size = Size
		end

		function TabFunction:SetColor(Color)
			MainWindow.BackgroundColor3 = Color
		end

		function TabFunction:GetColor()
			return MainWindow.BackgroundColor3
		end

		function TabFunction:SetTransparency(Transparency)
			MainWindow.BackgroundTransparency = Transparency
		end

		function TabFunction:SetToggleKey(Key)
			local KeyCode = Key or Enum.KeyCode.RightShift
			WindowConfig.ToggleUIKey = Enum.KeyCode[KeyCode]
		end

		function TabFunction:DestroyElement(Flag)
			if OrionLib.Flags[Flag] ~= nil then
				OrionLib.Flags[Flag]:Destroy()
			end
		end
		
	function TabFunction:MakeTab(TabConfig)
		TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.Icon = TabConfig.Icon or ""
		TabConfig.PremiumOnly = TabConfig.PremiumOnly or false

		Tab = TabConfig.Name

		local TabFrame = SetChildren(SetProps(MakeElement("Button"), {
			Size = UDim2.new(1, 0, 0, 30),
			Parent = TabHolder,
			TextWrapped = true,
			Name = Tab,
		}), {
			AddThemeObject(SetProps(MakeElement("Image", GetLucideIcon(TabConfig.Icon)), {
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, 18, 0, 18),
				Position = UDim2.new(0, 10, 0.5, 0),
				ImageTransparency = 0.4,
				Name = "Ico"
			}), "Text"),
			AddThemeObject(SetProps(MakeElement("Label", TabConfig.Name, 14), {
				Size = UDim2.new(1, -35, 1, 0),
				Position = UDim2.new(0, 35, 0, 0),
				Font = Enum.Font.GothamSemibold,
				TextTransparency = 0.4,
				TextWrapped = true,
				Name = "Title"
			}), "Text")
		})

		local ContainerLeft = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255)), {
			Size = UDim2.new(0.4, 0, 0.95, -50),
			Position = UDim2.new(0.19, 0, 0, 50),
			Parent = MainWindow,
			Visible = false,
			Name = "ItemContainerLeft"
		}), {
			MakeElement("List", 0, 6),
			MakeElement("Padding", 15, 10, 10, 15) 
		}), "Divider")

		local ContainerRight = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255)), {
			Size = UDim2.new(0.4, 0, 0.95, -50),
			Position = UDim2.new(0.59, 0, 0, 50),
			Parent = MainWindow,
			Visible = false,
			Name = "ItemContainerRight"
		}), {
			MakeElement("List", 0, 6),
			MakeElement("Padding", 15, 10, 10, 15)
		}), "Divider")

		AddConnection(ContainerLeft.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			ContainerLeft.CanvasSize = UDim2.new(0, 0, 0, ContainerLeft.UIListLayout.AbsoluteContentSize.Y - 5)
		end)
		AddConnection(ContainerRight.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			ContainerRight.CanvasSize = UDim2.new(0, 0, 0, ContainerRight.UIListLayout.AbsoluteContentSize.Y - 5)
		end)

		if GetOrionIcon(TabConfig.Icon) ~= nil then TabFrame.Ico.Image = GetOrionIcon(TabConfig.Icon) end	

		if FirstTab then
			FirstTab = false
			TabFrame.Ico.ImageTransparency = 0
			TabFrame.Title.TextTransparency = 0
			TabFrame.Title.Font = Enum.Font.GothamBlack
			ContainerLeft.Visible = true
         ContainerRight.Visible = true
		end    

		AddConnection(TabFrame.MouseButton1Click, function()
			for _, Tab in next, TabHolder:GetChildren() do
				if Tab:IsA("TextButton") then
					Tab.Title.Font = Enum.Font.GothamSemibold
					TweenService:Create(Tab.Ico, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0.4}):Play()
					TweenService:Create(Tab.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0.4}):Play()
				end    
			end
			for _, Container in next, MainWindow:GetChildren() do
				if Container.Name == "ItemContainerLeft" or Container.Name == "ItemContainerRight" then
					Container.Visible = false
				end    
			end  
			TweenService:Create(TabFrame.Ico, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
			TweenService:Create(TabFrame.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
			TabFrame.Title.Font = Enum.Font.GothamBlack
			ContainerLeft.Visible = true   
         ContainerRight.Visible = true
		end)

		local function GetElements(ItemParent)
			local ElementFunction = {}
			function ElementFunction:AddLabel(Text)
				local LabelFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundTransparency = WindowConfig.ElementsTransparency,
					Parent = ItemParent
				}), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 14), {
						Size = UDim2.new(1, -12, 1, 0),
						Position = UDim2.new(0, 12, 0, 0),
						Font = Enum.Font.GothamBold,
						Name = "Content",
						TextWrapped = true,
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke")
				}), "Elements")

				AddConnection(LabelFrame.Content:GetPropertyChangedSignal("Text"), function()
					LabelFrame.Content.Size = UDim2.new(1, -24, 0, LabelFrame.Content.TextBounds.Y)
					LabelFrame.Content.Position = UDim2.new(0, 12, 0, 6)
					LabelFrame.Size = UDim2.new(1, 0, 0, LabelFrame.Content.TextBounds.Y + 12)
				end)

				local LabelFunction = {}
				function LabelFunction:Set(ToChange)
					LabelFrame.Content.Text = ToChange
				end
				return LabelFunction
			end
			function ElementFunction:AddParagraph(Text, Content)
				Text = Text or "Text"
				Content = Content or "Content"

				local ParagraphFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundTransparency = WindowConfig.ElementsTransparency,
					Parent = ItemParent
				}), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 14), {
						Size = UDim2.new(1, -12, 0, 14),
						Position = UDim2.new(0, 12, 0, 10),
						Font = Enum.Font.GothamBold,
						Name = "Title"
					}), "Text"),
					AddThemeObject(SetProps(MakeElement("Label", "", 13), {
						Size = UDim2.new(1, -24, 0, 0),
						Position = UDim2.new(0, 12, 0, 26),
						Font = Enum.Font.GothamSemibold,
						Name = "Content",
						TextWrapped = true
					}), "TextDark"),
					AddThemeObject(MakeElement("Stroke"), "Stroke")
				}), "Elements")

				ParagraphFrame.Content.Text = Content

				AddConnection(ParagraphFrame.Content:GetPropertyChangedSignal("Text"), function()
					ParagraphFrame.Content.Size = UDim2.new(1, -24, 0, ParagraphFrame.Content.TextBounds.Y)
					ParagraphFrame.Size = UDim2.new(1, 0, 0, ParagraphFrame.Content.TextBounds.Y + 35)
				end)

				local ParagraphFunction = {}
				function ParagraphFunction:Set(ToChange)
					ParagraphFrame.Content.Text = ToChange
				end
				return ParagraphFunction
			end    
			function ElementFunction:AddButton(ButtonConfig)
				ButtonConfig = ButtonConfig or {}
				ButtonConfig.Name = ButtonConfig.Name or "Button"
				ButtonConfig.Callback = ButtonConfig.Callback or function() end
				ButtonConfig.Icon = ButtonConfig.Icon or "rbxassetid://3944703587"
				ButtonConfig.DoubleTap = ButtonConfig.DoubleTap or false
				ButtonConfig.TapDelay = ButtonConfig.TapDelay or 0.5

				local Button, Tap, OldButtonName = {}, 0, ButtonConfig.Name

				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 1, 0)
				})

				local ButtonFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 33),
					Parent = ItemParent,
					BackgroundTransparency = WindowConfig.ElementsTransparency,
				}), {
					AddThemeObject(SetProps(MakeElement("Label", ButtonConfig.Name, 14), {
						Size = UDim2.new(1, -40, 1, 0),
						Position = UDim2.new(0, 12, 0, 0),
						Font = Enum.Font.GothamBold,
						Name = "Content",
						TextWrapped = true,
					}), "Text"),
					AddThemeObject(SetProps(MakeElement("Image", ButtonConfig.Icon), {
						Size = UDim2.new(0, 20, 0, 20),
						Position = UDim2.new(1, -30, 0, 7),
					}), "TextDark"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					Click
				}), "Elements")

				function Button:Set(ButtonText)
					ButtonFrame.Content.Text = ButtonText
				end

				function Button:SetColor(Color)
					ButtonFrame.BackgroundColor3 = Color
				end

				function Button:SetTransparency(Transparency)
					ButtonFrame.BackgroundTransparency = Transparency
				end

				AddConnection(Click.MouseEnter, function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Elements.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.B * 255 + 3)}):Play()
				end)

				AddConnection(Click.MouseLeave, function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Elements}):Play()
				end)

				AddConnection(Click.MouseButton1Up, function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Elements.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.B * 255 + 3)}):Play()
					Tap += 1
					spawn(function()
						if Tap == 2 and ButtonConfig.DoubleTap then 
							ButtonConfig.Callback()
						elseif Tap == 1 and ButtonConfig.DoubleTap then 
							ButtonFrame.Content.Text = "Are you sure?"
							task.wait(ButtonConfig.TapDelay)
							if Tap == 1 then 
								Tap = 0
								ButtonFrame.Content.Text = OldButtonName
							end
						elseif not ButtonConfig.DoubleTap then
							ButtonConfig.Callback()
						end
						Tap = 0
						ButtonFrame.Content.Text = OldButtonName
					end)
				end)

				AddConnection(Click.MouseButton1Down, function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Elements.R * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Elements.G * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Elements.B * 255 + 6)}):Play()
				end)

				return Button
			end    
			function ElementFunction:AddToggle(ToggleConfig)
				ToggleConfig = ToggleConfig or {}
				ToggleConfig.Name = ToggleConfig.Name or "Toggle"
				ToggleConfig.Default = ToggleConfig.Default or false
				ToggleConfig.Callback = ToggleConfig.Callback or function() end
				ToggleConfig.Color = ToggleConfig.Color or Color3.fromRGB(50, 50, 50)
				ToggleConfig.Flag = ToggleConfig.Flag or nil
				ToggleConfig.Save = ToggleConfig.Save or false

				local Toggle = {Value = ToggleConfig.Default, Save = ToggleConfig.Save, Name = ToggleConfig.Name, Type = "Toggle"}

				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.fromScale(1, 1)
				})

				local ToggleBox = SetChildren(SetProps(MakeElement("RoundFrame", ToggleConfig.Color, 0, 4), {
					Size = UDim2.new(0, 24, 0, 24),
					Position = UDim2.new(1, -24, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
               BackgroundTransparency = WindowConfig.ElementsTransparency,
				}), {
					SetProps(MakeElement("Stroke"), {
						Color = ToggleConfig.Color,
						Name = "Stroke",
						Transparency = 0.5
					}),
					SetProps(MakeElement("Image", "rbxassetid://3944680095"), {
						Size = UDim2.new(0, 20, 0, 20),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						ImageColor3 = Color3.fromRGB(255, 255, 255),
						Name = "Ico"
					}),
				})

				local ToggleFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 38),
					Parent = ItemParent,
					BackgroundTransparency = WindowConfig.ElementsTransparency,
				}), {
					AddThemeObject(SetProps(MakeElement("Label", ToggleConfig.Name, 14), {
						Size = UDim2.new(1, -50, 1, 0),
						Position = UDim2.new(0, 12, 0, 0),
						Font = Enum.Font.GothamBold,
						Name = "Content",
						TextWrapped = true,
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					ToggleBox,
					Click
				}), "Elements")

				function Toggle:Set(Value)
					Toggle.Value = Value
					TweenService:Create(ToggleBox, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Toggle.Value and ToggleConfig.Color or OrionLib.Themes.Default.Divider}):Play()
					TweenService:Create(ToggleBox.Stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Color = Toggle.Value and ToggleConfig.Color or OrionLib.Themes.Default.Stroke}):Play()
					TweenService:Create(ToggleBox.Ico, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = Toggle.Value and 0 or 1, Size = Toggle.Value and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 8, 0, 8)}):Play()
					ToggleConfig.Callback(Toggle.Value)
				end    

				function Toggle:SetColor(Color)
					ToggleFrame.BackgroundColor3 = Color
				end

				function Toggle:SetTransparency(Transparency)
					ToggleFrame.BackgroundTransparency = Transparency
				end

				Toggle:Set(Toggle.Value)

				AddConnection(Click.MouseEnter, function()
					TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Elements.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.B * 255 + 3)}):Play()
				end)

				AddConnection(Click.MouseLeave, function()
					TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Elements}):Play()
				end)

				AddConnection(Click.MouseButton1Up, function()
					TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Elements.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.B * 255 + 3)}):Play()
					Toggle:Set(not Toggle.Value)
				end)

				AddConnection(Click.MouseButton1Down, function()
					TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Elements.R * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Elements.G * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Elements.B * 255 + 6)}):Play()
				end)

				if ToggleConfig.Flag then
					OrionLib.Flags[ToggleConfig.Flag] = Toggle
				end	
				return Toggle
			end  
			function ElementFunction:AddSlider(SliderConfig)
				SliderConfig = SliderConfig or {}
				SliderConfig.Name = SliderConfig.Name or "Slider"
				SliderConfig.Min = SliderConfig.Min or 0
				SliderConfig.Max = SliderConfig.Max or 100
				SliderConfig.Increment = SliderConfig.Increment or 1
				SliderConfig.Default = SliderConfig.Default or 50
				SliderConfig.Callback = SliderConfig.Callback or function() end
				SliderConfig.ValueName = SliderConfig.ValueName or ""
				SliderConfig.Color = SliderConfig.Color or Color3.fromRGB(50, 50, 50)
				SliderConfig.Flag = SliderConfig.Flag or nil
				SliderConfig.Save = SliderConfig.Save or false

				local Slider = {Value = SliderConfig.Default, Save = SliderConfig.Save, Name = SliderConfig.Name, Type = "Slider"}
				local Dragging = false

				local SliderDrag = SetChildren(SetProps(MakeElement("RoundFrame", SliderConfig.Color, 0, 5), {
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 0.3,
					ClipsDescendants = true
				}), {
					AddThemeObject(SetProps(MakeElement("Label", "value", 13), {
						Size = UDim2.new(1, -12, 0, 14),
						Position = UDim2.new(0, 12, 0, 6),
						Font = Enum.Font.GothamBold,
						Name = "Value",
						TextTransparency = 0,
					}), "Text")
				})

				local SliderBar = SetChildren(SetProps(MakeElement("RoundFrame", SliderConfig.Color, 0, 5), {
					Size = UDim2.new(1, -24, 0, 26),
					Position = UDim2.new(0, 12, 0, 30),
					BackgroundTransparency = 0.9
				}), {
					SetProps(MakeElement("Stroke"), {
						Color = SliderConfig.Color
					}),
					AddThemeObject(SetProps(MakeElement("Label", "value", 13), {
						Size = UDim2.new(1, -12, 0, 14),
						Position = UDim2.new(0, 12, 0, 6),
						Font = Enum.Font.GothamBold,
						Name = "Value",
						TextTransparency = 0.8
					}), "Text"),
					SliderDrag
				})

				local SliderFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
					Size = UDim2.new(1, 0, 0, 65),
					Parent = ItemParent,
					BackgroundTransparency = WindowConfig.ElementsTransparency,
				}), {
					AddThemeObject(SetProps(MakeElement("Label", SliderConfig.Name, 14), {
						Size = UDim2.new(1, -12, 0, 14),
						Position = UDim2.new(0, 12, 0, 10),
						Font = Enum.Font.GothamBold,
						Name = "Content",
						TextWrapped = true,
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					SliderBar
				}), "Elements")
				
				AddConnection(SliderFrame.Content:GetPropertyChangedSignal("Text"), function()
					SliderFrame.Content.Size = UDim2.new(1, -24, 0, SliderFrame.Content.TextBounds.Y)
					SliderFrame.Size = UDim2.new(1, 0, 0, SliderFrame.Content.TextBounds.Y + 35)
				end)

				SliderBar.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
						Dragging = true 
					end 
				end)
				SliderBar.InputEnded:Connect(function(Input) 
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
						Dragging = false 
					end 
				end)

				UserInputService.InputChanged:Connect(function(Input)
					if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then 
						local SizeScale = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
						Slider:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale)) 
					end
				end)

				function Slider:Set(Value)
					self.Value = math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)
					TweenService:Create(SliderDrag,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = UDim2.fromScale((self.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 1)}):Play()
					SliderBar.Value.Text = tostring(self.Value) .. " " .. SliderConfig.ValueName
					SliderDrag.Value.Text = tostring(self.Value) .. " " .. SliderConfig.ValueName
					SliderConfig.Callback(self.Value)
				end     
				
				function Slider:SetColor(Color)
					SliderFrame.BackgroundColor3 = Color
				end

				function Slider:SetTransparency(Transparency)
					SliderFrame.BackgroundTransparency = tonumber(Transparency)
				end

				Slider:Set(Slider.Value)
				if SliderConfig.Flag then OrionLib.Flags[SliderConfig.Flag] = Slider end
				return Slider
			end  
			function ElementFunction:AddDropdown(DropdownConfig)
				DropdownConfig = DropdownConfig or {}
				DropdownConfig.Name = DropdownConfig.Name or "Dropdown"
				DropdownConfig.Options = DropdownConfig.Options or {}
				DropdownConfig.Default = DropdownConfig.Default or ""
				DropdownConfig.Callback = DropdownConfig.Callback or function() end
				DropdownConfig.Flag = DropdownConfig.Flag or nil
				DropdownConfig.Save = DropdownConfig.Save or false

				local Dropdown = {Value = DropdownConfig.Default, Options = DropdownConfig.Options, Buttons = {}, Toggled = false, Type = "Dropdown", Save = DropdownConfig.Save, Name = DropdownConfig.Name}
				local MaxElements = 5

				if not table.find(Dropdown.Options, Dropdown.Value) then
					Dropdown.Value = "..."
				end

				local DropdownList = MakeElement("List")

				local DropdownContainer = AddThemeObject(SetProps(SetChildren(MakeElement("ScrollFrame", Color3.fromRGB(40, 40, 40)), {
					DropdownList
				}), {
					Parent = ItemParent,
					Position = UDim2.new(0, 0, 0, 38),
					Size = UDim2.new(1, 0, 1, -38),
					ClipsDescendants = true
				}), "Divider")

				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 1, 0)
				})

				local DropdownFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 38),
					Parent = ItemParent,
					ClipsDescendants = true,
					BackgroundTransparency = WindowConfig.ElementsTransparency,
				}), {
					DropdownContainer,
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", DropdownConfig.Name, 14), {
							Size = UDim2.new(1, -12, 1, 0),
							Position = UDim2.new(0, 12, 0, 0),
							Font = Enum.Font.GothamBold,
							Name = "Content"
						}), "Text"),
						AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072706796"), {
							Size = UDim2.new(0, 20, 0, 20),
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(1, -30, 0.5, 0),
							ImageColor3 = Color3.fromRGB(240, 240, 240),
							Name = "Ico"
						}), "TextDark"),
						AddThemeObject(SetProps(MakeElement("Frame"), {
							Size = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0, 0, 1, -1),
							Name = "Line",
							Visible = false
						}), "Stroke"), 
						Click
					}), {
						Size = UDim2.new(1, 0, 0, 38),
						ClipsDescendants = true,
						Name = "F"
					}),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					MakeElement("Corner")
				}), "Elements")

				AddConnection(DropdownList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, DropdownList.AbsoluteContentSize.Y)
				end)  

				local function AddOptions(Options)
					for _, Option in pairs(Options) do
						local OptionBtn = AddThemeObject(SetProps(SetChildren(MakeElement("Button", Color3.fromRGB(40, 40, 40)), {
							MakeElement("Corner", 0, 6),
							AddThemeObject(SetProps(MakeElement("Label", Option, 13, 0.4), {
								Position = UDim2.new(0, 4, 0, 0),
								Size = UDim2.new(1, -8, 1, 0),
								Name = "Title"
							}), "Text")
						}), {
							Parent = DropdownContainer,
							Size = UDim2.new(1, 0, 0, 28),
							BackgroundTransparency = 1,
							ClipsDescendants = true
						}), "Divider")

						AddConnection(OptionBtn.MouseButton1Click, function()
							Dropdown:Set(Option)
						end)

						Dropdown.Buttons[Option] = OptionBtn
					end
				end	

				function Dropdown:Refresh(Options, Delete)
					if Delete then
						pcall(function()
							for _,v in pairs(Dropdown.Buttons) do v:Destroy() end    
							table.clear(Dropdown.Options)
							table.clear(Dropdown.Buttons)
						end)
					end
					Dropdown.Options = Options
					AddOptions(Dropdown.Options)
				end  

				function Dropdown:Set(Value)
					if not table.find(Dropdown.Options, Value) then
						Dropdown.Value = "..."
						for _, v in pairs(Dropdown.Buttons) do
							TweenService:Create(v,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 1}):Play()
							TweenService:Create(v.Title,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0.4}):Play()
						end	
						return
					end

					Dropdown.Value = Value

					for _, v in pairs(Dropdown.Buttons) do
						TweenService:Create(v,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 1}):Play()
						TweenService:Create(v.Title,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0.4}):Play()
					end	
					TweenService:Create(Dropdown.Buttons[Value],TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 0}):Play()
					TweenService:Create(Dropdown.Buttons[Value].Title,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0}):Play()
					return DropdownConfig.Callback(Dropdown.Value)
				end

				AddConnection(Click.MouseButton1Click, function()
					Dropdown.Toggled = not Dropdown.Toggled
					DropdownFrame.F.Line.Visible = Dropdown.Toggled
					TweenService:Create(DropdownFrame.F.Ico,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = Dropdown.Toggled and 180 or 0}):Play()
					if #Dropdown.Options > MaxElements then
						TweenService:Create(DropdownFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = Dropdown.Toggled and UDim2.new(1, 0, 0, 38 + (MaxElements * 28)) or UDim2.new(1, 0, 0, 38)}):Play()
					else
						TweenService:Create(DropdownFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = Dropdown.Toggled and UDim2.new(1, 0, 0, DropdownList.AbsoluteContentSize.Y + 38) or UDim2.new(1, 0, 0, 38)}):Play()
					end
				end)

				Dropdown:Refresh(Dropdown.Options, false)
				Dropdown:Set(Dropdown.Value)
				if DropdownConfig.Flag then				
					OrionLib.Flags[DropdownConfig.Flag] = Dropdown
				end
				return Dropdown
			end
			function ElementFunction:AddBind(BindConfig)
				BindConfig.Name = BindConfig.Name or "Bind"
				BindConfig.Default = BindConfig.Default or Enum.KeyCode.Unknown
				BindConfig.Hold = BindConfig.Hold or false
				BindConfig.Callback = BindConfig.Callback or function() end
				BindConfig.Flag = BindConfig.Flag or nil
				BindConfig.Save = BindConfig.Save or false
				BindConfig.UIBind = BindConfig.UIBind or false

				if BindConfig.UIBind then
					WindowConfig.ToggleUIKey = BindConfig.Default
				end

				local Bind = {Value, Binding = false, Type = "Bind", Save = BindConfig.Save, Name = BindConfig.Name}
				local Holding = false

				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 1, 0)
				})

				local BindBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
					Size = UDim2.new(0, 24, 0, 24),
					Position = UDim2.new(1, -12, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundTransparency = WindowConfig.ElementsTransparency,
				}), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					AddThemeObject(SetProps(MakeElement("Label", BindConfig.Name, 14), {
						Size = UDim2.new(1, 0, 1, 0),
						Font = Enum.Font.GothamBold,
						TextXAlignment = Enum.TextXAlignment.Center,
						Name = "Value",
					}), "Text")
				}), "Main")

				local BindFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 38),
					Parent = ItemParent,
					BackgroundTransparency = WindowConfig.ElementsTransparency,
				}), {
					AddThemeObject(SetProps(MakeElement("Label", BindConfig.Name, 14), {
						Size = UDim2.new(1, -45, 1, 0),
						Position = UDim2.new(0, 12, 0, 0),
						Font = Enum.Font.GothamBold,
						Name = "Content",
						TextWrapped = true,
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					BindBox,
					Click
				}), "Elements")

				AddConnection(BindBox.Value:GetPropertyChangedSignal("Text"), function()
					TweenService:Create(BindBox, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, BindBox.Value.TextBounds.X + 16, 0, 24)}):Play()
				end)

				AddConnection(Click.InputEnded, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						if Bind.Binding then return end
						Bind.Binding = true
						BindBox.Value.Text = ""
					end
				end)

				AddConnection(UserInputService.InputBegan, function(Input)
					if UserInputService:GetFocusedTextBox() then return end
					if (Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value) and not Bind.Binding then
						if BindConfig.Hold then
							Holding = true
							BindConfig.Callback(Holding)
						else
							BindConfig.Callback()
						end
					elseif Bind.Binding then
						local Key
						pcall(function() if not CheckKey(BlacklistedKeys, Input.KeyCode) then Key = Input.KeyCode end end)
						pcall(function() if CheckKey(WhitelistedMouse, Input.UserInputType) and not Key then Key = Input.UserInputType end end)
						if Input.KeyCode == Enum.KeyCode.Backspace then
							Bind:Set("")
							return
						end
						Key = Key or Bind.Value
						Bind:Set(Key)
					end
				end)

				AddConnection(UserInputService.InputEnded, function(Input)
					if Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value then
						if BindConfig.Hold and Holding then
							Holding = false
							BindConfig.Callback(Holding)
						end
					end
				end)

				AddConnection(Click.MouseEnter, function()
					TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Elements.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.B * 255 + 3)}):Play()
				end)

				AddConnection(Click.MouseLeave, function()
					TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Elements}):Play()
				end)

				AddConnection(Click.MouseButton1Up, function()
					TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Elements.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.B * 255 + 3)}):Play()
				end)

				AddConnection(Click.MouseButton1Down, function()
					TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Elements.R * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Elements.G * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Elements.B * 255 + 6)}):Play()
				end)

				function Bind:Set(Key)
					Bind.Binding = false
					Bind.Value = Key or Bind.Value
					Bind.Value = Bind.Value.Name or Bind.Value
					BindBox.Value.Text = Bind.Value

					if BindConfig.UIBind then
						WindowConfig.ToggleUIKey = Bind.Value
					end
				end

				function Bind:SetColor(Color)
					BindFrame.BackgroundColor3 = Color
				end

				function Bind:SetTransparency(Transparency)
					BindFrame.BackgroundTransparency = Transparency
				end

				Bind:Set(BindConfig.Default)
				if BindConfig.Flag then				
					OrionLib.Flags[BindConfig.Flag] = Bind
				end
				return Bind
			end  
			function ElementFunction:AddTextbox(TextboxConfig)
				TextboxConfig = TextboxConfig or {}
				TextboxConfig.Name = TextboxConfig.Name or "Textbox"
				TextboxConfig.Default = TextboxConfig.Default or ""
				TextboxConfig.TextDisappear = TextboxConfig.TextDisappear or false
				TextboxConfig.Callback = TextboxConfig.Callback or function() end

				local Textbox = {Value, Type = "Textbox", Name = TextboxConfig.Name}

				local Click = SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1
				})

				local TextboxActual = AddThemeObject(Create("TextBox", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					PlaceholderColor3 = Color3.fromRGB(210,210,210),
					PlaceholderText = "Input",
					Font = Enum.Font.GothamSemibold,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextSize = 14,
					ClearTextOnFocus = false
				}), "Text")

				local TextContainer = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
					Size = UDim2.new(0, 24, 0, 24),
					Position = UDim2.new(1, -12, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundTransparency = WindowConfig.ElementsTransparency
				}), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					TextboxActual
				}), "Main")

				local TextboxFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 38),
					Parent = ItemParent,
					BackgroundTransparency = WindowConfig.ElementsTransparency,
				}), {
					AddThemeObject(SetProps(MakeElement("Label", TextboxConfig.Name, 14), {
						Size = UDim2.new(1, -12, 1, 0),
						Position = UDim2.new(0, 12, 0, 0),
						Font = Enum.Font.GothamBold,
						Name = "Content",
						TextWrapped = true,
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					TextContainer,
					Click
				}), "Elements")

				AddConnection(TextboxActual:GetPropertyChangedSignal("Text"), function()
					TweenService:Create(TextContainer, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, TextboxActual.TextBounds.X + 16, 0, 24)}):Play()
				end)

				AddConnection(TextboxActual.FocusLost, function()
					TextboxConfig.Callback(TextboxActual.Text)
					if TextboxConfig.TextDisappear then TextboxActual.Text = "" end	
				end)

				function Textbox:Set(Text)
					TextboxActual.Text = Text
				end

				function Textbox:SetColor(Color)
					TextboxFrame.BackgroundColor3 = Color
				end

				function Textbox:SetTransparency(Transparency)
					TextboxFrame.BackgroundTransparency = Transparency
				end

				TextboxActual.Text = TextboxConfig.Default

				AddConnection(Click.MouseEnter, function()
					TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Elements.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.B * 255 + 3)}):Play()
				end)

				AddConnection(Click.MouseLeave, function()
					TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Elements}):Play()
				end)

				AddConnection(Click.MouseButton1Up, function()
					TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Elements.R * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.G * 255 + 3, OrionLib.Themes[OrionLib.SelectedTheme].Elements.B * 255 + 3)}):Play()
					TextboxActual:CaptureFocus()
				end)

				AddConnection(Click.MouseButton1Down, function()
					TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Elements.R * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Elements.G * 255 + 6, OrionLib.Themes[OrionLib.SelectedTheme].Elements.B * 255 + 6)}):Play()
				end)
			end 
			function ElementFunction:AddColorpicker(ColorpickerConfig)
				ColorpickerConfig = ColorpickerConfig or {}
				ColorpickerConfig.Name = ColorpickerConfig.Name or "Colorpicker"
				ColorpickerConfig.Default = ColorpickerConfig.Default or Color3.fromRGB(255,255,255)
				ColorpickerConfig.Callback = ColorpickerConfig.Callback or function() end
				ColorpickerConfig.Flag = ColorpickerConfig.Flag or nil
				ColorpickerConfig.Save = ColorpickerConfig.Save or false

				local ColorH, ColorS, ColorV = 1, 1, 1
				local Colorpicker = {Value = ColorpickerConfig.Default, Toggled = false, Type = "Colorpicker", Save = ColorpickerConfig.Save}

				local ColorSelection = Create("ImageLabel", {
					Size = UDim2.new(0, 18, 0, 18),
					Position = UDim2.new(select(3, Color3.toHSV(Colorpicker.Value))),
					ScaleType = Enum.ScaleType.Fit,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = "http://www.roblox.com/asset/?id=4805639000"
				})

				local HueSelection = Create("ImageLabel", {
					Size = UDim2.new(0, 18, 0, 18),
					Position = UDim2.new(0.5, 0, 1 - select(1, Color3.toHSV(Colorpicker.Value))),
					ScaleType = Enum.ScaleType.Fit,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = "http://www.roblox.com/asset/?id=4805639000"
				})

				local Color = Create("ImageLabel", {
					Size = UDim2.new(1, -25, 1, 0),
					Visible = false,
					Image = "rbxassetid://4155801252"
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
					ColorSelection
				})

				local Hue = Create("Frame", {
					Size = UDim2.new(0, 20, 1, 0),
					Position = UDim2.new(1, -20, 0, 0),
					Visible = false
				}, {
					Create("UIGradient", {Rotation = 270, Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))},}),
					Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
					HueSelection
				})

				local ColorpickerContainer = Create("Frame", {
					Position = UDim2.new(0, -10, 0, 32),
					Size = UDim2.new(1.1, 0, 1, -32),
					BackgroundTransparency = 1,
					ClipsDescendants = true
				}, {
					Hue,
					Color,
					Create("UIPadding", {
						PaddingLeft = UDim.new(0, 35),
						PaddingRight = UDim.new(0, 35),
						PaddingBottom = UDim.new(0, 10),
						PaddingTop = UDim.new(0, 17)
					})
				})

				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				local ColorpickerBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
					Size = UDim2.new(0, 24, 0, 24),
					Position = UDim2.new(1, -12, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5)
				}), {
					AddThemeObject(MakeElement("Stroke"), "Stroke")
				}), "Main")

				local ColorpickerFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 38),
					Parent = ItemParent,
               BackgroundTransparency = WindowConfig.ElementsTransparency,
				}), {
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", ColorpickerConfig.Name, 15), {
							Size = UDim2.new(1, 0, 0, 38),
							Position = UDim2.new(0, 12, 0, 0),
							Font = Enum.Font.GothamBold,
							Name = "Content",
							TextWrapped = true,
						}), "Text"),
						ColorpickerBox,
						Click,
						AddThemeObject(SetProps(MakeElement("Frame"), {
							Size = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0, 0, 1, -1),
							Name = "Line",
							Visible = false
						}), "Stroke"), 
					}), {
						Size = UDim2.new(1, 0, 0, 38),
						ClipsDescendants = true,
						Name = "F"
					}),
					ColorpickerContainer,
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
				}), "Elements")

				AddConnection(Click.MouseButton1Click, function()
					Colorpicker.Toggled = not Colorpicker.Toggled
					TweenService:Create(ColorpickerFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = Colorpicker.Toggled and UDim2.new(1, 0, 0, 148) or UDim2.new(1, 0, 0, 38)}):Play()
					Color.Visible = Colorpicker.Toggled
					Hue.Visible = Colorpicker.Toggled
					ColorpickerFrame.F.Line.Visible = Colorpicker.Toggled
				end)

				local function UpdateColorPicker()
					ColorpickerBox.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
					Colorpicker:Set(ColorpickerBox.BackgroundColor3)
					ColorpickerConfig.Callback(ColorpickerBox.BackgroundColor3)
				end

				ColorH = 0.49 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
				ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, 0.49) / Color.AbsoluteSize.X)
				ColorV = 0.49 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)

				AddConnection(Color.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						if ColorInput then ColorInput:Disconnect() end
						ColorInput = AddConnection(RunService.RenderStepped, function()
							local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
							local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
							ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
							ColorS = ColorX
							ColorV = 1 - ColorY
							UpdateColorPicker()
						end)
					end
				end)

				AddConnection(Color.InputEnded, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						if ColorInput then ColorInput:Disconnect() end
					end
				end)

				AddConnection(Hue.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						if HueInput then HueInput:Disconnect() end

						HueInput = AddConnection(RunService.RenderStepped, function()
							local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)

							HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
							ColorH = 1 - HueY

							UpdateColorPicker()
						end)
					end
				end)

				AddConnection(Hue.InputEnded, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						if HueInput then HueInput:Disconnect() end
					end
				end)

				function Colorpicker:Set(Value)
					Colorpicker.Value = Value
					ColorpickerBox.BackgroundColor3 = Colorpicker.Value
					ColorpickerConfig.Callback(Colorpicker.Value)
				end

				function Colorpicker:SetColor(Color)
					ColorpickerFrame.BackgroundColor3 = Color
				end

				function Colorpicker:SetTransparency(Transparency)
					ColorpickerFrame.BackgroundTransparency = Transparency
				end

				Colorpicker:Set(Colorpicker.Value)
				if ColorpickerConfig.Flag then OrionLib.Flags[ColorpickerConfig.Flag] = Colorpicker end
				return Colorpicker
			end  
			return ElementFunction   
		end	

		local ElementFunction = {}

		function ElementFunction:AddSection(SectionConfig)
			SectionConfig.Name = SectionConfig.Name or "Section"
         SectionConfig.Side = SectionConfig.Side or "Left"  

         local ContainerSection = (SectionConfig.Side == "Left") and ContainerLeft or ContainerRight

			local SectionFrame = SetChildren(SetProps(MakeElement("TFrame"), {
				Size = UDim2.new(1, 0, 0, 10),
				Parent = ContainerSection
			}), {
				AddThemeObject(SetProps(MakeElement("Label", SectionConfig.Name, 14), {
					Size = UDim2.new(1, -12, 0, 20),
					Position = UDim2.new(0, 0, 0, -20),
					Font = Enum.Font.GothamSemibold
				}), "Text"),
				SetChildren(SetProps(MakeElement("TFrame"), {
					AnchorPoint = Vector2.new(0, 0),
					Size = UDim2.new(0.5, 0, 1, 0),
					Position = UDim2.new(0, 0, 0, 5),
					Name = "Holder"
				}), {
					MakeElement("List", 0, 6)
				}),
			})

			AddConnection(SectionFrame.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y + 31)
				SectionFrame.Holder.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y)
			end)

			local SectionFunction = {}
			for i, v in next, GetElements(SectionFrame.Holder) do SectionFunction[i] = v end
			return SectionFunction
		end	

		for i, v in next, GetElements(ContainerSection) do ElementFunction[i] = v end
		return ElementFunction   
	end  
	return TabFunction
end   

function OrionLib:Destroy()
	Orion:Destroy()
end

return OrionLib
