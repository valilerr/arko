local PANEL = {}

function PANEL:Init()
    self.title = ''

    self:SetTall(24)

    self.main = vgui.Create('DPanel', self)
    self.main.Paint = function(_, w, h)
        draw.RoundedBox(6, 0, 0, w, h, arko.getColor('button'))
    end

    self.entry = vgui.Create('DTextEntry', self.main)
    self.entry:SetFont('arko.font18')
    self.entry:SetDrawLanguageID(false)
    self.entry:SetPaintBackground(false)
    self.entry:
end

function PANEL:setTitle(title)
    self.title = title
    self:SetTall(44)
end

function PANEL:setPlaceholder(placeholder)
    self.entry:SetPlaceholderText(placeholder)
end

function PANEL:getValue()
    return self.entry:GetText()
end

function PANEL:Paint(w, h)
    if self.title != '' then
        local textW, textH = arko.func.getTextSize(self.title, 'arko.font18')
        draw.SimpleText(self.title, 'arko.font18', w / 2 - textW / 2, h / 2 - textH / 2, arko.getColor('text'))
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