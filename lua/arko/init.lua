--[[
    Arko - GMod Library 
    
    by valilerr
    Discord: valilerr
]]

arko = arko or {
    version = '0.7',
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
    workshop = {
        run = function()
            if SERVER then
                resource.AddWorkshop("3610914065")
            end
            arko.workshop.isLoaded = true
        end
    },
    addons = {
        run = function()
            local _, directories = file.Find('arko_addons/*', 'LUA')

            for _, dir in ipairs(directories) do
                arko.init('arko_addons/' .. dir .. '/' .. arko.getCfg('addonInitFile'))
                arko.msg('Addons', dir .. ' loaded!\n')
            end

            arko.addons.isLoaded = true
        end,
        isLoaded = false
    },
    msg = function(prefix, text)
        MsgC(Color(75, 220, 75), '(' .. prefix .. ') ', Color(255, 255, 255), text)
    end,
    msgError = function(prefix, text)
        MsgC(Color(220, 75, 75), '(' .. prefix .. ') ' .. text)
    end,
    run = function()
        if arko.isLoaded then
            arko.msg('Arko', 'Restarting all library...\n')
        end
        arko.loadTime = SysTime()
        arko.isLoaded = false 
        print('')

        arko.msg('Arko[v' .. arko.version .. '] loading...\n')

        arko.init('arko/sh_cfg.lua')

        arko.core.run() 
        if arko.core.isLoaded then arko.msg('Core', 'Loaded in ' .. math.Round(SysTime() - arko.loadTime, 3) .. ' seconds.\n') end

        arko.ui.run()
        if arko.ui.isLoaded then arko.msg('UI', 'Loaded in ' .. math.Round(SysTime() - arko.loadTime, 3) .. ' seconds.\n') end

        arko.workshop.run()
        if arko.workshop.isLoaded then arko.msg('Workshop', 'Loaded in ' .. math.Round(SysTime() - arko.loadTime, 3) .. ' seconds.\n') else arko.msgError('Arko Workshop', 'A problem occured with workshop!') end

        arko.isLoaded = true
        arko.loadTime = math.Round(SysTime() - arko.loadTime, 3)
        
        arko.msg('Arko',  'Loaded in ' .. arko.loadTime .. ' seconds.\n')
        
        print('')

        arko.addons.run()
        if arko.addons.isLoaded then arko.msg('Arko', 'Addons loaded!\n') else arko.msgError('Arko Addons', 'A problem occured with addons!\n') end
    end
}

arko.run()