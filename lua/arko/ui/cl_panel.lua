local PANEL = {}

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, arko.cfg.get_color('primary'))
end

vgui.Register('arko.panel', PANEL, 'EditablePanel')