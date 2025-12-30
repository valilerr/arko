<img width="1024" height="128" alt="arko_wide" src="https://github.com/user-attachments/assets/9e94d826-e263-482a-8b25-52b7029c445f" />

# Arko GMod Library
**Arko is a GMod Library that have been made to simplify GLua coding. If you have questions or issues about it, please text me here or in discord(valilerr)** 

***Current version: 0.55***

*this library in development stage and may contain a lot of bugs*

[*Arko in Steam Workshop*](https://steamcommunity.com/sharedfiles/filedetails/?id=3610914065)

## Guide:

- ***arko: {} - main table***
  - ### core: {} - arko's core table
    - ### run: function() 
    *- function that runs the arko's core.*

    - ### isLoaded: bool 
    *- bool value that shows arko's core is loaded or not.*

  - ### ui: {} - arko's ui table
    - ### run: function() 
    *- function that run the arko's ui.*

    - ### isLoaded: bool 
    *- bool value that shows arko's ui is loaded or not.*

  - ### addons: {} - arko's addons table
    - ### run: function() 
    *- function that run the arko's addons.*

    - ### isLoaded: bool 
    *- bool value that shows arko's addons are loaded or not.*

  - ### run: function() - function that run the arko



  - ### func: {} - arko's functions table
    - ### animateAlpha: function(panel, duration, close_bool(optional)) 
    *- function that animates panel's alpha value. If close_bool is false then alpha value will be changed from 0 to 255 else if close_bool is true then alpha value will be changed from 255 to 0 and panel will close.* 
    *Example:*
    ```lua
        local frame = vgui.Create('arko.frame')
        frame:SetSize(ScrW() * .5, ScrH() * .5)
        frame:Center()

        --Open
        arko.func.animateAlpha(frame, .2)

        --Close
        arko.func.animateAlpha(frame, .2, true)
    ```

    - ### animatePos: function(panel, oldPos[x, y], newPos[x, y], duration) 
    *- function that animates panel's position from oldPos to newPos.*
    *Example:*
    ```lua
    local frame = vgui.Create('arko.frame')
    frame:SetSize(ScrW() * .5, ScrH() * .5)
    frame:Center()

    arko.func.animatePos(frame, frame:GetPos(), {ScrW() * .2, ScrH() * .1}, .2)
    ```

    - ### animateSize: function(panel, oldSize[w, h], newSize[w, h], duration) 
    *- function that animates panel's size from oldSize to newSize.*
    *Example:*
    ```lua
    local frame = vgui.Create('arko.frame')
    frame:SetSize(ScrW() * .5, ScrH() * .5)
    frame:Center()

    arko.func.animateSize(frame, frame:GetSize(), {ScrW(), ScrH()}, .2)
    ```

    - ### animateValue: function(oldValue, newValue, duration)
    *- function that animates value from oldValue to newValue.*
    *Example:*
    ```lua
    arko.func.animateValue(150, 50, 1)
    ```

    - ### notify: function(player, text, type("generic", "error", "hint", "undo"), duration)
    *- function that opens the notify panel on player's screen.*
    *Example:*
    ```lua
    arko.func.notify(LocalPlayer(), "Notification text", "generic", 5)
    ```

    - ### ply: function(steamid)
    *- function that finds a player by steamid32 or steamid64.*
    *Example:*
    ```lua
    arko.func.ply(76561199060521595) // It's my SteamID64
    ```

    - ### drawIcon: function(x, y, w, h, color, icon)
    *- function that draws an icon with parameters.*
    *Example:*
    ```lua
    arko.func.drawIcon(0, 0, 64, 64, Color(255, 255, 255), Material('test.png'))
    ```

    - ### getTextSize: function(text, font)
    *- function that returns text size.*
    *Example:*
    ```lua
    arko.func.getTextSize('Play', 'arko.font20')
    ```

  - ### data: {} - arko's data functions table (all functions edit garrysmod/data/arko directory)

    - ### init: function() - function that creates the default arko_data's files

    - ### write: function(dir, fileName, content, cl_or_sv(CLIENT, SERVER))
    *- function that writes a file with [content] in arko/[dir]/[fileName].*
    *Example:*
    ```lua
    arko.data.write('my_addon', 'food.txt', 'Apple, Banana, Strawberry', CLIENT)
    ```

    - ### append: function(dir, fileName, content, cl_or_sv(CLIENT, SERVER))
    *- function that appends a [content] to file in data/arko/[dir]/[fileName].*
    *Example:*
    ```lua
    arko.data.append('my_addon', 'food.txt', ', Bread, Potato', CLIENT)
    ```

    - ### get: function(path, cl_or_sv(CLIENT, SERVER))
    *- function that returns content of file in arko/[path].*
    *Example:*
    ```lua
    arko.data.get('my_addon/food.txt', CLIENT)
    ```

    - ### delete: function(path, cl_or_sv)
    *- function that removes file in arko/[path].*
    *Example:*
    ```lua
    arko.data.delete('my_addon/food.txt', CLIENT)
    ```