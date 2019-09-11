window = {
    options={}
}

local sound
local actual = 1
isNativeShown = false
switch={}

function createNativeUI(name, title, image, color, namecolor, titlecolor, align, counter, scroll, scrollitems, namealign)
    if isNativeShown then return false end
    if name == "" then
        assert(type(name) == string, "Bad argument @ createNativeUI [expected string at argument 1,  got "..type(name).." '"..name.."'']")
    end
    if title then
        assert(title and tostring(title), "Bad argument @ createNativeUI [expected string at argument 2,  got "..type(title).." '"..title.."'']")
    end
    if not image then
        assert(color, "[Native UI]No specified image and not specified color")
    end
    if align then
        assert(align == "left" or align == "right", "Invalid align type @ createNativeUI [expected 'left'/'right' at argument 7,  got"..type(align).." '"..align.."'']")
    end
    if namealign then
        assert(namealign == "left" or namealign == "center" or namealign == "right","Invalid menu-align type @ createNativeUI [expected 'left'/'center'/'right' at argument 11,  got"..type(align).." '"..align.."'']")
    end
    if not namealign then
        namealign = "center"
    end
    window = {}
    window.items={}
    zoom = getZoom()
    window.name = name
    window.title = title or "Native UI"
    local scale = scaleScreen(10, 10, 431, 107, align, "top")
    window.namepos = Vector2(unpack(scale, 1), unpack(scale, 2))
    window.namesize = Vector2(unpack(scale, 3), unpack(scale, 4))
    if namealign == "left" then
        pos = window.namepos["x"]+(15/zoom)
    elseif namealign == "center" then
        pos = window.namepos["x"]+(window.namesize["x"]/2)
    elseif namealign == "right" then
        pos = window.namepos["x"]+(window.namesize["x"]-(15/zoom))
    end
    window.namealign = namealign
    window.namepos2 = Vector2(pos, window.namepos["y"]+(window.namesize["y"]/1.75))
    local scale = scaleScreen(0, 0, 431, 37, "left", "top")
    window.titlepos = Vector2(window.namepos["x"], window.namepos["y"]+window.namesize["y"])
    window.titlesize = Vector2(unpack(scale, 3), unpack(scale, 4))
    window.titlepos2 = Vector2(window.titlepos["x"]+(15/zoom), window.titlepos["y"]+(window.titlesize["y"]/2))
    window.titlepos3 = Vector2(window.titlepos["x"]+window.titlesize["x"]-(15/zoom), window.titlepos["y"]+(window.titlesize["y"]/2))
    window.namefont = dxCreateFont("assets/fonts/font.ttf", 55/zoom)
    window.titlefont = dxCreateFont("assets/fonts/fonttitle.ttf", 18/zoom, false)
    window.image = image or "assets/defaultbg.png"
    window.namecolor = namecolor or tocolor(255, 255, 255)
    window.titlecolor = titlecolor or tocolor(255, 255, 255)
    window.counter = counter or false
    window.scroll = scroll or false
    if not scrollitems or scrollitems > 10 then
        scrollitems = 10
    end
    local scale = scaleScreen(0,0,50,50)
    window.iconscale = Vector2(unpack(scale,3),unpack(scale,4))
    window.scrollitems = scrollitems
    bindKeys()
    isNativeShown = true
    addEventHandler("onClientRender", getRootElement(), renderNative)
end

function renderNative()
    dxDrawImage(window.namepos, window.namesize, window.image)
    dxDrawRectangle(window.titlepos, window.titlesize, tocolor(0, 0, 0))
    dxDrawText(window.title, window.titlepos2, nil, nil, window.titlecolor, 1, window.titlefont, "left", "center")
    if window.counter then
        dxDrawText(actual.."/"..#window.items, window.titlepos3, nil, nil, window.titlecolor, 1, window.titlefont, "right", "center")
    end
    if window.name then
        dxDrawText(window.name, window.namepos2, nil, nil, window.namecolor, 1, window.namefont, window.namealign, "center")
    end
    for i, v in pairs(window.items) do
        page = math.ceil(i/window.scrollitems)
        dxDrawText(getCurrentNativePage(), 0, 0, 0, 0)
        if i > window.scrollitems*(getCurrentNativePage()-1) and i <= window.scrollitems*getCurrentNativePage() then
            i=i-window.scrollitems*(getCurrentNativePage()-1)
            if actual-window.scrollitems*(getCurrentNativePage()-1) == i then
                color = tocolor(255, 255, 255, 255*0.6)
                textcolor = tocolor(0, 0, 0, 255)
            else
                local multiplier = 255*(0.03*i)
                color = tocolor(0, 0, 0, 255-multiplier)
                textcolor = v.color
            end
            local pos = Vector2(window.titlepos["x"], window.titlepos["y"]+window.titlesize["y"]+(window.titlesize["y"]*(i-1)))
            dxDrawRectangle(pos, window.titlesize, color)
            local pos = Vector2(window.titlepos["x"]+(15/zoom), window.titlepos["y"]+window.titlesize["y"]/2+(window.titlesize["y"]*(i)))
            dxDrawText(v.text, pos, nil, nil, textcolor, 1, window.titlefont, "left", "center")
            if v.type == "switch" then
                local pos = Vector2(window.titlepos["x"]+window.titlesize["x"]-(15/zoom), window.titlepos["y"]+window.titlesize["y"]/2+(window.titlesize["y"]*(i)))
                local actual = tonumber(v.actual)
                dxDrawText("⮜ "..v.value[actual].." ⮞", pos, nil, nil, textcolor, 1, window.titlefont, "right", "center")
            elseif v.type == "button" and v.icon then
                local pos = Vector2(window.titlepos["x"]+window.titlesize["x"]-(60/zoom), window.titlepos["y"]+window.titlesize["y"]/2+(window.titlesize["y"]*(i-1))+(12/zoom))
                if actual-window.scrollitems*(getCurrentNativePage()-1) == i then
                    imgtype = 2
                else
                    imgtype = 1
                end
                dxDrawImage(pos,window.iconscale,"assets/icons/"..v.icon..""..imgtype..".png")
            end
            if #window.items > window.scrollitems  then
                local pos = Vector2(window.titlepos["x"], window.titlepos["y"]+window.titlesize["y"]+(window.titlesize["y"]*(10)))
                dxDrawRectangle(pos, window.titlesize, tocolor(0, 0, 0, 255*0.4))
                local pos = Vector2(window.titlepos["x"]+(window.titlesize["x"]/2), window.titlepos["y"]+window.titlesize["y"]/2+(window.titlesize["y"]*(11)))
                if actual == 1 then
                    text = "⮟"
                elseif actual == #window.items then
                    text = "⮝"
                else
                    text = "⮝ \ ⮟"
                end
                dxDrawText(text, pos, nil, nil, tocolor(255, 255, 255), 1, window.titlefont, "center", "center")
            end
        end
    end
end

addEventHandler("onClientKey", getRootElement(), function(btn, state)
    if not isNativeShown then return end
    if btn == "arrow_d" and state == true then
        cancelEvent()
    end
    if btn == "arrow_u" and state == true then
        cancelEvent()
    end
    if btn == "arrow_r" and state == true then
        cancelEvent()
    end
    if btn == "arrow_l" and state == true then
        cancelEvent()
    end
    if btn == "enter" and state == true then
        cancelEvent()
    end
end)

function bindKeys()
    bindKey("arrow_d", "up", function()
        if not isNativeShown then return end
        if #window.items == 0 then return end
        if actual+1 > #window.items then
            actual = 1
        else
            actual = actual+1
        end
        playNativeSound()
    end)
    bindKey("arrow_u", "up", function()
        if not isNativeShown then return end
        if #window.items == 0 then return end
        if actual-1 < 1 then
            actual = #window.items
        else
            actual = actual-1
        end
        playNativeSound()
    end)
    bindKey("arrow_r", "up", function()
        if not isNativeShown then return end
        if #window.items == 0 then return end
        if window.items[actual].type == "switch" then
            window.items[actual].actual = window.items[actual].actual+1
            if window.items[actual].actual > #window.items[actual].value then window.items[actual].actual = 1 end
            playNativeSound()
            local actualswitch = window.items[actual].actual
            local actualswitch = window.items[actual].value[tonumber(actualswitch)]
            triggerEvent("onClientChangeSwitch", localPlayer, actual, actualswitch)
        end
    end)
    bindKey("arrow_l", "up", function()
        if not isNativeShown then return end
        if #window.items == 0 then return end
        if window.items[actual].type == "switch" then
            window.items[actual].actual = window.items[actual].actual-1
            if window.items[actual].actual < 1 then window.items[actual].actual = #window.items[actual].value end
            local actualswitch = window.items[actual].actual
            local actualswitch = window.items[actual].value[tonumber(actualswitch)]
            triggerEvent("onClientChangeSwitch", localPlayer, actual, actualswitch)
            playNativeSound()
        end
    end)
    bindKey("enter", "up", function()
        if not isNativeShown then return end
        if #window.items == 0 then return end
        if window.items[actual].type == "switch" then
            local actualswitch = window.items[actual].actual
            local actualswitch = window.items[actual].value[tonumber(actualswitch)]
            triggerEvent("onClientAcceptSwitch", localPlayer, actual, actualswitch)
        end
    end)
end

function playNativeSound()
    if isElement(sound) then
        destroyElement(sound)
        sound = playSound("assets/change.wav", false)
    else
        sound = playSound("assets/change.wav", false)
    end
end

function getCurrentNativePage()
    local currentpage = math.ceil(actual/window.scrollitems)
    return currentpage
end

function clearNativeUI()
    window.items = {}
    actual = 0
end

function removeNativeItem(id)
    table.remove(window.items, id)
end

function removeNativeUI()
    removeEventHandler("onClientRender",getRootElement(),renderNative)
    window = {}
    actual = 0
    isNativeShown = false
end

function addNativeButton(text, color,icon)
    if icon then
        assert(icon ~= "box","Invalid icon type @ addNativeButton [got"..type(icon).." '"..icon.."'']")
    end
    if type(color) == "string" then
        color = tocolor(getColorFromString(color))
    end
    color = color or tocolor(255, 255, 255)
    local table = {
        ["type"] = "button",
        ["color"] = color,
        ["text"] = text,
        ["icon"] = icon or false
    }
    window.items[#window.items+1] = table
end

function setNativeButtonIcon(id,icon)
    if not id or not icon then return end
    assert(tonumber(id),"Bad argument @ setNativeButtonIcon [expected number at argument 1,  got "..type(id).." '"..id.."'']")
    assert(icon ~= "box","Invalid icon type @ addNativeButton [got"..type(icon).." '"..icon.."'']")
    window.items[id].icon = icon
end

function removeNativeButtonIcon(id)
    if not id then return end
    assert(tonumber(id),"Bad argument @ setNativeButtonIcon [expected number at argument 1,  got "..type(id).." '"..id.."'']")
    window.items[id].icon = false
end

