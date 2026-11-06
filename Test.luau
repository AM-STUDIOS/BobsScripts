local AmogusUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AM-STUDIOS/BobsScripts/refs/heads/main/AmogusUI.source.luau"))()

local Window = AmogusUI.CreateWindow({
    Name = "Amogus UI",
    Keybind = Enum.KeyCode.K, -- показать/скрыть окно
    KeySystem = false,
    Key = "AmogusUITest",
    SavedKeyStoreName = "AmogusUI_Key",
    GetKeyCallback = function() setclipboard("ссылка_на_ключ") end,
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
    Name = "Test",
    CurrentValue = false,
    Callback = function(Value)
        if Value == true then
            AmogusUI.Notify({
                Title = "Test",
                Content = "Enabled!",
                Duration = 2,
            })
        else
            AmogusUI.Notify({
                Title = "Test",
                Content = "Disabled!",
                Duration = 5,
            })
        end
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
