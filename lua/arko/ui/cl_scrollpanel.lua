local PANEL = {}

function PANEL:Init()
    self:GetVBar():SetWide(ScrW() * .0025)
end

function PANEL:Paint(w, h)
    local bar = self:GetVBar()
    bar.Paint = function(_, w, h)
        draw.RoundedBox(2, 0, 0, w, h, arko.getColor('scrollBar'))
    end

    bar.btnGrip.Paint = function(_, w, h)
        draw.RoundedBox(2, 0, 0, w, h, arko.getColor('scrollBarGrip'))
    end
end

vgui.Register('arko.scrollpanel', PANEL, 'DScrollPanel')