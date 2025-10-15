-- Load BetterOrion --
local BetterOrion = loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/BetterOrion/refs/heads/main/Library.lua"))() -- Load BetterOrion library

-- Elements list --
local Elm = {
	Tabs =  {},
	Sect = {}
}

-- Services
local Serv = {
  	Players = game:GetService("Players"),
	RunS = game:GetService("RunService"),
	UserInputS = game:GetService("UserInputService"),

	Camera = workspace.CurrentCamera,
}
local Me = Serv.Players.LocalPlayer

-- System lists --
local Values = {
	WalkSpeed = 16, JumpPower = 50, Gravity = 196.2,
	FlySpeed = 2,
}

local Tgls = {}
local Conns = {}

-- Functions --
local Func = {}

Func.AddConn = function(Path, Name, Func)
  	Conns[Name] = Path:Connect(Func)
end

Func.RemoveConn = function(Conn)
	if Conns[Conn] ~= nil then
		Conns[Conn]:Disconnect()
		Conns[Conn] = nil
	end
end

Func.AddOrientation = function(Name, Part, Orientation)
	local AlignOrientation = Part:FindFirstChild(Name) or Instance.new("AlignOrientation", Part)
	AlignOrientation.Name = Name
	AlignOrientation.CFrame = Orientation

	AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	AlignOrientation.Responsiveness = 200

	AlignOrientation.MaxAngularVelocity = math.huge
	AlignOrientation.MaxTorque = math.huge

	AlignOrientation.Attachment0 = Part:FindFirstChild("AlignOrientationAttachment") or Instance.new("Attachment", Part)
	AlignOrientation.Attachment0.Name = "AlignOrientationAttachment"

	return AlignOrientation
end

Func.FindWaitChild = function(Parent, Child) return Parent:FindFirstChild(Child) or Parent:WaitForChild(Child, 3) end
Func.GetChar = function(Plr) return Plr.Character or Plr.CharacterAdded:Wait() end
Func.GetHum = function(Char) return Func.FindWaitChild(Char, "Humanoid") end
Func.GetRoot = function(Char) return Func.FindWaitChild(Char, "HumanoidRootPart") end

-- Window creation -- 
Elm.Window = BetterOrion:MakeWindow({ 
	Name = "BetterOrion",
	SubName = "v0.0.1 alpha beta omega delta", 
	SubNameSide = "Center",
	
	IntroEnabled = true, 
	IntroIcon = "accessibility", 
	IntroText = "BetterOrion,\nWelcome!", 
	
	Size = UDim2.fromOffset(600, 400),
	MinSize = UDim2.fromOffset(600, 200),
	MaxSize = UDim2.fromOffset(4000, 2000),
	
	Theme = "Default",
	Transparency = 0.35,
	ElementsTransparency = 0.5,
	
	ToggleUIKey = Enum.KeyCode.Tab
})

-- Tabs creation -- 
Elm.Tabs.Universal = Elm.Window:MakeTab({Name = "Universal", Icon = ""})
Elm.Tabs.Settings = Elm.Window:MakeTab({Name = "Settings", Icon = ""})
Elm.Tabs.Confiuration = Elm.Window:MakeTab({Name = "Config", Icon = ""})

-- Universal tab -- 
Elm.Sect.WalkSpeed = Elm.Tabs.Universal:AddSection({Name = "Walk Speed", Side = "Left"})
Elm.Sect.JumpPower = Elm.Tabs.Universal:AddSection({Name = "Jump Power", Side = "Left"})
Elm.Sect.Gravity = Elm.Tabs.Universal:AddSection({Name = "Gravity", Side = "Right"})
Elm.Sect.Movement = Elm.Tabs.Universal:AddSection({Name = "Advanced movement", Side = "Right"})

Elm.Sect.WalkSpeed:AddToggle({
	Name = "Change WalkSpeed",
	Default = false,
	Flag = "WalkSpeedToggle",
	Callback = function(bool)
		Tgls.WalkSpeedEnabled = bool

		local Char = Func.GetChar(Me)
		local Hum = Char and Func.GetHum(Char)
		
		if Tgls.WalkSpeedEnabled and Hum then
			Hum.WalkSpeed = Values.WalkSpeed
		elseif Hum then
			Hum.WalkSpeed = 16
		end
	end
})

Elm.Sect.WalkSpeed:AddSlider({
	Name = "WalkSpeed",
	Default = Values.WalkSpeed,
	Min = 0,
	Max = 500,
	Increment = 2,
	ValueName = "Speed",
	Flag = "WalkSpeedSlider",
	Callback = function(value)
		local Char = Func.GetChar(Me)
		local Hum = Char and Func.GetHum(Char)

		Values.WalkSpeed = value

		if Tgls.WalkSpeedEnabled and Hum then
			Hum.WalkSpeed = Values.WalkSpeed
		end
	end
})

Elm.Sect.WalkSpeed:AddButton({
	Name = "Reset Walkspeed",
	DoubleTap = true,
	Callback = function()
		BetterOrion.Flags["WalkSpeedSlider"]:Set(16)
	end
})

Elm.Sect.JumpPower:AddToggle({
	Name = "Change JumpPower",
	Default = false,
	Flag = "JumpPowerToggle",
	Callback = function(bool)
		Tgls.JumpPowerEnabled = bool

		local Char = Func.GetChar(Me)
		local Hum = Char and Func.GetHum(Char)
		
		if Tgls.JumpPowerEnabled and Hum then
			Hum.JumpPower = Values.JumpPower
		elseif Hum then
			Hum.JumpPower = 50
		end
	end
})

Elm.Sect.JumpPower:AddSlider({
	Name = "JumpPower",
	Default = Values.JumpPower,
	Min = 0,
	Max = 600,
	Increment = 2,
	ValueName = "Power",
	Flag = "JumpPowerSlider",
	Callback = function(value)
		local Char = Func.GetChar(Me)
		local Hum = Char and Func.GetHum(Char)

		Values.JumpPower = value

		if Tgls.JumpPowerEnabled and Hum then
			Hum.JumpPower = Values.JumpPower
		end
	end
})

Elm.Sect.JumpPower:AddButton({
	Name = "Reset JumpPower",
	DoubleTap = true,
	Callback = function()
		BetterOrion.Flags["JumpPowerSlider"]:Set(50)
	end
})

Elm.Sect.Gravity:AddToggle({
	Name = "Change Gravity",
	Default = false,
	Flag = "GravityToggle",
	Callback = function(bool)
		Tgls.GravityEnabled = bool
		workspace.Gravity = Tgls.GravityEnabled and Values.Gravity or 196.2
	end
})

Elm.Sect.Gravity:AddSlider({
	Name = "Gravity",
	Default = Values.Gravity,
	Min = 0,
	Max = 1000,
	Increment = 2,
	ValueName = "Gravity",
	Flag = "GravitySlider",
	Callback = function(value)
		Values.Gravity = value
		workspace.Gravity = Tgls.GravityEnabled and Values.Gravity or 196.2
	end
})

Elm.Sect.Gravity:AddButton({
	Name = "Reset Gravity",
	DoubleTap = true,
	Callback = function()
		BetterOrion.Flags["GravitySlider"]:Set(196.2)
	end
})

Elm.Sect.Movement:AddToggle({
	Name = "Fly",
	Default = false,
	Flag = "FlyToggle",
	Callback = function(bool)
		Tgls.FlyEnabled = bool

		local Char = Func.GetChar(Me)
		local Hum = Char and Func.GetHum(Char)
		local Root = Char and Func.GetRoot(Char)
		
		if Tgls.FlyEnabled and Root then
			workspace.Gravity = 0
			local Orient = Func.AddOrientation("FlyOrientation", Root, Serv.Camera.CFrame)

			Func.AddConn(Serv.RunS.Heartbeat, "FlyConn", function()
				Char = Func.GetChar(Me)
				Root = Char and Func.GetRoot(Char)
				Hum = Char and Func.GetHum(Char)

				if Serv.UserInputS:GetFocusedTextBox() then return end
				if Root and Hum then
					if Serv.UserInputS:IsKeyDown(Enum.KeyCode.W) then Root.CFrame *= CFrame.new(0, 0, -Values.FlySpeed) end
					if Serv.UserInputS:IsKeyDown(Enum.KeyCode.S) then Root.CFrame *= CFrame.new(0, 0, Values.FlySpeed) end
					if Serv.UserInputS:IsKeyDown(Enum.KeyCode.A) then Root.CFrame *= CFrame.new(-Values.FlySpeed, 0, 0) end
					if Serv.UserInputS:IsKeyDown(Enum.KeyCode.D) then Root.CFrame *= CFrame.new(Values.FlySpeed, 0, 0) end
					if Serv.UserInputS:IsKeyDown(Enum.KeyCode.E) then Root.CFrame *= CFrame.new(0, Values.FlySpeed, 0) end
					if Serv.UserInputS:IsKeyDown(Enum.KeyCode.Q) then Root.CFrame *= CFrame.new(0, -Values.FlySpeed, 0) end
					
					if Hum.PlatformStand then
						Hum:ChangeState("GettingUp")
					end
					
					Root.Velocity = Vector3.zero
					Orient.CFrame = Serv.Camera.CFrame
				end
			end)
		else
			Func.RemoveConn("FlyConn")
			workspace.Gravity = Tgls.GravityEnabled and Values.Gravity or 196.2
		
			if Root and Hum then
				Root.Velocity = Vector3.zero

				if Root:FindFirstChild("FlyOrientation") then
					Root:FindFirstChild("FlyOrientation"):Destroy()
					Root:FindFirstChild("AlignOrientationAttachment"):Destroy()
				end
				if Hum.PlatformStand then
					Hum:ChangeState("GettingUp")
				end
			end
		end
	end
})

Elm.Sect.Movement:AddBind({
	Name = "Toggle fly",
	Default = "",
	Flag = "ToggleFlyBind",
	Hold = false,
	Callback = function()
		Tgls.FlyEnabled = not Tgls.FlyEnabled
		BetterOrion.Flags["FlyToggle"]:Set(Tgls.FlyEnabled)
	end
})


-- Game connectons --
Func.AddConn(Me.CharacterAdded, "CharacterAddedConn", function(Char)
	local Hum = Char and Func.GetHum(Char)

	if Tgls.WalkSpeedEnabled and Hum then
		Hum.WalkSpeed = Values.WalkSpeed
	end
	if Tgls.JumpPowerEnabled and Hum then
		Hum.JumpPower = Values.JumpPower
	end
end)
