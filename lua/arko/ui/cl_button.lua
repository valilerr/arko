local PANEL = {}
local buttonColor = arko.getColor("button")
local hover = arko.getColor("hoverButton")

function PANEL:Init()
    self:SetText('')
    self.hoverStatus = 0
    self.icon = 'arko/close.png'
    self.addPaintFunc = function() end
end

function PANEL:Paint(w, h)
    if self:IsHovered() then
        self.hoverStatus = math.Clamp(self.hoverStatus + 4 * FrameTime(), 0, 1)
    else
        self.hoverStatus = math.Clamp(self.hoverStatus - 8 * FrameTime(), 0, 1)
    end

    draw.RoundedBox(8, 0, 0, w, h, arko.getColor('button'))
    draw.RoundedBox(8, 0, 0, w, h, Color(arko.getColor('button').r + 50, arko.getColor('button').g + 50, arko.getColor('button').b + 50, self.hoverStatus * 255))
    draw.RoundedBox(8, 2, 2, w - 4, h - 4, arko.getColor('primary'))
    draw.RoundedBox(8, 2, 2, w - 4, h - 4, Color(arko.getColor('secondary').r, arko.getColor('secondary').g, arko.getColor('secondary').b, self.hoverStatus * 255))
    if self.icon != '' then
        arko.func.drawIcon(w / 2 - w / 2 / 2, h / 2 - h / 2 / 2, w / 2, h / 2, Color(200, 200, 200), self.icon)
    end

    self.addPaintFunc(self, w, h)
end

function PANEL:setIcon(mat)
    self.icon = mat
end

function PANEL:addPaint(func)
    self.addPaintFunc = func
end

vgui.Register('arko.button', PANEL, 'DButton')