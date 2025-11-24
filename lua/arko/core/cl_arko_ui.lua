local sw, sh = ScrW(), ScrH()

arko.client.commands = {
    ["ui.frame"] = function()
        local frame = vgui.Create('arko.frame')
        frame:SetSize(sw / 3, sh / 3)
        frame:Center()
        frame:setTitle('Arko')
        frame:setSubtitle('Меню')
    end
}


function arko.client.init_commands()
    concommand.Add("arko", function(_, _, args)
        if arko.client.commands[args[1]] then
            arko.client.commands[args[1]]()
        end
    end)
end

arko.client.init_commands()