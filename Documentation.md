# Load library
```lua
local BetterOrion = loadstring(game:HttpGet("https://gitlab.com/m1kp0/BetterOrion/raw/main/Library.lua"))()
```

# Important
#### 1. DO NOT ADD UI ELEMENTS TO TABS, ADD THEM TO SECTIONS
#### 2. Example script
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/BetterOrion/refs/heads/main/Example.lua"))()
```

#### 3. All properties are optional, so you can do this:
```lua
local BetterOrion = loadstring(game:HttpGet("https://gitlab.com/m1kp0/BetterOrion/raw/main/Library.lua"))()
local Window = BetterOrion:MakeWindow()
local Tab = Window:MakeTab()
local Section = Tab:AddSection()
Section:AddToggle()
Section:AddButton()
Section:AddSlider()
Section:AddDropdown()
Section:AddColorpicker()
Section:AddTextbox()
Section:AddBind()
Section:AddLabel()
Section:AddParagraph()
BetterOrion:MakeNotification()
```

# Window
### Make Window
```lua
BetterOrion:MakeWindow()
```

##### Example:
```lua
local Window = BetterOrion:MakeWindow({
    Name = "My hub",
    SubName = "v0.0.1 Example", 
    IntroEnabled = true, 
    IntroIcon = "hand", 
    IntroText = "My Hub,\nWelcome!", 
    Size = UDim2.new(0, 500, 0, 350),
    MinSize = UDim2.new(0, 500, 0, 200),
    MaxSize = UDim2.new(0, 9999, 0, 9999),
    Transparency = 0.35,
    ToggleUIKey = Enum.KeyCode.Tab,
    SearchBar = true,
    WatermarkConfig = {
        Enabled = true,
        Visible = true,
        ShowFPS = true,
        ShowPing = true,
        ShowName = true,
        ShowClockTime = true,
        Icon = "activity"
    }
})
```

##### Window Configuration         
| Property | Value Type | Default |
|----------|------|---------|
| Name? | string | "Better Orion" |
| SubName? | string | "" |
| IntroEnabled? | bool | false |
| IntroIcon? | string | ""
| IntroText? | string | "Better Orion" |
| Size? | UDim2 | UDim2.fromOffset(600, 400) |
| MinSize? | UDim2 | UDim2.fromOffset(400, 200) |
| MaxSize? | UDim2 | UDim2.fromOffset(4000, 2000) |
| Theme? | string | "Default" |
| ShowIcon? | bool | false |
| Icon? | string | "" |
| Transparency? | number | 0.35 |
| ElementsTransparency? | number | 0.5 |
| ToggleUIKey? | Enum | Enum.KeyCode.Tab |
| SearchBar? | bool or table | false |
| WatermarkConfig? | table | {} |

##### WatermarkConfig Configuration
| Property | Value Type | Default |
|----------|------|---------|
| Enabled? | bool | false |
| Visible? | bool | false |
| ShowFPS? | bool | false |
| ShowPing? | bool | false |
| ShowName? | bool | false |
| ShowClockTime? | bool | false |
| Icon? | string | "" |

##### Window Settings Functions
| Function | Args | Type |
|----------|------|------|
| SetSize | Size | UDim2 |
| SetColor | Color | Color3 |
| SetIconColor | Color | Color3 |
| SetStrokeColor | Color | Color3 |
| SetTextColor | Color | Color3 |
| SetTextTransparency | Transparency | number |
| SetTransparency | Transparency | number |
| SetStrokeTransparency | Transparency | number |
| SetToggleKey | Key | Enum |
| SetThemeColor | Theme, Element, Color | string, string, Color3 |
| SetThemeTransparency | Theme, Element, Transparency | string, string, number |
| SetMainCorners | Offset | number |
| SetElementsCorners | Offset | number |
| SetBackground | URL | string |
| SetBackgroundTransparency | Transparency | number |
| SetBackgroundVisibility | Bool | bool |
| NewUI | Bool | bool |
| SetWatermarkVisibility | Bool | bool |
| SetWatermarkText | Text | string |
| SetWatermarkColor | Color | Color3 |
| SetWatermarkTextColor | Color | Color3 |
| SetWatermarkIconColor | Color | Color3 |
| SetWatermarkTransparency | Transparency | number |
| SetWatermarkPosition | Position | UDim2 |
| DestroyWatermark | - | - |
| DestroyElement | Flag | string |

### Make Tab
```lua
Window:MakeTab()
```

##### Example:
```lua
local Tab = Window:MakeTab({Name = "MyTab", Icon = "person"})
```

##### Tab Configuration         
| Property | Value Type | Default |
|----------|------|---------|
| Name? | string | "Tab" |
| Icon? | string | "" |

### Add Section
```lua
Tab:AddSection()
```

##### Example:
```lua
local Section = Tab:AddSection({Name = "Main", Side = "Left"})
```

##### Section Configuration
| Property | Value Type | Default | Possible Values |
|----------|------|---------|-----------------------|
| Name | string | "Tab" | Any |
| Side? | string | "Left" | "Left", "Right" |

### Add Toggle
```lua
Section:AddToggle()
```

##### Example:
```lua
Section:AddToggle({
    Name = "Toggle",
    Default = false,  
    Color = Color3.fromRGB(40, 40, 40), 
    Flag = "Toggle1",
    Binded = true,
    DefaultBind = "Q",
    Settings = false,
    Callback = function(bool) 
        print(bool)
    end
})
```

##### Settings example:
```lua
local Toggle = Section:AddToggle({
    Name = "Toggle with settings",
    Settings = true
})

Toggle:AddButton({Name = "Button in toggle settings"})
Toggle:AddSlider({Name = "Slider in toggle settings"})
```

##### Toggle Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Toggle" |
| Default? | bool | false |
| Color? | Color3 | Color3.fromRGB(50, 50, 50) |
| Flag? | string | nil |
| Binded? | bool | false |
| DefaultBind? | string | "" |
| Settings? | bool | false |
| Callback? | function | function() end |

##### Toggle Functions
| Function | Args | Type |
|----------|------|------|
| Set | Value | bool |
| SetName | Text | string |
| SetColor | Color | Color3 |
| SetTextColor | Color | Color3 |
| SetTextTransparency | Transparency | number |
| SetStrokeColor | Color | Color3 |
| SetStrokeTransparency | Transparency | number |
| SetTransparency | Transparency | number |
| SetBind | Key | string |
| ChangeVisibility | Bool | bool |

### Add Button
```lua
Section:AddButton()
```

##### Example:
```lua
Section:AddButton({
    Name = "Button",
    Icon = "rbxassetid://3944703587",
    DoubleTap = true,
    TapDelay = 0.5,
    Callback = function() 
        print("Button Pressed")
    end
})
```

##### Button Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Button" |
| Icon? | string | "rbxassetid://3944703587" |
| DoubleTap? | bool | false |
| TapDelay? | number | 0.5 |
| Settings? | table | false |
| Callback? | function | function() end |

##### Button Functions
| Function | Args | Type |
|----------|------|------|
| Set | Text | string |
| SetColor | Color | Color3 |
| SetTextColor | Color | Color3 |
| SetTextTransparency | Transparency | number |
| SetStrokeColor | Color | Color3 |
| SetStrokeTransparency | Transparency | number |
| SetTransparency | Transparency | number |

### Add Slider
```lua
Section:AddSlider()
```

##### Example:
```lua
Section:AddSlider({
    Name = "Slider",
    Default = 100,
    Min = 0,
    Max = 500,
    Increment = 2,
    ValueName = "Value",
    Color = Color3.fromRGB(50, 50, 50),
    Flag = "Slider1",
    Callback = function(value)
        print(value)
    end,
    InputEndedCallback = function(value)
        print("Input ended at:", value)
    end
})
```

##### Slider Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Slider" |
| Min? | number | 0 |
| Max? | number | 100 |
| Increment? | number | 1 |
| Default? | number | 50 |
| ValueName? | string | "" |
| Color? | Color3 | Color3.new(50, 50, 50) |
| Flag? | string | nil |
| Callback? | function | function() end |
| InputEndedCallback? | function | function() end |

##### Slider Functions
| Function | Args | Type |
|----------|------|------|
| Set | Value | number |
| SetColor | Color | Color3 |
| SetTextColor | Color | Color3 |
| SetTextTransparency | Transparency | number |
| SetStrokeColor | Color | Color3 |
| SetStrokeTransparency | Transparency | number |
| SetTransparency | Transparency | number |

### Add Dropdown
```lua
Section:AddDropdown()
```

##### Example:
```lua
Section:AddDropdown({
    Name = "Test dropdown",
    Options = {"a", "b", "c", "d"},
    Multi = false,
    Default = "a",
    MaxSize = 5,
    Search = true,
    Flag = "Dropdown1",
    Callback = function(option)
        print(option)
    end
})
```

##### Dropdown Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Dropdown" |
| Options? | table | {} |
| Multi? | bool | false |
| Default? | string or table | "" or {} |
| Flag? | string | nil |
| MaxSize? | number | 5 |
| Search? | bool | false |
| Callback? | function | function() end |

##### Dropdown Functions
| Function | Args | Type |
|----------|------|------|
| Set | Value | string or table |
| Refresh | Options, Delete | table, bool |
| SetColor | Color | Color3 |
| SetTextColor | Color | Color3 |
| SetTextTransparency | Transparency | number |
| SetStrokeColor | Color | Color3 |
| SetStrokeTransparency | Transparency | number |
| SetTransparency | Transparency | number |
| ChangeVisibility | Bool | bool |

### Add Colorpicker
```lua
Section:AddColorpicker()
```

##### Example:
```lua
Section:AddColorpicker({
    Name = "Colorpicker",
    Default = Color3.fromRGB(255, 255, 255),
    DefaultTransparency = 0,
    Flag = "Colorpicker1",
    Callback = function(color, transparency)
        print(color, transparency)
    end
})
```

##### Colorpicker Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Colorpicker" |
| Default? | Color3 | Color3.fromRGB(255, 255, 255) |
| DefaultTransparency? | number | 0 |
| Flag? | string | nil |
| Callback? | function | function() end |

##### Colorpicker Functions
| Function | Args | Type |
|----------|------|------|
| Set | Value, Transparency, NotCallbacking | Color3, number, bool |
| SetColor | Color | Color3 |
| SetTextColor | Color | Color3 |
| SetTextTransparency | Transparency | number |
| SetStrokeColor | Color | Color3 |
| SetStrokeTransparency | Transparency | number |
| SetTransparency | Transparency | number |

### Add Textbox
```lua
Section:AddTextbox()
```

##### Example:
```lua
Section:AddTextbox({
    Name = "Textbox",
    Default = "text",
    TextDisappear = true,
    Callback = function(text)
        print(text)
    end	  
})
```

##### Textbox Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Textbox" |
| Default? | string | "" |
| TextDisappear? | bool | false |
| Callback? | function | function() end |

##### Textbox Functions
| Function | Args | Type |
|----------|------|------|
| Set | Text | string |
| SetColor | Color | Color3 |
| SetTextColor | Color | Color3 |
| SetTextTransparency | Transparency | number |
| SetStrokeColor | Color | Color3 |
| SetStrokeTransparency | Transparency | number |
| SetTransparency | Transparency | number |

### Add Bind
```lua
Section:AddBind()
```

##### Example:
```lua
Section:AddBind({
    Name = "Bind",
    Default = Enum.KeyCode.Q,
    Hold = false,
    Button = false,
    ButtonIcon = "rbxassetid://3944703587",
    DoubleTap = false,
    TapDelay = 0.5,
    Color = Color3.fromRGB(50, 50, 50),
    UIBind = false,
    Flag = "Bind1",
    Callback = function()
        print("Bind pressed")
    end
})
```

##### Bind Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Bind" |
| Default? | Enum or string | "" |
| Hold? | bool | false |
| Button? | bool | false |
| ButtonIcon? | string | "rbxassetid://3944703587" |
| DoubleTap? | bool | false |
| TapDelay? | number | 0.5 |
| Color? | Color3 | Color3.fromRGB(50, 50, 50) |
| UIBind? | bool | false |
| Flag? | string | nil |
| Callback? | function | function() end |

##### Bind Functions
| Function | Args | Type |
|----------|------|------|
| Set | Key | string or Enum |
| SetColor | Color | Color3 |
| SetTextColor | Color | Color3 |
| SetTextTransparency | Transparency | number |
| SetStrokeColor | Color | Color3 |
| SetStrokeTransparency | Transparency | number |
| SetTransparency | Transparency | number |

### Add Label
```lua
Section:AddLabel()
```

##### Example:
```lua
local Label = Section:AddLabel("Label")
```

##### Label Functions
| Function | Args | Type |
|----------|------|------|
| Set | Text | string |
| SetColor | Color | Color3 |
| SetTextColor | Color | Color3 |
| SetTextTransparency | Transparency | number |
| SetStrokeColor | Color | Color3 |
| SetStrokeTransparency | Transparency | number |
| SetTransparency | Transparency | number |

### Add Paragraph
```lua
Section:AddParagraph()
```

##### Example:
```lua
local Paragraph = Section:AddParagraph("Paragraph title", "Paragraph content")
```

##### Paragraph Functions
| Function | Args | Type |
|----------|------|------|
| Set | Content | string |
| SetColor | Color | Color3 |
| SetTextColor | Color | Color3 |
| SetTextTransparency | Transparency | number |
| SetStrokeColor | Color | Color3 |
| SetStrokeTransparency | Transparency | number |
| SetTransparency | Transparency | number |

### Make Notification
```lua
BetterOrion:MakeNotification()
```

##### Example:
```lua
BetterOrion:MakeNotification({
    Title = "Notification",
    Content = "Content",
    Image = "hand",
    Time = 2,
    Sound = "",
    SoundVolume = 1
})
```

##### Notification Configuration
| Property | Value Type | Default |
|----------|------------|---------|
| Name? | string | "Notification Title" |
| Content? | string | "Notification Content" |
| Image? | string | "server" |
| Time? | number | 5 |
| Color? | Color3 | Color3.fromRGB(100, 100, 100) |
| TextColor? | Color3 | Color3.fromRGB(255, 255, 255) |
| Sound? | string | "" |
| SoundVolume? | number | 1 |

##### Notification Settings
| Function | Properties | Value Type |
|----------|------|------|
| SetNotifyingState | {Enabled, Printing} | {bool, bool} |

# Advanced Functions

### Set Config Tab
```lua
BetterOrion:SetConfigTab(TabName)
```

##### Example:
```lua
local Tab = Window:MakeTab({Name = "Settings"})
BetterOrion:SetConfigTab("Settings")
```

### Save and Load Sizes
##### Save and load window size, tabholder size and window position
```lua
BetterOrion:SaveAndLoadSizes()
```

### Load Autoload Configs
##### hm
```lua
BetterOrion:LoadAutoloadConfigs()
```

### Init
##### If you want to show the window library after loading your script
```lua
BetterOrion:Init()
```

### Destroy
```lua
BetterOrion:Destroy()
```

# Flags System
All elements with Flag property can be accessed through `BetterOrion.Flags[FlagName]`

##### Example:
```lua
local Toggle = Section:AddToggle({
    Name = "My Toggle",
    Flag = "MyToggle"
})

BetterOrion.Flags["MyToggle"]:Set(true)
print(BetterOrion.Flags["MyToggle"].Value)
```

# Icons
Use Lucide icon names (e.g., "home", "settings", "user", "activity", "server", "hand") for:
- Window Icon
- IntroIcon
- Tab Icon
- Notification Image
- Watermark Icon
