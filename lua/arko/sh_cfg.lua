arko.cfg = {
    ["addonInitFile"] = "init.lua",
    ["font"] = "Montserrat",
    ["colors"] = {
        ['primary'] = Color(25, 35, 40),
        ['secondary'] = Color(44, 45, 46),
        ['header'] = Color(50, 50, 50),
        ['stroke'] = Color(25, 25, 25),
        ['text'] = Color(200, 200, 200),
        ['sbar'] = Color(100, 100, 100),
        ['sbarGrip'] = Color(200, 200, 200),
        ['sbarBtn'] = Color(150, 150, 150),
        ["button"] = Color(32, 32, 32),
        ["hoverButton"] = Color(16, 16, 16)
    }
}

function arko.getColor(color)
    return arko.cfg["colors"][color]
end