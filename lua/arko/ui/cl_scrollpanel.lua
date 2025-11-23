local PANEL = {}

function PANEL:Init()
    self.sbar = self:GetVBar()

    function self.sbar:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, arko.cfg.get_color('sbar'))
    end 

    function self.sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, arko.cfg.get_color('sbarGrip'))
    end

    function self.sbar.btnUp:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, arko.cfg.get_color('sbarBtn'))
    end

    function self.sbar.btnDown:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, arko.cfg.get_color('sbarBtn'))
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, arko.cfg.get_color('secondary'))
end

vgui.Register('arko.scrollpanel', PANEL, 'DScrollPanel')