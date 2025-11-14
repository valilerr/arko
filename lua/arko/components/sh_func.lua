arko.func = arko.func or {
    animateSize = function(panel, oldSize, newSize, duration)
        if not panel or not (oldSize.w and oldSize.h) or not (newSize.w and newSize.h) then return end
        local startTime = SysTime()

        panel.Think = function()
            local elapsed = SysTime() - startTime
            local progress = math.Clamp(elapsed / duration, 0, 1)

            local w, h = Lerp(progress, oldSize.w, newSize.w), Lerp(progress, oldSize.h, newSize.h)
            panel:SetSize(w, h)

            if progress == 1 then
                panel.Think = nil
            end
        end
    end,
    animatePos = function(panel, oldPos, newPos, duration)
        if not panel or not (oldPos.x and oldPos.x) or not (newPos.y and newPos.y) then return end
        local startTime = SysTime()

        panel.Think = function()
            local elapsed = SysTime() - startTime
            local progress = math.Clamp(elapsed / duration, 0, 1)

            local x, y = Lerp(progress, oldPos.x, newPos.x), Lerp(progress, oldPos.y, newPos.y)
            panel:SetPos(x, y)

            if progress == 1 then
                panel.Think = nil
            end
        end
    end,
    animateOpen = function(panel, duration)
        if not panel then return end
        local startTime = SysTime()

        panel.Think = function()
            local elapsed = SysTime() - startTime
            local progress = math.Clamp(elapsed / duration, 0, 1)

            local alpha = Lerp(progress, 0, 255)
            panel:SetAlpha(alpha)

            if progress == 1 then
                panel.Think = nil
            end
        end
    end,
    animateClose = function(panel, duration)
        if not panel then return end
        local startTime = SysTime()

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
    end,
    animateValue = function(from, to, duration)
        if not from or not to then return end
        local startTime = SysTime()
        hook.Add("Think", "Arko.AnimateValue", function()
            local elapsed = SysTime() - startTime
            local progress = math.Clamp(elapsed / duration, 0, 1)
            local value = Lerp(progress, from, to)


            if progress == 1 then
                hook.Remove("Think", "Arko.AnimateValue")
            end

            return value
        end)
    end,
    drawIcon = function(x, y, w, h, color, mat)
        surface.SetMaterial(mat)
        surface.SetDrawColor(color)
        surface.DrawTexturedRect(x, y, w, h)
    end
}