-- Load BetterOrion --
	local BetterOrion = loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/BetterOrion/refs/heads/main/Library.lua"))() -- Load BetterOrion library

-- Elements list --
	local Elm = {
		Tabs =  {},
		Sect = {}
	}

-- Window creation
	Elm.Window = BetterOrion:MakeWindow({ 
		Name = "BetterOrion",
		SubName = "v0.0.1 Example", 
		SubNameSide = "Center",
		
		IntroEnabled = false, 
		IntroIcon = "accessibility", 
		IntroText = "BetterOrion,\nWelcome!", 
		
		Size = UDim2.new(0, 500, 0, 350),
		MinSize = UDim2.new(0, 500, 0, 200),
		MaxSize = UDim2.new(0, 9999, 0, 9999),
		
		Theme = "Default",
		Transparency = 0.35,
		ElementsTransparency = 0.5,
		
		ToggleUIKey = Enum.KeyCode.Tab
	})

-- Tabs creation
	Elm.Tabs.SomeTab = Elm.Window:MakeTab({Name = "Tab", Icon = "person"})

-- Universal tab
	Elm.Sect.SomeSection = Elm.Tabs.SomeTab:AddSection({Name = "Left section", Side = "Left"})
	Elm.Sect.SomeSection2 = Elm.Tabs.SomeTab:AddSection({Name = "Right section", Side = "Right"})

	Elm.Sect.SomeSection:AddToggle({
		Name = "Toggle",
		Default = false,
		Flag = "SomeToggle",
		Callback = function(bool)
			print(bool)
		end
	})

	Elm.Sect.SomeSection:AddSlider({
		Name = "Slider",
		Default = 123,
		Min = 0,
		Max = 500,
		Increment = 2,
		ValueName = "Speed",
		Flag = "SomeSlider",
		Callback = function(value)
			print(value)
		end
	})

	Elm.Sect.SomeSection:AddButton({
		Name = "Button",
		Callback = function()
			print("pressed double tap")
		end
	})

	Elm.Sect.SomeSection2:AddToggle({
		Name = "Binded toggle",
		Default = false,
		Flag = "SomeBindedToggle",
		Binded = true,
		DefaultBind = "",
		Callback = function(bool)
			print(bool)
		end
	})

	Elm.Sect.SomeSection2:AddButton({
		Name = "Double-tap button",
		DoubleTap = true,
		Callback = function()
			print("pressed single tap")
		end
	})

	Elm.Sect.SomeSection2:AddBind({
		Name = "Bind",
		Callback = function()
			print("Bind pressed")
		end
	})
