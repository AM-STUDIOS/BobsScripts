<div align="center">

# 🚀 AmogusUI v2.0 — Rayfield Edition

**Лёгкая UI-библиотека для Roblox-скриптов** в стиле Rayfield — тёмная тема, плавные анимации, KeySystem и уведомления.

[RU](#-на русском) | [EN](README.md)

</div>

---

## ✨ Особенности

- 🎬 **Анимации в стиле Rayfield** — появление окна (fade + scale, `Exponential`), плавное переключение вкладок со stagger-эффектом, hover/press анимации кнопок с UIScale-сжатием
- 🎨 **Тёмный минималистичный дизайн** — скруглённые углы, тонкие UIStroke, шрифт FredokaOne
- 🔊 **Звуковой фидбек** — звуки при наведении и клике
- 🖱️ **Перетаскивание окна** за заголовок (мышь и тач)
- 🗂️ **Вкладки** с CanvasGroup-переходами
- 🔑 **KeySystem** — с сохранением ключа (`writefile` / `getgenv`), анимацией проверки (зелёный/красный) и кнопкой Get Key
- ⌨️ **Keybind** для показа/скрытия окна
- 🔔 **Уведомления** — выезжают справа снизу с автоскрытием
- 🪶 **Без зависимостей** — один файл, только стандартные сервисы Roblox

## 📥 Установка

Скачайте [`AmogusUI.lua`](AmogusUI.lua) и подключите через `loadstring`:

```lua
local AmogusUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AM-STUDIOS/BobsScripts/refs/heads/main/AmogusUI.lua"))()
