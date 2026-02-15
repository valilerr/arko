arko.commands = arko.commands or {
    all = {
        ['ui'] = {
            args = {
                ['frame'] = function()
                    local frame = vgui.Create('arko.frame')
                    frame:SetSize(ScrW() * .5, ScrH() * .5) 
                    frame:Center()
                    frame:setTitle('Arko')
                    frame:setSubtitle('Frame') 
                end,
                ['scrollpanel'] = function()
                    local frame = vgui.Create('arko.frame')
                    frame:SetSize(ScrW() * .5, ScrH() * .5) 
                    frame:Center()
                    frame:setTitle('Arko')
                    frame:setSubtitle('ScrollPanel')
                    
                    local sp = vgui.Create('arko.scrollpanel', frame)
                    sp:Dock(FILL)
                    sp:DockMargin(2, ScrH() * .03, 2, 2)

                    for i=1, 10 do
                        local panel = vgui.Create('arko.panel', sp)
                        panel:Dock(TOP)
                        panel:SetTall(ScrH() * .05)
                    end
                end
            },
            permissions = {'all'},
            side = CLIENT
        },
        ['core'] = {
            args = {
                ['restart'] = function()
                    arko.run()
                end
            },
            permissions = {['superadmin'] = true},
            side = CLIENT
        }
    }
}

function arko.commands.execute(pl, args)
    if not pl or not args then return end
    local name = args[1]
    table.remove(args, 1)
    local command = arko.commands.all[name]
    if not command then return end
    local havePermission = true and (command.permissions[pl:GetUserGroup()] or command.permissions[1] == 'all') or false
    if #args != 0 then
        if havePermission then
            for _, arg in ipairs(args) do
                command.args[arg]()
            end
        else
            arko.msgError('Commands', "You don't have permission to use this command!\n")
        end
    else
        command.args['default']()
    end
end

concommand.Add('arko', function(pl, _, args)
    arko.commands.execute(pl, args)
end)