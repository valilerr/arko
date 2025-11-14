arko.cfg = {
    defaultFont = "Montserrat",
    minFontSize = 8,
    maxFontSize = 100, // Don't set value which less than 22
    colors = {
        ["primary"] = Color(25, 35, 40),
        ["secondary"] = Color(44, 45, 46),
        ["stroke"] = Color(25, 25, 25),
        ["header"] = Color(50, 50, 50),
        ["text"] = Color(200, 200, 200),
        ["darkText"] = Color(175, 175, 175)
    }
} // Don't remove any variable

function arko.getColor(color)
    return arko.cfg.colors[color]
end