arko.server.commands = {
    ["list.cfg"] = function()
        PrintTable(arko.cfg)
    end,
    ["list.arko"] = function()
        PrintTable(arko)
    end,
    ["info"] = function()
        print("Arko GMod Library")
        print("Version: " .. arko.version)
    end,
    ["list.ui"] = function()
        local ui_elements, _ = file.Find("arko/ui/*", "LUA")
        print("Arko UI Elements:")
        for _, ui_element in ipairs(ui_elements) do
            print(string.sub(ui_element, 4, -5))
        end
    end,
    ["list.commands"] = function()
        print("Server commands:")
        for name, _ in ipairs(arko.server.commands) do
            print(name)
        end
    end,
    ["rerun"] = function()
        arko.run()
    end
}

concommand.Add("arko", function(_, _, args)
    if !args then return end
    if arko.server.commands[args[1]] then
        arko.server.commands[args[1]]()
    else
        print("Command [" .. args[1] .. "] not found.")
    end
end)