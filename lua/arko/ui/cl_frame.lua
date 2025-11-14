local PANEL = {}
local sw, sh = ScrW(), ScrH()
local stroke = arko.getColor("stroke")
local primary = arko.getColor("primary")
local secondary = arko.getColor("secondary")
local header = arko.getColor("header")
local text = arko.getColor("text")
local darkText = arko.getColor("darkText")

function PANEL:Init()
    self.settings = {leftTitle = "Frame", centerTitle = "Description", closeBtn = true, drag = true}

    arko.func.animateOpen(self, 0.2)

    self.clsBtn = vgui.Create("arko.button", self)
    self.clsBtn:SetSize(sh * .025, sh * .025)
    self.clsBtn.DoClick = function() self:close() end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(6, 0, 0, w, h, stroke)
    draw.RoundedBox(6, 2, 2, w - 4, h - 4, primary)

    draw.RoundedBox(2, 2, 2, w - 4, sh * .025, header)
    surface.SetFont("arko.font22")
    local leftTitleW, leftTitleH = surface.GetTextSize(self.settings.leftTitle)
    surface.SetFont("arko.font18")
    local centerTitleW, centerTitleH = surface.GetTextSize(self.settings.centerTitle)

    draw.SimpleText(self.settings.leftTitle, "arko.font22", 4, 2 + (sh * .025 / 2 - leftTitleH / 2), text)
    draw.SimpleText(self.settings.centerTitle, "arko.font18", 2 + ((w - 4) / 2 - centerTitleW / 2), 2 + (sh * .025 / 2 - centerTitleH / 2), darkText)

    if self.settings.closeBtn then
        self.clsBtn:SetPos(w - 2 - sh * .025, 2)
    elseif IsValid(self.clsBtn) then
        self.clsBtn:Remove()
    end
end

function PANEL:close()
    arko.func.animateClose(self, 0.2)
end

function PANEL:settings(...)
    local settings = ...
    if settings.leftTitle then
        self.settings.leftTitle = settings.leftTitle
    end
    if settings.centerTitle then
        self.settings.centerTitle = settings.centerTitle
    end
    if settings.closeBtn then
        self.settings.closeBtn = settings.closeBtn
    end
    if settings.drag then
        self.settings.drag = settings.drag
    end
end

vgui.Register("arko.frame", PANEL, "EditablePanel")