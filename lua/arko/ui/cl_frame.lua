local PANEL = {}

local dragSystem = {
    activePanel = nil,
    startPos = {x = 0, y = 0},
    offset = {x = 0, y = 0}
}

local primary = arko.getColor("primary")
local text = arko.getColor("text")
local header = arko.getColor("header")
local stroke = arko.getColor("stroke")

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
        panel:SetCursor("arrow")
            
        panel:SetZPos(0)
        panel:SetAlpha(255)
    end

    panel.dragPanel.Think = function()
        if not IsValid(dragSystem.activePanel) then return end
        
        local panel = dragSystem.activePanel
        local mouseX, mouseY = gui.MousePos()
        
        local newX = mouseX - dragSystem.offset.x
        local newY = mouseY - dragSystem.offset.y
        
        newX = math.Clamp(newX, 0, ScrW() - panel:GetWide())
        newY = math.Clamp(newY, 0, ScrH() - panel:GetTall())
        
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

    if self.close then
        self.clsBtn = vgui.Create('arko.button', self)
        self.clsBtn:SetSize(ScrH() / 50, ScrH() / 50)
        self.clsBtn:setIcon(Material('arko/close.png'))
        self.clsBtn.DoClick = function()
            arko.func.closeAnim(self, 0.2)
        end

        self.clsBtn.DoRightClick = function()
            self.alpha = !self.alpha
            arko.func.notify(LocalPlayer(), "Чтобы вернуть панель нажмите ALT+E", "hint", 5)
        end

        self.clsBtn.Think = function()
            if self.popup or self.alpha then
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

    arko.func.anim(self, 0.2)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, self.alpha and Color(primary.r, primary.g, primary.b, 200) or primary)
    draw.RoundedBox(8, 2, 2, w - 4, ScrH() / 50, self.alpha and Color(header.r, header.g, header.b, 200) or header)
    draw.SimpleText(self.leftTitle, 'arko.font16', 5, 3, self.colorText)
    draw.SimpleText(self.centerTitle, 'arko.font12', w / 2 - surface.GetTextSize(self.centerTitle) / 2, 6, text)

    if self.close then
        self.clsBtn:SetPos(w - ScrH() / 50 - 2, 2)
    elseif !self.close and IsValid(self.clsBtn) then
        self.clsBtn:Remove()
    end
    
    if self.draggable then
        if IsValid(self.clsBtn) then
            self.dragPanel:SetSize(w - ScrH() / 50 - 5, ScrH() / 50)
        else
            self.dragPanel:SetSize(w, ScrH() / 50)
        end
    elseif !self.draggable and IsValid(self.dragPanel) then
        self.dragPanel:Remove()
    end
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

vgui.Register('arko.frame', PANEL, 'EditablePanel')