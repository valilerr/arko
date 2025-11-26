arko.func = {}

function arko.func.anim(panel, duration)
    local startTime = SysTime()
    panel:SetAlpha(0)

    panel.Think = function()
        local elapsed = SysTime() - startTime
        local progress = math.Clamp(elapsed / duration, 0, 1)
        local alpha = Lerp(progress, 0, 255)
        panel:SetAlpha(alpha)

        if progress == 1 then
            panel.Think = nil 
        end
    end
end

function arko.func.closeAnim(panel, duration)
    local startTime = SysTime()
    panel:SetAlpha(0)

    panel.Think = function()
        local elapsed = SysTime() - startTime
        local progress = math.Clamp(elapsed / duration, 0, 1)
        local alpha = Lerp(progress, 255, 0)
        panel:SetAlpha(alpha)

        if progress == 1 then
            panel.Think = nil 
            panel:Remove()
        end
    end
end

function arko.func.drawIcon(x, y, w, h, color, mat)
    surface.SetMaterial(mat)
    surface.SetDrawColor(color)
    surface.DrawTexturedRect(x, y, w, h)
end

function arko.func.lerpColor(frac, color)
    return Color(
        Lerp(frac * FrameTime(), color.r),
        Lerp(frac * FrameTime(), color.g),
        Lerp(frac * FrameTime(), color.b),
        Lerp(frac * FrameTime(), color.a)
    )
end

function arko.func.findDirectories(path_to_directories, path)
    local _, directories = file.Find(path_to_directories .. '/*', path)

    return directories
end

function arko.func.findFilesInDir(dir_path, path)
    local files, _ = file.Find(dir_path .. '/*', path)
    
    return files
end

function arko.func.notify(ply, text, type, duration)
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
            draw.RoundedBox(6, Lerp(progress, 0, w / 2), 0, Lerp(progress, w, 0), h, arko.getColor("text"))
            draw.RoundedBox(8, 2, 2, w - 4, h - 4, arko.getColor("primary"))
            draw.RoundedBox(8, 0, 0, 4, h, colors[type])
            
            draw.SimpleText(text, 'arko.font18', 12, h / 2 - textH / 2, arko.getColor('text'))
        end

        arko.func.anim(panel, 0.2)

        timer.Simple(duration, function()
            arko.func.closeAnim(panel, 0.2)
        end)
    end
end

function arko.func.textbox(title, desc, func)
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
end

function arko.func.ply(steamid64, steamid32)
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
end

function arko.func.animSize(panel, oldW, oldH, newW, newH, duration)
    local startTime = SysTime()

    local oldThink = panel.Think

    panel.Think = function()
        local elapsed = SysTime() - startTime
        local progress = math.Clamp(elapsed / duration, 0, 1)

        local sizeW = Lerp(progress, oldW, newW)
        local sizeH = Lerp(progress, oldH, newH)

        panel:SetWide(sizeW)
        panel:SetTall(sizeH)

        if progress == 1 then
            panel.Think = oldThink
        end
    end
end

function arko.func.renderPlayerModel(parent, ply, options)
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
end