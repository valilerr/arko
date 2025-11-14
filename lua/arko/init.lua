/*

Arko Lib For Garry's Mod
Author: valilerr
Discord: valilerr

*/

arko = arko or {
    VERSION = 0.1,
    init = function(path)
        local function initFile(filePath)
            if string.find(filePath, "sh_") then
                if SERVER then
                    AddCSLuaFile(filePath)
                    include(filePath)
                else
                    include(filePath)
                end
            elseif string.find(filePath, "sv_") then
                if SERVER then
                    include(filePath)
                end
            elseif string.find(filePath, "cl_") then
                if SERVER then
                    AddCSLuaFile(filePath)
                else
                    include(filePath)
                end
            end
            print("File [" .. filePath .. "] loaded.")
        end
        local function initFolder(folderPath)
            local files, dirs = file.Find(folderPath .. "/*", "LUA")

            for _, file in ipairs(files) do
                arko.init(folderPath .. "/" .. file)
            end

            for _, dir in ipairs(dirs) do
                initFolder(folderPath .. "/" .. dir)
            end
        end

        if string.find(path, ".lua") then
            initFile(path)
        else
            initFolder(path)
        end
    end,
    COMPONENTS = {
        run = function()
            print("Components:")
            arko.init("arko/components")
            print("Components loaded.")
        end
    },
    UI = {
        run = function()
            print("UI:")
            arko.init("arko/ui")
            print("UI loaded.")
        end
    },
    run = function()
        local startTime = SysTime()
        arko.isLoaded = false
        print("")
        print("Arko[" .. arko.VERSION .. "] Loading...")
        arko.init("sh_cfg.lua")
        arko.COMPONENTS.run()
        arko.UI.run()
        arko.isLoaded = true
        print("Loaded in " .. math.Round(SysTime() - startTime, 3) .. " seconds.")
        print("")
    end
}

arko.run()