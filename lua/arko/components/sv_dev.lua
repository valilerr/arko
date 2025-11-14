hook.Add("PlayerSay", "Arko.ChatLua", function(pl, text)
    if string.StartWith(text, "/lua") then
        pl:SendLua(string.sub(text, string.len("/lua") + 1))
        return ""
    end
end)