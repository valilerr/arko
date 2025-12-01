--[[
    Arko - GMod Library 
    
    by valilerr
    Discord: valilerr
]]

arko = arko or {
    version = '0.4',
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
        print('Arko(' .. arko.version .. ') by VALIL')
        arko.init('arko/sh_cfg.lua')
        arko.core.run() 
        print('Core loaded!')

        arko.ui.run()
        print('UI loaded!')

        arko.addons.run()
        print('Addons loaded!')

        if SERVER then
            resource.AddWorkshop("3610914065")
        end

        arko.isLoaded = true
        arko.loadTime = math.Round(SysTime() - arko.loadTime, 3)
        print('] Arko loaded in ' .. arko.loadTime .. ' seconds!')
        
        print('')
    end
}

arko.run()