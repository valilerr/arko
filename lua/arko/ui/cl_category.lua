local PANEL = {}

function PANEL:Init()
    self.check = false
    self.button = vgui.Create('arko.button', self)
    self.button.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50))
    end
    self.button.DoClick = function()
        self.check = !self.check
    end
end

vgui.Register('arko.category', PANEL, 'EditablePanel')