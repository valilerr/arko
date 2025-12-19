local sw, sh = ScrW(), ScrH()

arko.client.commands = {
    ['ui.frame'] = function()
        local frame = vgui.Create('arko.frame')
        frame:SetSize(sw * .5, sh * .5)
        frame:setTitle('Arko')
        frame:setSubtitle('Frame')
        frame:Center()
    end,
    ['ui.scrollpanel'] = function()
        local frame = vgui.Create('arko.frame')
        frame:SetSize(sw * .5, sh * .5)
        frame:setTitle('Arko')
        frame:setSubtitle('ScrollPanel')
        frame:Center()

        local scrollPanel = vgui.Create('arko.scrollpanel', frame)
        scrollPanel:Dock(FILL)
        scrollPanel:DockMargin(5, sh * .02 + 5, 5, 5)
        for i = 0, 10 do
            local panel = vgui.Create('arko.panel', scrollPanel)
            panel:Dock(TOP)
            panel:DockMargin(5, 5, 5, 5)
            panel:SetTall(sh * .05)
        end
    end,
    ['info'] = function()
        print('Arko GMod Library')
        print('Version: ' .. arko.version)
    end
}


function arko.client.init_commands()
    concommand.Add("arko", function(pl, _, args)
        if args[1] == '' then return end
        if arko.client.commands[args[1]] then
            arko.client.commands[args[1]]()
        else
            print("Command [" .. args[1] .. "] not found.")
        end
    end)
end

arko.client.init_commands()