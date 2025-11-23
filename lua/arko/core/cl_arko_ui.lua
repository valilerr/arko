local sw, sh = ScrW(), ScrH()

function arko_frame()
    local frame = vgui.Create('arko.frame')
    frame:SetSize(sw / 3, sh / 3)
    frame:Center()
    frame:title1('Arko')
    frame:title2('Меню')
end

concommand.Add('arko.frame', arko_frame)

function arko_textbox()
    arko.func.textbox('Test', 'Test', function(text)
        arko.func.notify(LocalPlayer(), text, 'generic', 5)
    end)
end

concommand.Add('arko.textbox', arko_textbox)