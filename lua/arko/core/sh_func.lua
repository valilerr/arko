local sw, sh = ScrW(), ScrH()

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
                if close then
                    panel:Remove()
                end
                panel.Think = nil   
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

    animateValue = function(oldValue, newValue, duration)
        local startTime = SysTime()
        timer.Create('Arko.AnimateValue', FrameTime(), 0, function()
            local elapsed = SysTime() - startTime
            local progress = math.Clamp(elapsed / duration, 0, 1)

            local value = Lerp(progress, oldValue, newValue)

            if progress == 1 then
                timer.Remove('Arko.AnimateValue')
                return value
            end

            return value
        end)
    end,

    animateColor = function(oldColor, newColor, duration)
        local startTime = SysTime()
        timer.Create('Arko.AnimateColor', FrameTime(), 0, function()
            local elapsed = SysTime() - startTime
            local progress = math.Clamp(elapsed / duration, 0, 1)
            local oldR, oldG, oldB = oldColor.r, oldColor.g, oldColor.b
            local newR, newG, newB = newColor.r, newColor.g, newColor.b
            
            local resultR, resultG, resultB = Lerp(progress, oldR, newR), Lerp(progress, oldG, newG), Lerp(progress, oldB, newB)
            local resultColor = Color(resultR, resultG, resultB)

            
            if progress == 1 then
                timer.Remove('Arko.AnimateColor')
                return resultColor
            end

            return resultColor
        end)
    end,

    notify = function(text, type, duration)
        local colors = {
            ["generic"] = Color(75, 220, 75),
            ["hint"] = Color(220, 220, 75),
            ["error"] = Color(220, 75, 75)
        }
        surface.SetFont('arko.font18')
        local textW, textH = surface.GetTextSize(text)
        local panel = vgui.Create('arko.panel')
        panel:Dock(TOP)
        panel:DockMargin(5, 5, sw - textW * 1.075, 0)
        panel:SetTall(sh / 30)
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
    end,

    confirm = function(text, func)
        if IsValid(frame) then return end
        frame = vgui.Create("arko.frame")
        frame:SetSize(sw * .15, sh * .125)
        frame:Center()
        frame:setTitle("")
        frame:setSubtitle("Потвердите ваше действие")
        frame:closeBtn(false)
        frame:addPaint(function(self, w, h)
            local textw, texth = arko.func.getTextSize(text, "arko.font18")
            draw.SimpleText(text, "arko.font18", w / 2 - textw / 2, h / 2 - texth, color_text)
        end)
    
        yesButton = vgui.Create("arko.button", frame)
        yesButton:SetSize(sw * .05, sh * .0225)
        yesButton:SetPos(sw * .09, sh * .08)
        yesButton.Paint = function(_, w, h)
            draw.RoundedBox(8, 0, 0, w, h, arko.getColor('button'))
            draw.SimpleText("Да", "arko.font16", w / 2, h / 2.1, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        yesButton.DoClick = function()
            arko.func.animateAlpha(frame, .2, true)
            func()
        end

        noButton = vgui.Create("arko.button", frame)
        noButton:SetSize(sw * .05, sh * .0225)
        noButton:SetPos(sw * .015, sh * .08)
        noButton.Paint = function(_, w, h)
            draw.RoundedBox(8, 0, 0, w, h, arko.getColor('button'))
            draw.SimpleText("Нет", "arko.font16", w / 2, h / 2.1, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        noButton.DoClick = function()
            arko.func.animateAlpha(frame, .2, true)
        end
    end,

    textbox = function(title, placeholder, func)
        frame = vgui.Create("arko.frame")
        frame:SetSize(sw * .15, sh * .125)
        frame:Center()
        frame:setTitle("")
        frame:setSubtitle(title)

        entry = vgui.Create("arko.entry", frame)
        entry:SetSize(sw * .1, sh * .3)
        entry:SetPos(sw * .025, sh * .05)
        entry:setPlaceholder(placeholder)

        applybutton = vgui.Create("arko.button", frame)
        applybutton:SetSize(sw * .05, sh * .0225)
        applybutton:SetPos(sw * .05, sh * .08)
        applybutton:addPaint(function(_, w, h)
            draw.RoundedBox(8, 0, 0, w, h, arko.getColor('button'))
            draw.SimpleText("Выполнить", "arko.font16", w / 2, h / 2.1, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end)

        applybutton.DoClick = function()
            func(entry:getValue())
            arko.func.animateAlpha(frame, .2, true)
        end
    end,

    ply = function(steamid)
        local ply64 = player.GetBySteamID64(steamid)
        local ply32 = player.GetBySteamID(steamid)
        if ply64 then
            return ply64
        elseif ply32 then
            return ply32
        else
            arko.msgError('(arko.func.ply) Player not found.')
        end
    end,

    drawIcon = function(x, y, w, h, color, material)
        surface.SetMaterial(Material(material))
        surface.SetDrawColor(color)
        surface.DrawTexturedRect(x, y, w, h)
    end,

    getTextSize = function(text, font)
        surface.SetFont(font)
        return surface.GetTextSize(text)
    end
}