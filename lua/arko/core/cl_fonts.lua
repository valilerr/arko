for i = 8, 100 do
    surface.CreateFont("arko.font" .. i, {
        font = arko.getCfg("font"),
        size = math.floor(i / 900 * ScrH()),
        extended = true,
        antialias = true
    })
end