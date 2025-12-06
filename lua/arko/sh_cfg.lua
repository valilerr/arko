arko.cfg = {
    ['addonInitFile'] = 'sh_init.lua',
    ['font'] = 'Unbounded',
    ['colors'] = {
        ['primary'] = Color(25, 35, 40),
        ['secondary'] = Color(44, 45, 46),
        ['header'] =  Color(50, 50, 50),
        ['stroke'] = Color(35, 55, 65),
        ['text'] = Color(220, 220, 220),
        ['darkText'] = Color(175, 175, 175),
        ['scrollBar'] = Color(125, 125, 125),
        ['scrollBarGrip'] = Color(32, 32, 32),
        ['button'] = Color(32, 32, 32),
        ['hoverButton'] = Color(192, 192, 192)
    }
}

function arko.getColor(color)
    return arko.cfg['colors'][color]
end

function arko.getCfg(el)
    return arko.cfg[el]
end