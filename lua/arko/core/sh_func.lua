arko.func = arko.func or {
    animateAlpha = function(panel, duration, close)
        local startTime = SysTime()
        panel.Think = function()
            local elapsed = SysTime() - startTime
            local progress = math.Clamp(elapsed / duration, 0, 1)

            if close then
                panel:SetAlpha(Lerp(progress, 255, 0))
            else
                panel:SetAlpha(Lerp(progress, 0, 255))
            end

            if progress == 1 then
                panel.Think = nil    
                if close then
                    panel:Remove()
                end
            end
        end
    end,

    animateSize = function(panel, oldSize, newSize, duration)
        local startTime = SysTime()
        panel.Think = function()
            local elapsed = SysTime() - startTime
            local progress = math.Clamp(elapsed / duration, 0, 1)

            local w, h = Lerp(progress, oldSize[1], newSize[1]), Lerp(progress, oldSize[2], newSize[2])
            panel:SetSize(w, h)

            if progress == 1 then
                panel.Think = nil
            end
        end
    end,

    animatePos = function(panel, oldPos, newPos, duration)
        local startTime = SysTime()
        panel.Think = function()
            local elapsed = SysTime() - startTime
            local progress = math.Clamp(elapsed / duration, 0, 1)

            local x, y = Lerp(progress, oldPos[1], newPos[1]), Lerp(progress, oldPos[2], newPos[2])

            if progress == 1 then
                panel.Think = nil
            end
        end
    end,

    notify = function(ply, text, type, duration)
        if ply == LocalPlayer() then
            local colors = {
                ["generic"] = Color(75, 220, 75),
                ["hint"] = Color(220, 220, 75),
                ["error"] = Color(220, 75, 75)
            }
            surface.SetFont('arko.font18')
            local textW, textH = surface.GetTextSize(text)
            local panel = vgui.Create('arko.panel')
            panel:Dock(TOP)
            panel:DockMargin(5, 5, ScrW() - textW * 1.075, 0)
            panel:SetTall(ScrH() / 30)
            local startTime = SysTime()
            panel.Paint = function(_, w, h)
                local elapsed = SysTime() - startTime
                local progress = math.Clamp(elapsed / duration, 0, 1)
                local w, h = panel:GetSize()
                draw.RoundedBox(6, 0, 0, Lerp(progress, 0, w), h, arko.getColor("text"))
                draw.RoundedBox(8, 2, 2, w - 4, h - 4, arko.getColor("primary"))
                draw.RoundedBox(8, 0, 0, 4, h, colors[type])
                
                draw.SimpleText(text, 'arko.font18', 12, h / 2 - textH / 2, arko.getColor('text'))
            end

            arko.func.animateAlpha(panel, 0.2)

            timer.Simple(duration, function()
                arko.func.animateAlpha(panel, 0.2, true)
            end)
        end
    end,

    textbox = function(title, desc, func)
        local frame = vgui.Create("arko.frame")
        frame:SetSize(ScrW() / 8, ScrH() / 8)
        frame:title1(title)
        frame:title2(desc)
        frame:Center()
        frame:MakePopup()

        local textEntry = vgui.Create("arko.entry", frame)
        textEntry:Dock(FILL)
        textEntry:SetPlaceholder("")

        local button = vgui.Create("arko.button", frame)
        button:SetSize(100, 30)
        button:SetPos(100, 90)
        button.Paint = function(_, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(100, 100, 100))
        end

        button.DoClick = function()
            local text = textEntry:GetValue()
            func(text)
            arko.func.closeAnim(frame, 0.2)
        end
    end,

    ply = function(steamid64, steamid32)
        if steamid64 == nil and steamid32 == nil then
            local ply = LocalPlayer()
            if IsValid(ply) then return end

            return ply
        elseif steamid64 != nil then
            local ply = player.GetBySteamID64(steamid64)
            if IsValid(ply) then return end

            return ply
        elseif steamid32 != nil then
            local ply = player.GetBySteamID(steamid32)
            if IsValid(ply) then return end

            return ply
        end
    end,

    renderPlayerModel = function(parent, ply, options)
        options = options or {}
        local w = options.width or 200
        local h = options.height or 200
        local fov = options.fov or 45
        local camOffset = options.camOffset or Vector(-15, 0, 0)
        local lookAtHeight = options.lookAtHeight or 60
        
        local panel = vgui.Create("DModelPanel", parent)

        panel:SetSize(w, h)
        panel:SetModel(ply:GetModel())
        
        panel.Entity:SetSkin(ply:GetSkin())
        for k, v in pairs(ply:GetBodyGroups()) do
            panel.Entity:SetBodygroup(v.id, ply:GetBodygroup(v.id))
        end
        
        local lookAtPos = ply:GetPos() + Vector(0, 0, lookAtHeight)
        panel:SetLookAt(lookAtPos)
        panel:SetCamPos(lookAtPos + camOffset)
        panel:SetFOV(fov)
        
        function panel:LayoutEntity(ent)
            if IsValid(ply) then
                ent:SetSequence(ply:GetSequence())
                ent:SetPoseParametersFromTable(ply:GetPoseParameters())
                
                ent:SetSkin(ply:GetSkin())
                for k, v in pairs(ply:GetBodyGroups()) do
                    ent:SetBodygroup(v.id, ply:GetBodygroup(v.id))
                end
            end
            self:RunAnimation()
        end
        
        function panel:UpdateModel()
            if IsValid(ply) then
                self:SetModel(ply:GetModel())
            end
        end
        
        return panel
    end,

    drawIcon = function(x, y, w, h, color, material)
        surface.SetMaterial(material)
        surface.SetDrawColor(color)
        surface.DrawTexturedRect(x, y, w, h)
    end
}