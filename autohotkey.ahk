#Requires AutoHotkey v2.0

; /------------------\
; | Keyboard Symbols |
; \------------------/

; # Windows key		! Alt
; ^ Ctrl		+ Shift

; /---------------------------\
; | Frequently used shortcuts |
; \---------------------------/

::link-auto::[auto entities](<https://github.com/thomasloven/lovelace-auto-entities>)
::link-bm::[browser_mod](<https://github.com/thomasloven/hass-browser_mod>)
::link-cm::[card_mod](<https://github.com/thomasloven/lovelace-card-mod>)
::link-cb::[custom:button-card](<https://github.com/custom-cards/button-card>)
::link-declutter::[Decluttering card](<https://github.com/custom-cards/decluttering-card>)
::link-ftb::[Fire Toolbox](<https://xdaforums.com/t/windows-linux-tool-fire-toolbox-v32-4.3889604/>)
::link-fully::[Fully Kiosk Browser](<https://www.fully-kiosk.com/>)
::link-hacs::[HACS](<https://hacs.xyz/>)
::link-kiosk-mode::[Kiosk Mode](<https://github.com/NemesisRE/kiosk-mode>)
::link-layout::[layout-card](<https://github.com/thomasloven/lovelace-layout-card>)
::link-mush::[Mushroom card](<https://github.com/piitaya/lovelace-mushroom>)
::link-stack::[custom:stack-in-card](<https://github.com/stickpin/stack-in-card>)
::link-cache::[Clearing your browser cache](<https://github.com/thomasloven/hass-config/wiki/Clearing-your-browser-cache>)
::link-github::[My GitHub](<https://github.com/dsellers1/home-assistant>)
::link-concepts::[My GitHub - Concepts](<https://github.com/dsellers1/home-assistant/blob/main/concepts.md>)
::link-examples::[My GitHub - Examples](<https://github.com/dsellers1/home-assistant/blob/main/examples.md>)

::cb::custom:button-card
::cm::card-mod

::symbol-degree::°
::symbol-degreeF::°F
::symbol-degreeC::°C

; /-------------------------------\
; | Experimental and testing zone |
; \-------------------------------/

; Create the popup menu by adding some items to it.
MyMenu := Menu()
MyMenu.Add "640x480", MenuHandler ;
MyMenu.Add "800x600", MenuHandler ;
MyMenu.Add "1024x768", MenuHandler ;
MyMenu.Add "1280x720", MenuHandler ;High Definition (HD) 720p 16:9
;MyMenu.Add "1280x800", MenuHandler ;High Definition (HD) 720p 16:10
MyMenu.Add "1920x1080", MenuHandler ;Full HD (FHD) 1080p 16:9
;MyMenu.Add "2560x1440", MenuHandler ;2K Quad HD (QHD)
;MyMenu.Add "3840x2160", MenuHandler ;4K Ultra HD (UHD)
MyMenu.Add  ; Add a separator line.

; Create another menu destined to become a submenu of the above menu.
Submenu1 := Menu()
Submenu1.Add "Amazon Echo Show 15 (Landscape)", MenuHandler
Submenu1.Add "Amazon Echo Show 15 (Portrait)", MenuHandler
Submenu1.Add "Amazon Echo Show 8", MenuHandler
Submenu1.Add "Amazon Fire 10", MenuHandler
;Submenu1.Add "Amazon Fire 8", MenuHandler

; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
MyMenu.Add "Devices", Submenu1

;MyMenu.Add  ; Add a separator line below the submenu.
MyMenu.Add "Cancel", MenuHandler

MenuHandler(Item, *) {
    ;MsgBox "You selected " Item
    if (Item = "640x480") 
	new_x := 640, new_y := 480
    if (Item = "800x600") 
	new_x := 800, new_y := 600
    if (Item = "1024x768") 
	new_x := 1024, new_y := 768    
    if (Item = "1280x720") 
	new_x := 1280, new_y := 720 
    if (Item = "1920x1080") 
	new_x := 1920, new_y := 1080
    if (Item = "Amazon Echo Show 15 (Landscape)") 
	new_x := 1280, new_y := 800
    if (Item = "Amazon Echo Show 15 (Portrait)") 
	new_x := 800, new_y := 1280
    if (Item = "Amazon Echo Show 8") 
	new_x := 1200, new_y := 800
    if (Item = "Amazon Fire 10") 
	new_x := 1920, new_y := 1200   

;Need to check if Maximized, if true then unMaximize

    ;Resize the window to the dimensions and center on screen
    WinMove , ,new_x,new_y, "A"
    WinGetPos &Xpos, &Ypos, &Width, &Height, "A"
    WinMove (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2),,, "A"
}

#z::MyMenu.Show  ; i.e. press the Win-Z hotkey to show the menu.

^e::
{
Run "Excel.exe"
return
}

#X::
{  
xx := FormatTime(,"yyyyMMdd")
SendInput(xx)
return
}