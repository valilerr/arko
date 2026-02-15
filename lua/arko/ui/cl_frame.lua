local PANEL = {}
local sw, sh = ScrW(), ScrH()

local dragSystem = {
    activePanel = nil,
    startPos = {x = 0, y = 0},
    offset = {x = 0, y = 0}
}

local primary = arko.getColor('primary')
local text = arko.getColor('text')
local darkText = arko.getColor('darkText')
local header = arko.getColor('header')
local stroke = arko.getColor('stroke')

function MakePanelDraggable(panel)
    panel.dragPanel = vgui.Create('DButton', panel)
    panel.dragPanel.Paint = nil
    panel.dragPanel:SetText('')
    panel.dragPanel:SetCursor('sizeall')
    panel.dragPanel.OnMousePressed = function(self, mouseCode)
        if mouseCode == MOUSE_LEFT then
            panelPosX, panelPosY = panel:GetPos()
            panel.posBeforeDrag = {x = panelPosX, y = panelPosY}
            dragSystem.activePanel = panel
            local mouseX, mouseY = gui.MousePos()
            local panelX, panelY = panel:GetPos()
            
            dragSystem.startPos = {x = panelX, y = panelY}
            dragSystem.offset = {
                x = mouseX - panelX,
                y = mouseY - panelY
            }
            
            self:MouseCapture(true)
            self:SetCursor("sizeall")
            
            self:SetZPos(9999)
            self:SetAlpha(220)
        elseif mouseCode == MOUSE_RIGHT then
            local startTime = SysTime()
            panel.Think = function()
                local currentX, currentY = panel:GetPos()
                local elapsed = SysTime() - startTime
                local progress = math.Clamp(elapsed / 0.2, 0, 1)
                if panel.posBeforeDrag != nil then
                    panel:SetPos(
                        Lerp(progress, currentX, panel.posBeforeDrag.x),
                        Lerp(progress, currentY, panel.posBeforeDrag.y)
                    )
                end

                if progress == 1 then
                    panel.Think = nil
                end
            end
        end
    end

    panel.dragPanel.OnMouseReleased = function(mouseCode)
        dragSystem.activePanel = nil
        panel:MouseCapture(false)
        panel:SetCursor('arrow')
            
        panel:SetZPos(0)
        panel:SetAlpha(255)
    end

    panel.dragPanel.Think = function()
        if not IsValid(dragSystem.activePanel) then return end
        
        local panel = dragSystem.activePanel
        local mouseX, mouseY = gui.MousePos()
        
        local newX = mouseX - dragSystem.offset.x
        local newY = mouseY - dragSystem.offset.y
        
        newX = math.Clamp(newX, 0, sw - panel:GetWide())
        newY = math.Clamp(newY, 0, sh - panel:GetTall())
        
        local currentX, currentY = panel:GetPos()
        panel:SetPos(
            Lerp(0.1, currentX, newX),
            Lerp(0.1, currentY, newY)
        )
        panel:SetAlpha(200)
    end
end

function PANEL:Init()
    self.draggable = true 
    self.close = true 
    self.alpha = false 
    self.leftTitle = 'Title'
    self.centerTitle = 'Subtitle'
    self.popup = true
    self.addPaintFunc = function() end

    if self.close then
        self.clsBtn = vgui.Create('arko.button', self)
        self.clsBtn:SetSize(sh * .02, sh * .02)
        self.clsBtn.DoClick = function() arko.func.animateAlpha(self, .2, true) end

        self.clsBtn.DoRightClick = function()
            self.alpha = !self.alpha
            arko.func.notify('Чтобы вернуть панель нажмите ALT+E"', 'hint', 5)
        end

        self.clsBtn.Think = function()
            if self.popup or self.popup then
                self:MakePopup(!self.alpha)
                self:SetKeyBoardInputEnabled(!self.alpha)
                self:SetMouseInputEnabled(!self.alpha)
            end

            if input.IsKeyDown(KEY_LALT) and input.IsKeyDown(KEY_E) then
                self.alpha = false 
            end
        end
    end

    if self.draggable then
        MakePanelDraggable(self)
    end

    arko.func.animateAlpha(self, 0.2)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(6, 0, 0, w, h, Color(stroke.r, stroke.g, stroke.b, 125))
    draw.RoundedBox(6, 2, 2, w - 4, h - 4, self.alpha and Color(primary.r, primary.g, primary.b, 125) or Color(primary.r, primary.g, primary.b, 250))
    draw.RoundedBox(6, 4, 4, w - 8, sh * .02, self.alpha and Color(header.r, header.g, header.b, 200) or Color(header.r, header.g, header.b, 250))
    local leftTitleW, leftTitleH = arko.func.getTextSize(self.leftTitle, 'arko.font16')
    local centerTitleW, centerTitleH = arko.func.getTextSize(self.centerTitle, 'arko.font12')
    draw.SimpleText(self.leftTitle, 'arko.font16', 5, 4 + sh * .01 - leftTitleH / 2, self.colorText)
    draw.SimpleText(self.centerTitle, 'arko.font12', w / 2 - centerTitleW / 2, (4 + sh * .02 / 2) - centerTitleH / 2, darkText)

    if self.close then
        self.clsBtn:SetPos(w - sh * .02 - 2, 4)
    elseif !self.close and IsValid(self.clsBtn) then
        self.clsBtn:Remove()
    end
    
    if self.draggable then
        if IsValid(self.clsBtn) then
            self.dragPanel:SetSize(w - sh * .02 - 5, sh * .02)
        else
            self.dragPanel:SetSize(w, sh * .02)
        end
    elseif !self.draggable and IsValid(self.dragPanel) then
        self.dragPanel:Remove()
    end

    self.addPaintFunc(self, w, h)
end

function PANEL:setTitle(text)
    self.leftTitle = text
end

function PANEL:setSubtitle(text)
    self.centerTitle = text
end

function PANEL:closeBtn(bool)
    self.close = bool
end

function PANEL:drag(bool)
    self.draggable = bool
end

function PANEL:makePopup(bool)
    self.popup = bool
end

function PANEL:close()
    arko.func.animateAlpha(self, .2, true)
end

function PANEL:addPaint(func)
    self.addPaintFunc = func
end

function PANEL:getTitle()
    return self.leftTitle
end

function PANEL:getSubtitle()
    return self.centerTitle
end

vgui.Register('arko.frame', PANEL, 'EditablePanel')