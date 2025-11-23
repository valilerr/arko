hook.Add('PlayerSay', 'Arko.Menu.Open', function(pl, text)
    if text == '!arko.frame' then
        pl:ConCommand('arko.frame')
        return ''
    elseif text == '!arko.textbox' then
        pl:ConCommand('arko.textbox')
        return ''
    end
end)