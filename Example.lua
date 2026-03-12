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

		ShowIcon = true,
		Icon = "heart",
		
		IntroEnabled = false, 
		IntroIcon = "accessibility", 
		IntroText = "BetterOrion,\nWelcome!", 
		
		Size = UDim2.new(0, 500, 0, 350),
		MinSize = UDim2.new(0, 500, 0, 200),
		MaxSize = UDim2.new(0, 9999, 0, 9999),
		
		Theme = "Default",
		Transparency = 0.35,
		ElementsTransparency = 0.5,
		SearchBar = true,
		
		ToggleUIKey = Enum.KeyCode.Tab
	})

-- Tabs creation
	Elm.Tabs.SomeTab = Elm.Window:MakeTab({Name = "Tab", Icon = "person"})
	Elm.Tabs.SomeTab2 = Elm.Window:MakeTab({Name = "Tab2", Icon = "person"})

-- Universal tab
	Elm.Sect.SomeSection = Elm.Tabs.SomeTab:AddSection({Name = "Left section", Side = "Left"})
	Elm.Sect.SomeSection2 = Elm.Tabs.SomeTab:AddSection({Name = "Right section", Side = "Right"})
	Elm.Sect.SomeSection3 = Elm.Tabs.SomeTab2:AddSection({Name = "Left section", Side = "Left"})
	Elm.Sect.SomeSection4 = Elm.Tabs.SomeTab2:AddSection({Name = "Right section", Side = "Right"})

	Elm.Sect.SomeSection:AddToggle({
		Name = "Toggle",
		Default = false,
		Callback = function(bool)
			print(bool)
		end
	})

	local lastprint = tick()
	local a = Elm.Sect.SomeSection:AddSlider({
		Name = "Slider",
		Default = 0,
		Min = -10,
		Max = 10,
		Increment = 0.2,
		ValueName = "Speed",
		Callback = function(value)
			if tick() - lastprint >= 0.1 then
				--print(value)
				lastprint = tick()
			end
		end,
		InputEndedCallback = function(value)
			--print("Input ended at:", value)
		end
	})
	a:Set(123123)

	Elm.Sect.SomeSection:AddButton({
		Name = "Button",
		Callback = function()
			print("pressed single tap")
		end
	})

	Elm.Sect.SomeSection:AddBind({
		Name = "Bind",
		Callback = function()
			print("Bind pressed")
		end
	})

	Elm.Sect.SomeSection2:AddToggle({
		Name = "Binded toggle",
		Default = false,
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
			print("pressed double tap")
		end
	})

	Elm.Sect.SomeSection2:AddBind({
		Name = "Button bind",
		Button = true,
		Callback = function()
			print("Button bind pressed")
		end
	})

	Elm.Sect.SomeSection2:AddBind({
		Name = "Double-tap button bind",
		Button = true,
		DoubleTap = true,
		Callback = function()
			print("Double tap button bind pressed")
		end
	})

	Elm.Sect.SomeSection3:AddBind({
		Name = "test",
		Button = true,
		DoubleTap = false,
		Callback = function()
			BetterOrion:MakeNotification({
				Title = "Test notification",
				Content = "123123213",
				Image = "activity",
				Color = Color3.fromRGB(20, 20, 20),
				Time = 2,
				Sound = "rbxassetid://96867813755421"
			})
		end
	})

	Elm.Sect.SomeSection3:AddTextbox({
		Name = "Some textbox",
		Default = "",
		TextDisappear = false,
		Callback = function(text)
			print(text)
		end	  
	})

	Elm.Sect.SomeSection4:AddDropdown({
		Name = "Test dropdown",
		Options = {"a", "b"},
		MaxSize = 5,
		Multi = false,
		Callback = function(options)
			if options == "a" then
				BetterOrion:SetNotifyingState({
					Enabled = true,
					Printing = true,
				})
			else
				BetterOrion:SetNotifyingState({
					Enabled = false,
					Printing = true,
				})
			end
		end
	})

	Elm.Sect.SomeSection4:AddColorpicker({
		Name = "Test colorpicker",
		InputEndedCallback = function(color)
			print(color)
		end
	})
