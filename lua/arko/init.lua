--[[
    Arko
    Author: valilerr
    Discord: valilerr
]]

arko = arko or {
    version = 'dev',
    init = function(path)
        local function initFile(filePath)
            if string.find(filePath, "sh_") then
                if SERVER then
                    AddCSLuaFile(filePath)
                    include(filePath)
                    print("Shared File [" .. filePath .. "] loaded.")
                else
                    include(filePath)
                    print("Shared File [" .. filePath .. "] loaded.")
                end
            elseif string.find(filePath, "sv_") then
                if SERVER then
                    include(filePath)
                    print("Server File [" .. filePath .. "] loaded.")
                end
            elseif string.find(filePath, "cl_") then
                if SERVER then
                    AddCSLuaFile(filePath)
                    print("Client File [" .. filePath .. "] loaded.")
                else
                    include(filePath)
                    print("Client File [" .. filePath .. "] loaded.")
                end
            end
        end

        local function initFolder(folderPath)
            local files, directories = file.Find(folderPath .. "/*", "LUA")

            for _, fileName in ipairs(files) do
                arko.init(folderPath .. "/" .. fileName)
            end

            for _, folderName in ipairs(directories) do
                arko.init(folderPath .. "/" .. folderName)
            end
        end

        if string.find(path, ".lua") then
            initFile(path)
        else
            initFolder(path)
        end

    end,
    isLoaded = false,
    loadTime = 0,
    core = {
        run = function()
            arko.init("arko/core")
        end
    },
    ui = {
        run = function()
            arko.init("arko/ui")
        end
    },
    addons = {
        run = function()
            arko.init("arko_addons")
        end
    },
    run = function()
        arko.loadTime = SysTime()
        arko.isLoaded = false 
        print('')
        print('Arko(' .. arko.version .. ') by VALIL')
        arko.init("arko/sh_cfg.lua")
        arko.core.run() 
        print('Core loaded!')

        arko.ui.run()
        print('UI loaded!')

        arko.addons.run()
        print('Addons loaded!')
        arko.isLoaded = true
        arko.loadTime = math.Round(SysTime() - arko.loadTime, 3)
        print('] Arko loaded in ' .. arko.loadTime .. 'seconds!')
        
        print('')
    end
}

arko.run()