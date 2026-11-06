<div align="center">

# 🚀 AmogusUI v2.0 — Rayfield Edition

**Лёгкая UI-библиотека для Roblox-скриптов** в стиле Rayfield — тёмная тема, плавные анимации, KeySystem и уведомления.

[🇷🇺 Русский](README.ru.md) | [🇬🇧 English](README.md)

</div>

---

## ✨ Особенности

- 🎬 **Анимации в стиле Rayfield** — появление окна (fade + scale, `Exponential`), плавное переключение вкладок со stagger-эффектом, hover/press анимации кнопок со сжатием через UIScale
- 🎨 **Тёмный минималистичный дизайн** — скруглённые углы, тонкие UIStroke, шрифт FredokaOne
- 🔊 **Звуковой фидбек** — звуки при наведении и клике
- 🖱️ **Перетаскивание окна** за заголовок (мышь и тач)
- 🗂️ **Вкладки** с плавными CanvasGroup-переходами
- 🔑 **KeySystem** — сохранение ключа (`writefile` / `getgenv`), анимация проверки (зелёный/красный), кнопка Get Key
- ⌨️ **Кейнбинд** для показа/скрытия окна
- 🔔 **Уведомления** — выезжают справа снизу, скрываются автоматически
- 🪶 **Без зависимостей** — один файл, только стандартные сервисы Roblox

## 📥 Подключение

```lua
local AmogusUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AM-STUDIOS/BobsScripts/refs/heads/main/AmogusUI.lua"))()
```

> ⚠️ Работает только в executor’е (Xeno, Synapse, Fluxus и т.п.) — в обычном Roblox Studio `loadstring` и `game:HttpGet` отключены. Для тестов в Studio вставьте код в ModuleScript и подключите через `require()`.

## 🚀 Быстрый старт

```lua
local Window = AmogusUI.CreateWindow({
    Name = "Amogus UI",
    Keybind = Enum.KeyCode.RightControl, -- показать/скрыть окно
    -- KeySystem = true,
    -- Key = "ваш_ключ",
    -- SavedKeyStoreName = "AmogusUI_Key",
    -- GetKeyCallback = function() setclipboard("ссылка_на_ключ") end,
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
    Content = "Поддерживает <b>RichText</b>!",
})

AmogusUI.Notify({
    Title = "Loaded!",
    Content = "Welcome to Amogus UI",
    Duration = 5,
})
```

## 📚 API

### `AmogusUI.CreateWindow(config)`
Создаёт окно. До вызова этой функции никакого UI не существует — как в Rayfield.

| Параметр | Тип | Описание |
|---|---|---|
| `Name` | string | Название окна (по умолчанию `"Amogus UI"`) |
| `Keybind` | Enum.KeyCode | Клавиша показа/скрытия окна |
| `KeySystem` | boolean | Включить экран ввода ключа |
| `Key` | string | Правильный ключ |
| `SavedKeyStoreName` | string | Имя файла ключа в `KeySystem/*.json` |
| `GetKeyCallback` | function | Вызывается при нажатии «Get Key» |

### `Window:CreateTab(name)` → `Tab`
Создаёт вкладку с элементами:

| Метод | Аргументы |
|---|---|
| `Tab:CreateSection(name)` | `{ Name = string }` |
| `Tab:CreateParagraph(par)` | `{ Title, Content }` — поддерживает RichText |
| `Tab:CreateButton(btn)` | `{ Name, Callback }` |
| `Tab:CreateToggle(tog)` | `{ Name, CurrentValue, Callback }` |
| `Tab:CreateSlider(sld)` | `{ Name, Range = {min, max}, CurrentValue, Callback }` |

### `AmogusUI.Notify(info)`
| Параметр | Тип | По умолчанию |
|---|---|---|
| `Title` | string | `"Notification"` |
| `Content` | string | `""` (RichText) |
| `Duration` | number | `5` секунд |

## 🔑 Как работает KeySystem

1. При `KeySystem = true` окно не показывается — вместо него открывается экран ввода ключа.
2. Ключ сохраняется: в executor’ах с файловой системой — в `KeySystem/<SavedKeyStoreName>.json` (`writefile`/`readfile`), иначе — в `getgenv()`.
3. При следующем запуске сохранённый ключ проверяется автоматически — экран пропускается.
4. Верный ключ — зелёная подсветка и плавное появление окна, неверный — красная.

## 📋 Требования

- Roblox executor с поддержкой `getgenv` / `writefile` (для KeySystem и `loadstring`)
- Скрипт выполняется на клиенте (`LocalPlayer` обязателен)

## 📄 Лицензия

См. [LICENSE](LICENSE).
