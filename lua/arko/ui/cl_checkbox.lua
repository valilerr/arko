local PANEL = {}

function PANEL:Init()
    self.checkbox = vgui.Create('arko.button', self)
    self.checkbox:SetSize(ScrH() / 40, ScrH() / 40)
    self.checkbox.Paint = function(_, w, h)
        if self.checkbox:IsHovered() then
            self.checkbox.hoverStatus = math.Clamp(self.checkbox.hoverStatus + 4 * FrameTime(), 0, 255)
        else
            self.checkbox.hoverStatus = math.Clamp(self.checkbox.hoverStatus - 8 * FrameTime(), 0, 255)
        end

        draw.RoundedBox(4, 0, 0, w, h, Color(200, 200, 200))
        draw.RoundedBox(4, 1, 1, w - 2, h - 2, self.check and Color(75, 75, 75) or arko.cfg.get_color('primary2'))
        draw.RoundedBox(4, 1, 1, w - 2, h - 2, Color(100, 100, 100, self.checkbox.hoverStatus * 255))
        if self.check then
            arko.func.drawIcon(w / 2 - w / 2 / 2, h / 2 - h / 2 / 2, w / 2, h / 2, Color(200, 200, 200), Material('arko/gear.png'))
        end
    end
    
    self.checkbox.DoClick = function()
        self.check = !self.check
    end
end

function PANEL:getValue()
    return self.check
end

function PANEL:setDefaultValue(bool)
    self.check = bool
end

vgui.Register('arko.checkbox', PANEL, 'EditablePanel')