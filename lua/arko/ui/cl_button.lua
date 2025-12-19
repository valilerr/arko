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

    draw.RoundedBox(8, 0, 0, w, h, buttonColor)

    draw.RoundedBox(8, 0, 0, w, h, Color(hover.r, hover.g, hover.b, self.hoverStatus * 255))
    if self.icon != '' then
        arko.func.drawIcon(w / 2 - w / 2 / 2, h / 2 - h / 2 / 2, w / 2, h / 2, Color(200, 200, 200), self.icon)
        arko.func.drawIcon(w / 2 - w / 2 / 2, h / 2 - h / 2 / 2, w / 2, h / 2, Color(buttonColor.r, buttonColor.g, buttonColor.b, self.hoverStatus * 255), self.icon)
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