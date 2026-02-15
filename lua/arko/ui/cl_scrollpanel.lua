local PANEL = {}

function PANEL:Init()
    self.sbar = self:GetVBar()
    self.sbar:SetWide(ScrW() * .0025)
    
    self.sbar.Paint = function(_, w, h)
        draw.RoundedBox(2, 0, 0, w, h, arko.getColor('scrollBar'))
    end

    self.sbar.btnGrip.Paint = function(_, w, h)
        draw.RoundedBox(2, 0, 0, w, h, arko.getColor('scrollBarGrip'))
    end
end

vgui.Register('arko.scrollpanel', PANEL, 'DScrollPanel')