local PANEL = {}
local secondary = arko.getColor("secondary")
local text = arko.getColor("text")
local stroke = arko.getColor("stroke")


function PANEL:Init()
    self.settings = {icon = "arko/close.png"}
    self.hoverStatus = 0
    self:SetText("")
end

function PANEL:Paint(w, h)
    if self:IsHovered() then
        self.hoverStatus = math.Clamp(self.hoverStatus / 1, 0, 1)
    else
        self.hoverStatus = math.Clamp(self.hoverStatus / 1, 1, 0)
    end

    draw.RoundedBox(6, 0, 0, w, h, secondary)
    draw.RoundedBox(6, 4, 4, w - 8, h - 8, stroke)
    draw.RoundedBox(6, 0, 0, w, h, Color(secondary.r, secondary.g, secondary.b, self.hoverStatus * 255))
    draw.RoundedBox(6, 4, 4, w - 8, h - 8, Color(stroke.r, stroke.g, stroke.b, self.hoverStatus * 255))
    arko.func.drawIcon(w / 2 - w * .25, h / 2 - h * .25, w * .5, h * .5, text, Material(self.settings.icon))
end

function PANEL:settings(...)
    local settings = ...

    if setting.icon then
        self.settings.icon = settings.icon
    end
end

vgui.Register("arko.button", PANEL, "DButton")