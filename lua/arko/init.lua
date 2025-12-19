--[[
    Arko - GMod Library 
    
    by valilerr
    Discord: valilerr
]]

arko = arko or {
    version = '0.5',
    client = {},
    server = {},
    init = function(path)
        if string.find(path, "sh_") then
            if SERVER then
                AddCSLuaFile(path)
                include(path)
            else
                include(path)
            end
        elseif string.find(path, "sv_") then
            if SERVER then
                include(path)
            end
        elseif string.find(path, "cl_") then
            if SERVER then
                AddCSLuaFile(path)
            else
                include(path)
            end
        end
    end,

    initFolder = function(folderPath)
        local files, directories = file.Find(folderPath .. "/*", "LUA")

        for _, fileName in ipairs(files) do
            arko.init(folderPath .. "/" .. fileName)
        end

        for _, folderName in ipairs(directories) do
            arko.initFolder(folderPath .. "/" .. folderName)
        end
    end,
    isLoaded = false,
    loadTime = 0,
    core = {
        run = function()
            arko.initFolder("arko/core")
        end
    },
    ui = {
        run = function()
            arko.initFolder("arko/ui")
        end
    },
    addons = {
        run = function()
            local _, directories = file.Find('arko_addons/*', 'LUA')

            for _, dir in ipairs(directories) do
                arko.init('arko_addons/' .. dir .. '/' .. arko.getCfg('addonInitFile'))
            end
        end
    },
    run = function()
        arko.loadTime = SysTime()
        arko.isLoaded = false 
        print('')

        MsgC(Color(75, 220, 75), 'Arko[v' .. arko.version .. '] loading...\n')

        arko.init('arko/sh_cfg.lua')

        arko.core.run() 
        MsgC(Color(75, 220, 75), '(Core) ', Color(255, 255, 255), 'Loaded in ' .. math.Round(SysTime() - arko.loadTime, 3) .. ' seconds.\n')

        arko.ui.run()
        MsgC(Color(75, 220, 75), '(UI) ', Color(255, 255, 255), 'Loaded in ' .. math.Round(SysTime() - arko.loadTime, 3) .. ' seconds.\n')

        if SERVER then
            resource.AddWorkshop("3610914065")
        end
        MsgC(Color(75, 220, 75), '(Workshop) ', Color(255, 255, 255), 'Loaded in ' .. math.Round(SysTime() - arko.loadTime, 3) .. ' seconds.\n')

        arko.isLoaded = true
        arko.loadTime = math.Round(SysTime() - arko.loadTime, 3)
        
        MsgC(Color(75, 220, 75), 'Arko loaded in ' .. arko.loadTime .. ' seconds.\n')
        
        print('')

        arko.addons.run()
        MsgC(Color(75, 220, 75), '(Arko) ', Color(255, 255, 255), 'Addons loaded!\n')
    end
}

arko.run()