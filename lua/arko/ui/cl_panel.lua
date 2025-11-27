local PANEL = {}

function PANEL:Paint(w, h)
    draw.RoundedBox(6, 0, 0, w, h, arko.getColor("stroke"))
    draw.RoundedBox(8, 2, 2, w - 4, h - 4, arko.getColor('primary'))
end

vgui.Register('arko.panel', PANEL, 'EditablePanel')