addEventHandler("onClientResourceStart", resourceRoot, function()
    createNativeUI("test", false, "assets/24.png", false, tocolor(255, 152, 0), tocolor(255, 255, 255), "right", true, false,10,"left")
    for i = 1, 50 do
        if (i % 2 == 0) then
            icontype = "clothing"
        else
            icontype = "ammo"
        end
        addNativeButton("This is Вот,  держи ["..i.."]", "#ff9800",icontype)
        addNativeSwitch("Switch Test", {"Ketchup", "Majonez"})
    end
    setTimer(function()
        setNativeSwitchSelection(2,"Majonez")
    end, 2000, 1)
end)

addEventHandler("onClientAcceptSwitch", getRootElement(), function(id, value)
    print(value)
end)
addEventHandler("onClientChangeSwitch", getRootElement(), function(id, value)
    print(value)
end)
