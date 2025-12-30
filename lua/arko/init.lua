--[[
    Arko - GMod Library 
    
    by valilerr
    Discord: valilerr
]]

arko = arko or {
    version = '0.55',
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
            arko.core.isLoaded = true
        end,
        isLoaded = false
    },
    ui = {
        run = function()
            arko.initFolder("arko/ui")
            arko.ui.isLoaded = true
        end,
        isLoaded = false
    },
    addons = {
        run = function()
            local _, directories = file.Find('arko_addons/*', 'LUA')

            for _, dir in ipairs(directories) do
                arko.init('arko_addons/' .. dir .. '/' .. arko.getCfg('addonInitFile'))
                arko.msg('(Addons)' .. dir .. ' loaded!\n')
            end

            arko.addons.isLoaded = true
        end,
        isLoaded = false
    },
    msg = function(text)
        MsgC(Color(75, 220, 75), text)
    end,
    msgError = function(text)
        MsgC(Color(220, 75, 75), text)
    end,
    run = function()
        if arko.isLoaded then
            arko.msg('Restarting all library...\n')
        end
        arko.loadTime = SysTime()
        arko.isLoaded = false 
        print('')

        arko.msg('Arko[v' .. arko.version .. '] loading...\n')

        arko.init('arko/sh_cfg.lua')

        arko.core.run() 
        if arko.core.isLoaded then arko.msg('(Core) ', Color(255, 255, 255), 'Loaded in ' .. math.Round(SysTime() - arko.loadTime, 3) .. ' seconds.\n') end

        arko.ui.run()
        if arko.ui.isLoaded then MsgC(Color(75, 220, 75), '(UI) ', Color(255, 255, 255), 'Loaded in ' .. math.Round(SysTime() - arko.loadTime, 3) .. ' seconds.\n') end

        if SERVER then
            resource.AddWorkshop("3610914065")
        end
        MsgC(Color(75, 220, 75), '(Workshop) ', Color(255, 255, 255), 'Loaded in ' .. math.Round(SysTime() - arko.loadTime, 3) .. ' seconds.\n')

        arko.isLoaded = true
        arko.loadTime = math.Round(SysTime() - arko.loadTime, 3)
        
        MsgC(Color(75, 220, 75), 'Arko loaded in ' .. arko.loadTime .. ' seconds.\n')
        
        print('')

        arko.addons.run()
        if arko.addons.isLoaded then MsgC(Color(75, 220, 75), '(Arko) ', Color(255, 255, 255), 'Addons loaded!\n') end
    end
}

arko.run()