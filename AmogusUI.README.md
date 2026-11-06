<div align="center">

# 🚀 AmogusUI v2.0 — Rayfield Edition

**Lightweight UI library for Roblox scripts** — Rayfield-style dark theme, smooth animations, KeySystem and notifications.

[🇬🇧 English](AmogusUI.README.md) | [🇷🇺 Русский](AmogusUI.README.ru.md)

</div>

---

## ✨ Features

- 🎬 **Rayfield-style animations** — window reveal (fade + scale, `Exponential` easing), staggered tab fade-ins, hover/press button effects with UIScale squeeze
- 🎨 **Dark minimalist design** — rounded corners, thin UIStrokes, FredokaOne font
- 🔊 **Sound feedback** — hover and click sounds
- 🖱️ **Draggable window** by its header (mouse & touch)
- 🗂️ **Tabs** with smooth CanvasGroup transitions
- 🔑 **KeySystem** — key persistence (`writefile` / `getgenv`), green/red check animation, Get Key button
- ⌨️ **Keybind** to show/hide the window
- 🔔 **Notifications** — slide in from the bottom right, auto-dismiss
- 🪶 **Zero dependencies** — a single file, standard Roblox services only

## 📥 Installation

```lua
local AmogusUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AM-STUDIOS/BobsScripts/refs/heads/main/AmogusUI.lua"))()
```

> ⚠️ Works only in an executor (Xeno, Synapse, Fluxus, etc.) — `loadstring` and `game:HttpGet` are disabled in plain Roblox Studio. For Studio testing, paste the code into a ModuleScript and connect it via `require()`.

## 🚀 Quick Start

```lua
local Window = AmogusUI.CreateWindow({
    Name = "Amogus UI",
    Keybind = Enum.KeyCode.RightControl, -- toggle window visibility
    -- KeySystem = true,
    -- Key = "your_key",
    -- SavedKeyStoreName = "AmogusUI_Key",
    -- GetKeyCallback = function() setclipboard("key_link") end,
})

local Tab = Window:CreateTab("Main")

Tab:CreateSection("Section Title")

Tab:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Clicked!")
    end,
})

Tab:CreateToggle({
    Name = "Enable Feature",
    CurrentValue = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end,
})

Tab:CreateSlider({
    Name = "Speed",
    Range = {0, 100},
    CurrentValue = 25,
    Callback = function(Value)
        print("Slider:", Value)
    end,
})

Tab:CreateParagraph({
    Title = "Info",
    Content = "Supports <b>RichText</b>!",
})

AmogusUI.Notify({
    Title = "Loaded!",
    Content = "Welcome to Amogus UI",
    Duration = 5,
})
```

## 📚 API

### `AmogusUI.CreateWindow(config)`
Creates the window. **No UI exists until this is called** — just like Rayfield.

| Parameter | Type | Description |
|---|---|---|
| `Name` | string | Window title (default `"Amogus UI"`) |
| `Keybind` | Enum.KeyCode | Key to toggle window visibility |
| `KeySystem` | boolean | Enable the key entry screen |
| `Key` | string | The correct key |
| `SavedKeyStoreName` | string | Key file name under `KeySystem/*.json` |
| `GetKeyCallback` | function | Fired when the "Get Key" button is pressed |

### `Window:CreateTab(name)` → `Tab`
Creates a tab with the following elements:

| Method | Arguments |
|---|---|
| `Tab:CreateSection(name)` | `{ Name = string }` |
| `Tab:CreateParagraph(par)` | `{ Title, Content }` — RichText supported |
| `Tab:CreateButton(btn)` | `{ Name, Callback }` |
| `Tab:CreateToggle(tog)` | `{ Name, CurrentValue, Callback }` |
| `Tab:CreateSlider(sld)` | `{ Name, Range = {min, max}, CurrentValue, Callback }` |

### `AmogusUI.Notify(info)`
| Parameter | Type | Default |
|---|---|---|
| `Title` | string | `"Notification"` |
| `Content` | string | `""` (RichText) |
| `Duration` | number | `5` seconds |

## 🔑 How KeySystem Works

1. With `KeySystem = true` the window stays hidden — a key entry screen appears instead.
2. The key is saved: on executors with file access it goes to `KeySystem/<SavedKeyStoreName>.json` (`writefile`/`readfile`), otherwise to `getgenv()`.
3. On the next launch the saved key is checked automatically and the screen is skipped.
4. Correct key → green highlight and a smooth window reveal; wrong key → red highlight.

## 📋 Requirements

- A Roblox executor with `getgenv` / `writefile` support (for KeySystem and `loadstring`)
- Client-side execution (`LocalPlayer` is required)

## 📄 License

See [LICENSE](AmogusUI.LICENSE).
