# 🌌 AlyaUI v4

![Version](https://img.shields.io/badge/Version-4.0-blueviolet)
![Platform](https://img.shields.io/badge/Platform-Roblox-black?logo=roblox)
![Status](https://img.shields.io/badge/Status-Active-success)

A premium, lag-free, and highly customizable UI library for Roblox script execution. Inspired by WindUI, but built completely standalone with smooth `CanvasGroup` fading, responsive resizing, and a beautiful dark-mode aesthetic.

---

## 📑 Table of Contents
- [Getting Started](#-getting-started)
- [Creating a Window](#-creating-a-window)
- [Notifications](#-notifications)
- [Tabs & Sections](#-tabs--sections)
- [UI Elements](#-ui-elements)
  - [Buttons](#1-buttons)
  - [Toggles](#2-toggles)
  - [Sliders](#3-sliders)
  - [Dropdowns](#4-dropdowns)
  - [Text Inputs](#5-text-inputs)
  - [Keybinds](#6-keybinds)
  - [Colorpickers](#7-colorpickers)
  - [Labels & Paragraphs](#8-labels--paragraphs)
  - [Dividers](#9-dividers)
- [Booting the UI](#-booting-the-ui)
- [Full Example Script](#-full-example-script)

---

## 📥 Getting Started

Load the library at the very top of your script using your Pastefy (or raw GitHub) link.

```lua
local AlyaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/GodgamingonYT/AlyaUI/refs/heads/main/source.lua"))()
```

---

## 🪟 Creating a Window

The Window is your main interface container. It features smooth dragging, a minimize (`-`) button, a close (`X`) button, and a resize grip in the bottom right corner.

```lua
local Window = AlyaUI:CreateWindow({
    Title = "AlyaUI", -- Main text in the top left
    Version = "[v. 4.0]"   -- Colored accent text next to the title
})
```

---

## 🔔 Notifications

You can trigger smooth sliding notifications in the bottom right of the screen at any time.

```lua
Window:Notify({
    Title = "Script Loaded",
    Content = "Welcome back to AlyaUI v4.0!",
    Duration = 5 -- Time in seconds before it fades out
})
```

---

## 📁 Tabs & Sections

### Creating a Tab
Tabs are the main pages of your UI.
```lua
local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
```

### Creating a Section (Collapsible Folders)
Sections allow you to organize your tabs. When you create a section, **you add elements directly to the section instead of the tab**.
```lua
local AimbotSection = CombatTab:AddSection({
    Name = "Aimbot Settings",
    Default = true -- true = Starts open | false = Starts closed
})
```

---

## 🧩 UI Elements

You can add these elements to a **Tab** (`CombatTab:Add...`) OR a **Section** (`AimbotSection:Add...`).

### 1. Buttons
A simple executable button. You can customize the button text!
```lua
CombatTab:AddButton({
    Name = "Reset Character",
    Text = "Kill", -- Customizes the button text (Defaults to "EXECUTE")
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})
```

### 2. Toggles
An animated switch that returns `true` or `false`.
```lua
CombatTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(state)
        print("ESP is now:", state)
    end
})
```

### 3. Sliders
A draggable slider for selecting number values.
```lua
CombatTab:AddSlider({
    Name = "Aimbot Smoothness",
    Min = 1,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Smoothness:", value)
    end
})
```

### 4. Dropdowns
A clean dropdown menu for selecting an option from a list.
```lua
CombatTab:AddDropdown({
    Name = "Hitbox Target",
    Options = {"Head", "Torso", "Random", "Closest"},
    Default = "Head",
    Callback = function(selected)
        print("Targeting:", selected)
    end
})
```

### 5. Text Inputs
A text box that fires its code when the user finishes typing.
```lua
CombatTab:AddInput({
    Name = "Custom Walkspeed",
    Placeholder = "Enter a number...",
    Callback = function(text)
        print("Walkspeed set to:", text)
    end
})
```

### 6. Keybinds
Allows the user to click and press any key to bind a feature. It automatically detects keystrokes in the background.
```lua
CombatTab:AddKeybind({
    Name = "Aimbot Lock Key",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("Keybind Pressed!", key.Name)
    end
})
```

### 7. Colorpickers
An expandable RGB color picker interface with a live color preview box.
```lua
VisualsTab:AddColorpicker({
    Name = "Chams Color",
    Default = Color3.fromRGB(255, 0, 0), -- Starts Red
    Callback = function(color)
        print("Color changed to:", color)
    end
})
```

### 8. Labels & Paragraphs
Used to add notes, warnings, or descriptions to your UI.
```lua
-- Simple subtle text
CombatTab:AddLabel("Use these settings at your own risk.")

-- Bold title with a description underneath
CombatTab:AddParagraph({
    Name = "Warning!",
    Desc = "This feature might get you banned in public servers."
})
```

### 9. Dividers
Adds a clean, subtle horizontal line to separate features visually.
```lua
CombatTab:AddDivider()
```

---

## 🚀 Booting the UI

This function **must be at the very end of your script**. It initializes the sizes, selects the first tab, and plays the smooth intro animation.

```lua
Window:Init()
```

---

## 💡 Full Example Script

Here is how an advanced, structured script looks in AlyaUI v4.0:

```lua
local AlyaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/GodgamingonYT/AlyaUI/refs/heads/main/source.lua"))()

-- 1. Create Window
local Window = AlyaUI:CreateWindow({
    Title = "AlyaUI Showcase",
    Version = "[v4.0]"
})

-- 2. Send Notification
Window:Notify({
    Title = "Library Loaded",
    Content = "Welcome to the fully patched AlyaUI v4.0!",
    Duration = 5
})

-- 3. Create Tabs
local MainTab = Window:CreateTab("Main Features")
local AdvancedTab = Window:CreateTab("Advanced")

-- ========================================== --
--               MAIN TAB                     --
-- ========================================== --

local BasicSection = MainTab:AddSection({
    Name = "Basic Elements",
    Default = true
})

BasicSection:AddLabel("Welcome to the new and improved AlyaUI.")

BasicSection:AddParagraph({
    Name = "Information",
    Desc = "All bugs have been patched, including the transparency issue and missing elements."
})

BasicSection:AddDivider()

BasicSection:AddButton({
    Name = "Test Button",
    Text = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

BasicSection:AddToggle({
    Name = "Test Toggle",
    Default = false,
    Callback = function(state)
        print("Toggle is now:", state)
    end
})

BasicSection:AddSlider({
    Name = "Test Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider value:", value)
    end
})

BasicSection:AddDropdown({
    Name = "Test Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(selected)
        print("Selected:", selected)
    end
})

BasicSection:AddInput({
    Name = "Test Input",
    Placeholder = "Type here...",
    Callback = function(text)
        print("Input:", text)
    end
})

-- ========================================== --
--             ADVANCED TAB                   --
-- ========================================== --

local AdvSection = AdvancedTab:AddSection({
    Name = "Advanced Elements",
    Default = true
})

AdvSection:AddKeybind({
    Name = "Test Keybind",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("Key pressed:", key.Name)
    end
})

AdvSection:AddColorpicker({
    Name = "Test Colorpicker",
    Default = Color3.fromRGB(85, 75, 255),
    Callback = function(color)
        print("Color selected:", color)
    end
})

-- 4. Initialize UI (Required at the bottom)
Window:Init()
```
