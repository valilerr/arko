arko.fonts = arko.fonts or {
    add = function(name, font, size)
        surface.CreateFont("arko.font" .. name, {
            font = font,
            size = math.ceil(size / 900 * ScrH()),
            extended = true,
            antialias = true
        })
    end
}

for i = arko.cfg.minFontSize, arko.cfg.maxFontSize do
    arko.fonts.add(i, arko.cfg.defaultFont, i)
end