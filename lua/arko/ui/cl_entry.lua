local PANEL = {}

function PANEL:Init()
    self.title = ''

    self:SetTall(24)

    self.main = vgui.Create('Panel', self)
    self.main.Paint = function(_, w, h)
        draw.RoundedBox(6, 0, 0, w, h, arko.cfg.get_color('text'))
    end

    self.entry = vgui.Create('DTextEntry', self.main)
    self.entry:SetFont('arko.font18')
    self.entry:SetDrawLanguageID(false)
    self.entry:SetPaintBackground(false)
end

function PANEL:SetTitle(title)
    self.title = title
    self:SetTall(44)
end

function PANEL:SetPlaceholder(placeholder)
    self.entry:SetPlaceholderText(placeholder)
end

function PANEL:GetValue()
    return self.entry:GetText()
end

function PANEL:Paint(w, h)
    if !self.title == '' then
        draw.SimpleText(self.title, 'arko.font18', 6, 0, arko.cfg.get_color('text'))
    end
end

function PANEL:PerformLayout(w, h)
    self.main:SetSize(w - 12, 24)

    if self.title != '' then
        self.main:SetPos(6, 20)
    else
        self.main:SetPos(6, 0)
    end

    self.entry:Dock(FILL)
end

vgui.Register('arko.entry', PANEL, 'Panel')