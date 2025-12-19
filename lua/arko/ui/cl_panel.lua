local PANEL = {}
local stroke = arko.getColor('stroke')
local primary = arko.getColor('primary')

function PANEL:Init()
    self.addPaintFunc = function() end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(6, 0, 0, w, h, Color(stroke.r, stroke.g, stroke.b, 125))
    draw.RoundedBox(6, 2, 2, w - 4, h - 4, Color(primary.r, primary.g, primary.b, 250))

    self.addPaintFunc(self, w, h)
end

function PANEL:addPaint(func)
    self.addPaintFunc = func
end

vgui.Register('arko.panel', PANEL, 'EditablePanel')