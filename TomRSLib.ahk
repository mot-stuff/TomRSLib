;;;;; Tom's Runescape Library ;;;;; Stored on Github for live updating
;
; - This library contains useful functions for coding ahk bots in runescape. Use #Include TomRSLib.ahk and it will compile into your script when you package it as an exe. 
; - Most of the function in this library can only be used in resizable classic mode or fixed mode. It only reads game screen
; #Include C:\Users\tomal\OneDrive\Documents\GitHub\TomRSLib\TomRSLib.ahk
;
; !!!!!!!! IMPORTANT: Make sure to include getinventory() when intialziing. It will grab all globals needed. Use the globals it writes to be able to make anything work for any resolution automatically
;
; Feel free to comment and suggest updates.
;
; Use ShinsImageScanClass and ShinsOverlayClass for some improved direct2d graphics and some better image searching if needed. or just use findtext
; - included in my github
;
; LATEST UPDATE: 1/6/23
; =====================; Function List ;===================== ;
;
; -- setup(x): Use "North", "South", "East" , or "West" in place of x to setup for the script
; -- clickspot(color): Searches near character when fully zoomed out to full screen
; -- waitbank(sec): returns true or false if bank window is open, will scan for the amount of seconds you want it to, return true or false to perform actions
; -- checkminimap(color): checks for a color on the minimap and returns true or false
; -- mmpathing(color): clicks a color on the minimap and then waits til your character is next to it in game
; -- checkdrop(color): will check if inventory is full in the last spot and drop only marked items
; -- findspot(color,x,y,w,h): finds a spot on the screen and clicks it, always the center but randomized offset built in
; -- findspotright(color,x,y,w,h): finds a spot on the screen and right clicks it
; -- weightedclick(min, target, max): min, max, target, generates a value 
; -- randsleep(x,y): randomized sleep between two values
; -- antiban(x) - randomized small sleeps with the ability to set a percentage
; -- antibanstats() - perfectly waited for randomly checking thes stats page for a few seconds, just place into a function that is looping or where you want the chance of checking the page. I personally place it in downtime loops
; -- antibanfriends() - perfectly weighted to check friends list randomly for a few seconds  
; -- checkobject(color): checks if a specific color is on screen and returns true or flase
; -- checklast(color): checks last spot in inventory and returns true or false
; -- checkhwid(x): checks hwid from a list store at a link, reads txt file with HWIDS in it and checks the HWID of the user. Good for security
; -- UUID(): Grabs the current users HWID to compare against the list
; -- combine(color1,color2,sendspace): Uses one color on another in the inventory, just uses the slots function using inventory coordinates. 0 is no for sending spacebar, 1 is yes
; -- zoomin(x) and zoomout(x): sends the wheel in either direction, pretty straight forward
; -- the findtext() function is included in this script. Only use the tool to grab images.
; -- getinventory(): grabs the classic inventory coords in resizeable or fixed, can be used to scale up almost any script
; -- getinventory has lots of subfunctions here including all of the pk swapping and the swap(color) function which is extremely useful
; -- radial(color,spot): searches from center of play area, 10px each loop out and then spot parameter is for how big to search from cursor
; -- slots(color,x,y), slotsrange(color,x,y): first is for regular 2nd is for pking
; lots of other functions in here now, please explore

; ========== To do ========= ;
; - Code a logout function
; - code more antiban functions and an antiban wrapper for selecting random types of antiban
; - give things more options as needed and expand on function list. Need new projects to come up with new functions
;
;
;
;
;
; ==============================================================================================================================================================================================================================;
;
; All of these functions in this library are designed to handle fixed and resizeable classic game window styles. No additions or anything else.
; After exploring the code you will notice there are colors used on the screen, run a debug search with the functions necesssary to see how the positions are being calculated. getinventory() is the most OP function
;
;
;
;----------- Start library -----------------;






getplayarea(){ ;useless
WinGetPos,xx, yy, ww, hh,ahk_class SunAwtFrame

global playable_topleftx := xx
global playable_toplefty := yy
global playable_bottomrightx := ww - 210
global playable_bottomrighty := hh

IniWrite, %playable_topleftx%, inventory, screen, playable_topleftx
IniWrite, %playable_toplefty%, inventory, screen, playable_toplefty
IniWrite, %playable_bottomrightx%, inventory, screen, playable_bottomrightx
IniWrite, %playable_bottomrighty%, inventory, screen, playable_bottomrighty
IniRead, playable_topleftx, inventory, screen, playable_topleftx
IniRead, playable_toplefty, inventory, screen, playable_toplefty
IniRead, playable_bottomrightx, inventory, screen, playable_bottomrightx
IniRead, playable_bottomrighty, inventory, screen, playable_bottomrighty
}



























CenterWindow(WinTitle) ;probably useless but forces fixed if needed
{
    WinGetPos,,, Width, Height, %WinTitle%
    WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2), 806,533
}


;move guis

OnMessage( 0x200, "WM_MOUSEMOVE" )

WM_MOUSEMOVE( wparam, lparam, msg, hwnd )
{
	if wparam = 1 ; LButton
		PostMessage, 0xA1, 2,,, A ; WM_NCLBUTTONDOWN
}
; end move guis




;; !!! Initialize bots with this. It gets all cords based off of the stats icon blue color, very dark blue
;;; !!! compass color intitialized from world map orb, and offset depending on if fixed or resizeable, fixed must have sides dragged in, which just makes sense anyways
;
; This function is the driver of everything. For RSPS that is runelite driven this should work as well
getinventory(){
WinActivate, ahk_class, SunAwtFrame

  
Pixelsearch, compassx2,compassy2,0, 0, A_ScreenWidth, A_ScreenHeight,0x161F07, 0, Fast RGB
    If (errorlevel = 0)
    {
      WinGetActiveStats, Runelite, Width, Height, X, Y
If Width <= 810
{
    global compassx := compassx2-168
}
If Width > 810
{
    global compassx := compassx2-149
}
If Height <= 650
{
   global compassy := compassy2-110
}
If Height > 650
{
   global compassy := compassy2-115
}
        global qpx := compassx-18
        global qpy := compassy+75
         global mapcenterxx :=  qpx + 90
        global mapcenteryy := qpy - 20
    }   


Pixelsearch, px,py,0, 0, A_ScreenWidth, A_ScreenHeight,0x28263C, 0, Fast RGB
    If (errorlevel = 0)
    {
    ; start first row
      global itopleftx := px-42
      global itoplefty := py+19
     global ibottomrightx := px+155
      global ibottomrighty := py + 268
      global slot1x := itopleftx+17
      global slot1y := itoplefty+8
      global slot1w :=itopleftx+45
      global slot1h :=itoplefty+30

      global slotx1 := (slot1x + slot1w)/2
      global sloty1 := (slot1y + slot1h)/2

      global slot2x := slot1x+40
      global slot2y := slot1y + 0
      global slot2w := slot1w +40
      global slot2h := slot1h + 0

      global slotx2 := (slot2x + slot2w)/2
      global sloty2 := (slot2y + slot2h)/2

      global slot3x := slot2x+40
      global slot3y := slot2y + 0
      global slot3w := slot2w +40
      global slot3h := slot1h + 0

      global slotx3 := (slot3x + slot3w)/2
      global sloty3 := (slot3y + slot3h)/2

      global slot4x := slot3x+40
      global slot4y := slot3y + 0
      global slot4w := slot3w + 40
      global slot4h := slot3h + 0

      global slotx4 := (slot4x + slot4w)/2
      global sloty4 := (slot4y + slot4h)/2
    ;end first row


    ; start second row
      global slot5x := slot1x - 3
      global slot5y := slot1y + 32
      global slot5w := slot1w+5
      global slot5h := slot1h + 35

      global slotx5 := (slot5x + slot5w)/2
      global sloty5 := (slot5y + slot5h)/2


      global slot6x := slot5x + 40
      global slot6y := slot5y +0
      global slot6w := slot6x + 35
      global slot6h := slot5h


      global slotx6 := (slot6x + slot6w)/2
      global sloty6 := (slot6y + slot6h)/2


      global slot7x :=slot6x + 40
      global slot7y := slot5y +0
      global slot7w := slot7x + 40
      global slot7h := slot6h

      global slotx7 := (slot7x + slot7w)/2
      global sloty7 := (slot7y + slot7h)/2

      global slot8x := slot7x + 44
      global slot8y := slot5y +0
      global slot8w := slot8x + 40
      global slot8h := slot6h

      global slotx8 := (slot8x + slot8w)/2
      global sloty8 := (slot8y + slot8h)/2

      
    ;end second row

    ; start third row
      global slot9x := slot1x + 0
      global slot9y := slot5y + 35
      global slot9w := slot1w
      global slot9h := slot5h + 35
  
      global slotx9 := (slot9x + slot9w)/2
      global sloty9 := (slot9y + slot9h)/2


      global slot10x := slot9x + 40
      global slot10y := slot9y +0
      global slot10w := slot9w + 40
      global slot10h := slot9h

      global slotx10 := (slot10x + slot10w)/2
      global sloty10 := (slot10y + slot10h)/2

      global slot11x :=slot10x + 40
      global slot11y := slot9y +0
    global slot11w := slot10w + 40
      global slot11h := slot9h

      global slotx11 := (slot11x + slot11w)/2
      global sloty11 := (slot11y + slot11h)/2

      global slot12x := slot11x + 40
      global slot12y := slot9y +0
    global slot12w := slot11w + 40
      global slot12h := slot9h

          global slotx12 := (slot12x + slot12w)/2
      global sloty12 := (slot12y + slot12h)/2
    ; end third row


    ; fourth row start
        global slot13x := slot1x + 0
      global slot13y := slot9y + 35
      global slot13w := slot1w
      global slot13h := slot9h + 35

      global slotx13 := (slot13x + slot13w)/2
      global sloty13 := (slot13y + slot13h)/2



      global slot14x := slot13x + 40
      global slot14y := slot13y +0
      global slot14w := slot13w+40
      global slot14h := slot13h


      global slotx14 := (slot14x + slot14w)/2
      global sloty14 := (slot14y + slot14h)/2


      global slot15x :=slot14x + 40
      global slot15y := slot13y +0
      global slot15w := slot14w+40
      global slot15h := slot13h


      global slotx15 := (slot15x + slot15w)/2
      global sloty15 := (slot15y + slot15h)/2



      global slot16x := slot15x + 40
      global slot16y := slot13y +0
        global slot16w := slot15w+40
      global slot16h := slot13h

  global slotx16 := (slot16x + slot16w)/2
      global sloty16 := (slot16y + slot16h)/2

    ; fourth row end


    ;fifth row start

        global slot17x := slot1x + 0
      global slot17y := slot13y + 35
      global slot17w := slot1w
      global slot17h := slot13h + 35


  global slotx17 := (slot17x + slot17w)/2
      global sloty17 := (slot17y + slot17h)/2
  
      global slot18x := slot17x + 40
      global slot18y := slot17y +0
      global slot18w := slot17w + 40
      global slot18h := slot17h

  global slotx18 := (slot18x + slot18w)/2
      global sloty18 := (slot18y + slot18h)/2


      global slot19x :=slot18x + 40
      global slot19y := slot17y +0
      global slot19w := slot18w + 40
      global slot19h := slot17h

  global slotx19 := (slot19x + slot19w)/2
      global sloty19 := (slot19y + slot19h)/2

      global slot20x := slot19x + 40
      global slot20y := slot17y +0
      global slot20w := slot19w + 40
      global slot20h := slot17h

  global slotx20 := (slot20x + slot20w)/2
      global sloty20 := (slot20y + slot20h)/2


    ;fifth row end






    ; sixth row start
        global slot21x := slot1x + 0
      global slot21y := slot17y + 35
      global slot21w := slot1w
      global slot21h := slot17h + 35

  global slotx21 := (slot21x + slot21w)/2
      global sloty21 := (slot21y + slot21h)/2


      global slot22x := slot21x + 40
      global slot22y := slot21y +0
      global slot22w := slot21w + 40
      global slot22h := slot21h

  global slotx22 := (slot22x + slot22w)/2
      global sloty22 := (slot22y + slot22h)/2

      global slot23x :=slot22x + 40
      global slot23y := slot21y +0
      global slot23w := slot22w + 40
      global slot23h := slot21h

  global slotx23 := (slot23x + slot23w)/2
      global sloty23 := (slot23y + slot23h)/2

      global slot24x := slot23x + 40
      global slot24y := slot21y +0
      global slot24w := slot23w + 40
      global slot24h := slot21h
  global slotx24 := (slot24x + slot24w)/2
      global sloty24 := (slot24y + slot24h)/2

      

    ;sixth row end

    ; seventh row start
        global slot25x := slot1x + 0
      global slot25y := slot21y + 35
      global slot25w := slot1w
      global slot25h := slot21h + 35

        global slotx25 := (slot25x + slot25w)/2
      global sloty25 := (slot25y + slot25h)/2

      global slot26x := slot25x + 40
      global slot26y := slot25y +0
      global slot26w := slot25w + 40
      global slot26h := slot25h

        global slotx26 := (slot26x + slot26w)/2
      global sloty26 := (slot26y + slot26h)/2

      global slot27x :=slot26x + 40
      global slot27y := slot25y +0
      global slot27w := slot26w + 40
      global slot27h := slot25h

        global slotx27 := (slot27x + slot27w)/2
      global sloty27 := (slot27y + slot27h)/2

      global slot28x := slot27x + 40
      global slot28y := slot25y +0
      global slot28w := slot27w + 40
      global slot28h := slot25h


        global slotx28 := (slot28x + slot28w)/2
      global sloty28 := (slot28y + slot28h)/2
 ; seventh row end

;protection prayers
 global protectmagex := slot14x-2
global protectmagey := slot14y+19

global protectrangex := slot14x+43
global protectrangey := slot14y +19

global protectmeleex := slot14x+83
global protectmeleey := slot14y + 19


; offensive prayers

global UltStrx := protectmeleex + 35
global UltStry := protectmeleey - 30
global eagleeyex := protectmeleex + 35
global eagleeyey := protectmeleey
global mysticmightx := protectmeleex-120
global mysticmighty := protectmeleey

global pietyx :=  protectmagex + 3
global pietyy := protectmeleey + 75
global rigourx := protectmagex + 40
global rigoury := protectmeleey + 75
global auguryx := protectmagex + 75
global auguryy := protectmeleey + 75


; run energy


global runenergyw := compassx -15
global runenergyh := compassy+117
global runenergyx := runenergyw - 24
global runenergyy := runenergyh - 16

        }
}



; use global in functions in main script


quicksearch(color,x,y,w,h,slotx,sloty)
{
  IniRead, Delay, %A_Desktop%\pureconfig.ini,Config,Delay
Pixelsearch, px, py,x+3,y+3,w-3,h-3,color,4, Fast RGB
  If (errorlevel = 0)

    {
      click, %slotx%,%sloty%
      sleep %Delay%
      return true
    }
  Else
  return false

}



checkrun(color){
  ; 0x00FF00 is 70% roughly with 135 variation

global

PixelSearch, runcx,runcy, runenergyx, runenergyy, runenergyw,runenergyh, color, 145, Fast RGB
  If (errorlevel = 0)
    return true
  If (errorlevel = 1)
    return false

}



setup(x){
global
getinventory()
if x = North
{
WinGetActiveStats, Runelite, Width, Height, X, Y
If Width <= 810
{
    centerx := (Width - 200) / 2
}
If Width > 810
{
    centerx := (Width) / 2
}
If Height <= 650
{
    centery := (Height - 160) / 2
}
If Height > 650
{
    centery := (Height) / 2
}
WinGetActiveStats, Runelite, Width, Height, X, Y
If Width <= 810
{
    3hpx := compassx-13
}
If Width > 810
{
    3hpx := compassx-20
}
If Height <= 650
{
    3hpy := compassy+46
}
If Height > 650
{
    3hpy := compassy+48
}
IniWrite, %3hpx%,inventory,slots,3hpx
IniWrite, %3hpy%,inventory,slots,3hpy
mousemove, compassx, compassy
randsleep(50,150)
click
randsleep(50,150)
Random, x1, 146,396
Random, y1, 159,293
mousemove, x1, y1
randsleep(50,150)
Send {Up Down}
randsleep(3500,4150)
Send {Up Up}
randsleep(50,150)
Send {WheelDown 100}
randsleep(50,150)
mousemove, compassx+20, compassy+50
randsleep(50,150)
Send {WheelDown 100}
mousemove, centerx, centery
}

if x = East
{

WinGetActiveStats, Runelite, Width, Height, X, Y
If Width <= 810
{
    centerx := (Width - 200) / 2
}
If Width > 810
{
    centerx := (Width) / 2
}
If Height <= 650
{
    centery := (Height - 160) / 2
}
If Height > 650
{
    centery := (Height) / 2
}
mousemove, compassx, compassy
click
WinGetActiveStats, Runelite, Width, Height, X, Y
If Width <= 810
{
    3hpx := compassx-13
}
If Width > 810
{
    3hpx := compassx-20
}
If Height <= 650
{
    3hpy := compassy+46
}
If Height > 650
{
    3hpy := compassy+48
}
IniWrite, %3hpx%,inventory,slots,3hpx
IniWrite, %3hpy%,inventory,slots,3hpy
randsleep(50,150)
click,right
randsleep(150,250)
mousemove, 0,34,0, R
randsleep(50,150)
click
randsleep(50,150)
Random, x1, 146,396
Random, y1, 159,293
mousemove, x1, y1
randsleep(50,150)
Send {Up Down}
randsleep(3500,4150)
Send {Up Up}
randsleep(50,150)
Send {WheelDown 100}
randsleep(50,150)
mousemove, compassx+20, compassy+50
randsleep(50,150)
Send {WheelDown 100}
mousemove, centerx, centery
}
if x = South
{

WinGetActiveStats, Runelite, Width, Height, X, Y
If Width <= 810
{
    centerx := (Width - 200) / 2
}
If Width > 810
{
    centerx := (Width) / 2
}
If Height <= 650
{
    centery := (Height - 160) / 2
}
If Height > 650
{
    centery := (Height) / 2
}
mousemove, compassx, compassy
click
WinGetActiveStats, Runelite, Width, Height, X, Y
If Width <= 810
{
    3hpx := compassx-13
}
If Width > 810
{
    3hpx := compassx-20
}
If Height <= 650
{
    3hpy := compassy+46
}
If Height > 650
{
    3hpy := compassy+48
}
IniWrite, %3hpx%,inventory,slots,3hpx
IniWrite, %3hpy%,inventory,slots,3hpy
randsleep(50,150)
click,right
randsleep(150,250)
mousemove, 0,68,0, R
randsleep(50,150)
click
randsleep(50,150)
Random, x1, 146,396
Random, y1, 159,293
mousemove, x1, y1
randsleep(50,150)
Send {Up Down}
randsleep(3500,4150)
Send {Up Up}
randsleep(50,150)
Send {WheelDown 100}
randsleep(50,150)
mousemove, compassx+20, compassy+50
randsleep(50,150)
Send {WheelDown 100}
mousemove, centerx, centery
}
if x = West
{
()
mousemove, compassx, compassy
click
WinGetActiveStats, Runelite, Width, Height, X, Y
If Width <= 810
{
    3hpx := compassx-13
}
If Width > 810
{
    3hpx := compassx-20
}
If Height <= 650
{
    3hpy := compassy+46
}
If Height > 650
{
    3hpy := compassy+48
}
IniWrite, %3hpx%,inventory,slots,3hpx
IniWrite, %3hpy%,inventory,slots,3hpy
randsleep(50,150)
click,right
randsleep(150,250)
mousemove, 0,78,0, R
randsleep(50,150)
click
randsleep(50,150)
Random, x1, 146,396
Random, y1, 159,293
mousemove, x1, y1
randsleep(50,150)
Send {Up Down}
randsleep(3500,4150)
Send {Up Up}
randsleep(50,150)
Send {WheelDown 100}
randsleep(50,150)
mousemove, compassx+20, compassy+50
randsleep(50,150)
Send {WheelDown 100}
mousemove, centerx, centery
}
}







bankscn(color){
clickspot(color)
waitbank(5)
randsleep(500,1000)
random, x1, 80, 102
random, y1, 115,135
Random, x2, 440, 459
Random, y2, 331,352
random, MouseSpeed, 185,285
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, x2+ weightedclick(-1,0,1), y2+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(50,150)
click
randsleep(1000,1500)
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, x1+ weightedclick(-1,0,1), y1+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(50,150)
click
randsleep(1000,1500)
Send {Esc}
}
















;;;; zoom levels

zoomin(x){

Send {WheelUp %x%}


}


zoomout(x){

Send {WheelDown %x%}

}




;;; pking stuff

swap(color){
firstrowpk(color)
 secondrowpk(color)
thirdrowpk(color)
fourthrowpk(color)
fifthrowpk(color)
sixthrowpk(color)
seventhrowpk(color)
}












;;combine stuff 




;checks if an object is nearby enough to go to next thread

checkobject(color){
PixelSearch, px, py, 196, 104, 341, 248, color, 10, Fast RGB
    If (errorlevel = 0)
        return true
    If (errorlevel = 1)
        return false


}




;;check last slot color
checklast(color){
global
getinventory()
PixelSearch, invlastx, invlasty, slot28x, slot28y, slot28w, slot28h, color, 5, Fast RGB
    IF (errorlevel = 0)
        return True
    If (errorlevel = 1)
        return false

}






;;;scanbank
;; scans if a bnak is on the screen, if it is, it will return true, if it isnt it will return false

scanbank(color){
PixelSearch, px, py, 11, 31, 525, 369, color, 5, Fast RGB
    If (errorlevel = 0)
        return true
    If (errorlevel = 1)
        return false

}

invdeposit(color){
global
getinventory()


depslots(color,slot1x,slot1y)

depslots(color,slot2x,slot2y)

depslots(color,slot3x,slot3y)

depslots(color,slot4x,slot4y)

depslots(color,slot5x,slot5y)

depslots(color,slot6x,slot6y)

depslots(color,slot7x,slot7y)

depslots(color,slot8x,slot8y)

depslots(color,slot9x,slot9y)

depslots(color,slot10x,slot10y)

depslots(color,slot11x,slot11y)

depslots(color,slot12x,slot12y)

depslots(color,slot13x,slot13y)

depslots(color,slot14x,slot14y)

depslots(color,slot15x,slot15y)

depslots(color,slot16x,slot16y)

depslots(color,slot17x,slot17y)

depslots(color,slot18x,slot18y)

depslots(color,slot19x,slot19y)

depslots(color,slot20x,slot20y)

depslots(color,slot21x,slot21y)

depslots(color,slot22x,slot22y)

depslots(color,slot23x,slot23y)

depslots(color,slot24x,slot24y)

depslots(color,slot25x,slot25y)

depslots(color,slot26x,slot26y)

depslots(color,slot27x,slot27y)

depslots(color,slot28x,slot28y)

randsleep(1000,2000)
Send {Esc}
randsleep(1000,2000)
}



;; Deposit Information
;;; deposit(color) is used to deposit the color of an item when bank is open

xpdrop(sec,color){
  global
  getinventory()
wait = 0
loop{
xpx1 := compassx - 400
xpy1 := compassy + 50
xpw1 := compassx - 50
xph1 := compassy + 375
PixelSearch, xpx, xpy, xpx1, xpy1, xpw1, xph1, color, 0, Fast RGB
    If (errorlevel = 0){
           wait = 0
            randsleep(600,800)
        break
    }
    If (errorlevel = 1)
    {
      loop, %sec%{
      PixelSearch, xpx, xpy, xpx1, xpy1, xpw1, xph1, color, 0, Fast RGB
        If (errorlevel = 1)
          sleep 100
      }
      break
}
}
randsleep(700,1000)
}



;; checks if 3 hp on 10 hp character
checklowhp(){
  global
getinventory()
      WinGetActiveStats, Runelite, Width, Height, X, Y
If Width <= 810
{
   hpx := compassx - 19
}
If Width > 810
{
   hpx := compassx - 20
}
If Height <= 650
{
   hpy := compassy + 38
}
If Height > 650
{
   hpy := compassy + 43
}

PixelSearch, hppx,hppy, hpx, hpy, hpx+2, hpy+2, 0x860603, 5, Fast RGB
  If (errorlevel = 1)
    return true
  If (errorlevel = 0)
    return false

}













;;;;; ClickSpot Information

;; clickspot(color) searches from the center of your character outwards in fixed mode. Runs about 4 different distances. This is for using findspot to click the center of the target closest to the player.
;; center out searching but still prefers top left, can add direction changing by using variables to pass through the function in the future
;;; Set to be used zoomed out mostly. can be adjusted by adding parameters but I felt it was too annoying so its used zoomed out


checkhwid(x){
UUID()

checkserial:
UrlDownloadToFile,% x , %a_Programs%\HWID.txt
goto serial1
return
line = 1
serial1:
loop,250{
    FileReadLine, hwid, %a_Programs%\HWID.txt, %line%
    line ++
    UUID_User = %hwid%
    If (UUID_User = UUID())
{
    goto Valid
}
}
GoTo, Invalid
return
Valid:
return true
invalid:
Msgbox, You do not own this script. Please Purchase from the store

FileDelete, %A_programs%\HWID.txt
return false
}


UUID()
{
	For obj in ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . A_ComputerName . "\root\cimv2").ExecQuery("Select * From Win32_ComputerSystemProduct")
		return obj.UUID	; http://msdn.microsoft.com/en-us/library/aa394105%28v=vs.85%29.aspx
}


getstatus(){
loop{
PixelSearch, px, py, 20, 56, 131, 87, 0x00FF00, 5, Fast RGB
    If (errorlevel = 0)
    {
        sleep 200
    }
    If (errorlevel = 1)
    {
        randsleep(1200,1700)
        break
    }

}
}





clickspot(color){




Pixelsearch,px,py, 516, 164, 538, 185, color, 15, Fast RGB
    If (errorlevel = 0){
        findspot(color, px-20, py-20, px + 20, py + 20)

    }
    If (errorlevel = 1){
        Pixelsearch,px,py, 225, 163, 297, 230, color, 15, Fast RGB
        If (errorlevel = 0){
            findspot(color,px-20, py-20, px + 20, py + 20)

            }
            If (errorlevel = 1){
                Pixelsearch,px,py, 151, 131, 351, 270, color, 15, Fast RGB
                    If (errorlevel = 0){
                    findspot(color, px-20, py-20, px + 20, py + 20)

                    }
                  If (errorlevel = 1){
                        Pixelsearch,px,py, 9, 36, 523, 368, color, 15, Fast RGB
                            If (errorlevel = 0){
                            findspot(color, px-20, py-20, px + 20, py + 20)

                    }

    }

}
}
}


; adjustable box as some scripts will not be fully zoomed out and need to detect radially closer. Seems niche but wrote something for it just expands the above function addition and subtraction

clickspotregion(color,x,y){




Pixelsearch,px,py, 516, 164, 538, 185, color, 15, Fast RGB
    If (errorlevel = 0){
        findspot(color, px-x, py-y, px + x, py + y)

    }
    If (errorlevel = 1){
        Pixelsearch,px,py, 225, 163, 297, 230, color, 15, Fast RGB
        If (errorlevel = 0){
            findspot(color, px-x, py-y, px + x, py + y)

            }
            If (errorlevel = 1){
                Pixelsearch,px,py, 151, 131, 351, 270, color, 15, Fast RGB
                    If (errorlevel = 0){
                    findspot(color, px-x, py-y, px + x, py + y)

                    }
                  If (errorlevel = 1){
                        Pixelsearch,px,py, 9, 36, 523, 368, color, 15, Fast RGB
                            If (errorlevel = 0){
                            findspot(color, px-x, py-y, px + x, py + y)

                    }

    }

}
}
}

;;;; waitbank() information
;; waits for bank window to be open returns true or false, can use that to either close the script or re-search for the bank etc
waitbank(sec){
IniRead, playable_topleftx, inventory, screen, playable_topleftx
IniRead, playable_toplefty, inventory, screen, playable_toplefty
IniRead, playable_bottomrightx, inventory, screen, playable_bottomrightx
IniRead, playable_bottomrighty, inventory, screen, playable_bottomrighty

wait = 0
loop{
wait += 1

Pixelsearch,px, py, 173, 35, 372, 65,0xFF981F,15, Fast RGB
    If (errorlevel = 0)
        break
    If (errorlevel = 1){
        
        if wait <= %sec%
            randsleep(1000,1200)
        if wait > %sec%
            return false



    }


}
return true
}

waitbank2(sec){
loop{
        IniRead, compassx, inventory, slots, compassx
        IniRead, compassy, inventory, slots, compassy

        topleftx := compassx - 1500
        toplefty := compassy - 40
        bottomrightx := topleftx + 1500
        bottomrighty := toplefty + 150
     PixelSearch, xx2, yy2, topleftx, toplefty, bottomrightx, bottomrighty, 0xFF981F, 10, Fast RGB
        If (errorlevel = 0)
            break
        If (errorlevel = 1)
            sleep 100

}
}




checkminimap(color){
 PixelSearch, xx2, yy2, 574, 43, 728, 183, color, 10, Fast RGB
    If (errorlevel = 0)
        return true
    If (errorlevel = 1)
        return false




}

;; mmpathing(color) Information (minimap pathing with tiles or npc colors, not continues just once click at a time)
; can check for a tile or npc or any color on the minimap, can be used in conjunction with many plugins
; checks minimap for color and clicks it, then waits until character is over the tile before returning. Checks in 4 directions and tries to exclude the middle of the map where the character is


getcolormm(color){
global
getinventory()


        PixelSearch, px, py, mapcenterxx - 180, mapcenteryy - 180, mapcenterxx + 180, mapcenteryy + 180, color, 25, Fast RGB
            If (errorlevel = 0)
                return true
            If (errorlevel = 1)
                return false

}




 clickcolorminimap(xx,yy,color){
WinGetActiveStats, Runelite, Width, Height, X, Y
If Width <= 810
{
    centerx := (Width - 200) / 2
}
If Width > 810
{
    centerx := (Width) / 2
}
If Height <= 650
{
    centery := (Height - 160) / 2
}
If Height > 650
{
    centery := (Height) / 2
}
         mousegetpos, x,y
        PixelSearch, px, py, xx -180, yy - 180, xx +180, yy + 180, color, 25, Fast RGB
            If (errorlevel = 0){
              Random, MouseSpeed, 165,220
                mousegetpos, MouseXpos, MouseYpos
                RandomBezier( MouseXpos, MouseYpos, px-2, py+1, "T"MouseSpeed "P2-5")
                click
                randsleep(150,250)
                mousegetpos, MouseXpos, MouseYpos
                              Random, MouseSpeed, 200,320

                RandomBezier( MouseXpos, MouseYpos, x + weightedclick(-400,0,400), y+ weightedclick(-400,0,400), "T"MouseSpeed "P2-5")


            }
            goto waitunder
            Return
            waitunder:
            loop{
              cx1 := centerx - 40
              cy1 := centery - 40
              cw1 := centerx + 40
              ch1 := centery + 40
                Pixelsearch, px2,py2, cx1,cy1,cw1,ch1, color, 15, Fast RGB
                    If (errorlevel = 0)
                        {
                        randsleep(1200,1670)
                        break
                        }
                    If (errorlevel = 1)
                        {
                        sleep 100
                        }

}               
 }







scanrow(color,row){

if row = 1
{
Pixelsearch, row1x,row1y, slot1x,slot1y, slot4x+5,slots4y+10, color, 5, Fast RGB
  If (errorlevel = 0)
    return true
  If (errorlevel = 1)
    return true

}
if row = 2
{
Pixelsearch, row1x,row1y, slot5x,slot5y, slot8x+5,slots8y+10, color, 5, Fast RGB
  If (errorlevel = 0)
    return true
  If (errorlevel = 1)
    return true

}
if row = 3
{
Pixelsearch, row1x,row1y, slot9x,slot9y, slot12x+5,slots12y+10, color, 5, Fast RGB
  If (errorlevel = 0)
    return true
  If (errorlevel = 1)
    return true

}
if row = 4
{
Pixelsearch, row1x,row1y, slot13x,slot13y, slot16x+5,slots16y+10, color, 5, Fast RGB
  If (errorlevel = 0)
    return true
  If (errorlevel = 1)
    return true

}

if row = 5
{
Pixelsearch, row1x,row1y, slot17x,slot17y, slot20x+5,slots20y+10, color, 5, Fast RGB
  If (errorlevel = 0)
    return true
  If (errorlevel = 1)
    return true

}

if row = 6
{
Pixelsearch, row1x,row1y, slot21x,slot21y, slot24x+5,slots24y+10, color, 5, Fast RGB
  If (errorlevel = 0)
    return true
  If (errorlevel = 1)
    return true

}

if row = 7
{
Pixelsearch, row1x,row1y, slot25x,slot25y, slot28x+5,slots28y+10, color, 5, Fast RGB
  If (errorlevel = 0)
    return true
  If (errorlevel = 1)
    return true

}
}

;;;; Check Drop Information

;; checkdrop(color) can be used to drop any color in any inventory slot quickly if your inventory is full.

;; Uses a randombezier curve to move the mouse, optimized for human like movement for Tom's scripts.

;;; You can run at any point you want to in your script and it will drop anything highlighted in the color you input




checkdrop(color){
loop{

        IniRead, slot1x, inventory, slots, slot1x
        IniRead, slot1y, inventory, slots, slot1y
    IniRead, slot28x, inventory, slots, slot28x
IniRead, slot28y, inventory, slots, slot28y
PixelSearch, xx1, yy1, slot1x, slot1y , slot28x, slot28y, color, 5, Fast RGB
    If (errorlevel = 0)
        {
                Random, pattern, 1,3
            
                If (pattern = 1){
                  PixelSearch, xx2, yy2, slot1x, slot1y , slot28x, slot28y, color, 5, Fast RGB
                    If (errorlevel = 0){
                            send {shift down}
                            firstrow(color)
                            secondrow(color)
                            thirdrow(color)
                            fourthrow(color)
                            fifthrow(color)
                            sixthrow(color)
                            seventhrow(color)
                        }
                        Else
                            break
                }

                If (pattern = 2){
                    PixelSearch, xx2, yy2, slot1x, slot1y , slot28x, slot28y, color, 5, Fast RGB
                        If (errorlevel = 0){
                            send {shift down}
                            secondrow(color)
                            firstrow(color)
                            thirdrow(color)
                            fifthrow(color)
                            sixthrow(color)
                            fourthrow(color)                            
                            seventhrow(color)
                        }
                        Else
                            Break
                }


                If (pattern = 3){
                    PixelSearch, xx2, yy2, slot1x, slot1y , slot28x, slot28y, color, 5, Fast RGB
                        If (errorlevel = 0){
                            send {shift down}
                            seventhrow(color)
                            sixthrow(color)
                            fifthrow(color)
                            fourthrow(color)
                            thirdrow(color)
                            secondrow(color)
                            fifthrow(color)
                            firstrow(color)
                            }
                            Else
                                Break
                }



        }
    If (errorlevel = 1)
        break

}
     send {shift up}
}


firstrow(color){
global
getinventory()

slots(color,slot1x,slot1y)
slots(color,slot2x,slot2y)
slots(color,slot3x,slot3y)
slots(color,slot4x,slot4y)

}


firstrowpk(color){
global
    getinventory()

slotsrange(color,slot1x,slot1y)
slotsrange(color,slot2x,slot2y)
slotsrange(color,slot3x,slot3y)
slotsrange(color,slot4x,slot4y)


}




secondrow(color){
global
    getinventory()
Random, randyx, 1,3
if randyx = 1
{

slots(color,slot5x,slot5y)
slots(color,slot6x,slot6y)
slots(color,slot7x,slot7y)
slots(color,slot8x,slot8y)

}
if randyx = 2
{
slots(color,slot5x,slot5y)
slots(color,slot6x,slot6y)
slots(color,slot7x,slot7y)
slots(color,slot8x,slot8y)

}
if randyx = 3
{
slots(color,slot5x,slot5y)
slots(color,slot6x,slot6y)
slots(color,slot7x,slot7y)
slots(color,slot8x,slot8y)

}


}


secondrowpk(color){
global
    getinventory()

slotsrange(color,slot5x,slot5y)
slotsrange(color,slot6x,slot6y)
slotsrange(color,slot7x,slot7y)
slotsrange(color,slot8x,slot8y)


}



thirdrow(color){
    getinventory()



slots(color,slot9x,slot9y)
slots(color,slot10x,slot10y)
slots(color,slot11x,slot11y)
slots(color,slot12x,slot12y)


}




thirdrowpk(color){

    getinventory()
slotsrange(color,slot9x,slot9y)
slotsrange(color,slot10x,slot10y)
slotsrange(color,slot11x,slot11y)
slotsrange(color,slot12x,slot12y)

}





fourthrow(color){
global
    getinventory()
Random, randyx, 1,3
     if x = 1
    {
slots(color,slot13x,slot13y)
slots(color,slot14x,slot14y)
slots(color,slot15x,slot15y)
slots(color,slot16x,slot16y)


    }     
     if x = 2
    {
slots(color,slot13x,slot13y)
slots(color,slot14x,slot14y)
slots(color,slot15x,slot15y)
slots(color,slot16x,slot16y)


    } 
     if x = 3
    {
slots(color,slot13x,slot13y)
slots(color,slot14x,slot14y)
slots(color,slot15x,slot15y)
slots(color,slot16x,slot16y)

    }       



}





fourthrowpk(color){
global
    getinventory()

slotsrange(color,slot13x,slot13y)
slotsrange(color,slot14x,slot14y)
slotsrange(color,slot15x,slot15y)
slotsrange(color,slot16x,slot16y)



}








fifthrow(color){

    Random, randyx, 1,3
     if randyx = 1
    {
slots(color,slot17x,slot17y)
slots(color,slot18x,slot18y)
slots(color,slot19x,slot19y)
slots(color,slot20x,slot20y)

    } 
     if randyx = 2
    {
slots(color,slot17x,slot17y)
slots(color,slot18x,slot18y)
slots(color,slot19x,slot19y)
slots(color,slot20x,slot20y)


    } 
     if randyx = 3
    {
slots(color,slot17x,slot17y)
slots(color,slot18x,slot18y)
slots(color,slot19x,slot19y)
slots(color,slot20x,slot20y)

    } 


}



fifthrowpk(color){
    getinventory()


slotsrange(color,slot17x,slot17y)
slotsrange(color,slot18x,slot18y)
slotsrange(color,slot19x,slot19y)
slotsrange(color,slot20x,slot20y)


}










sixthrow(color){
global

    Random, x, 1,3
     if x = 1
    {

slots(color,slot21x,slot21y)
slots(color,slot22x,slot22y)
slots(color,slot23x,slot23y)
slots(color,slot24x,slot24y)



    } 
     if x = 2
    {

slots(color,slot21x,slot21y)
slots(color,slot22x,slot22y)
slots(color,slot23x,slot23y)
slots(color,slot24x,slot24y)


    } 
     if x = 3
    {

slots(color,slot21x,slot21y)
slots(color,slot22x,slot22y)
slots(color,slot23x,slot23y)
slots(color,slot24x,slot24y)


    } 

}



sixthrowpk(color){


    getinventory()
slotsrange(color,slot21x,slot21y)
slotsrange(color,slot22x,slot22y)
slotsrange(color,slot23x,slot23y)
slotsrange(color,slot24x,slot24y)


}


seventhrow(color){
  global
getinventory()

Random, x, 1,3
     if x = 1
    {

slots(color,slot25x,slot25y)
slots(color,slot26x,slot26y)
slots(color,slot27x,slot27y)
slots(color,slot28x,slot28y)


    } 
     if x = 2
    {
slots(color,slot25x,slot25y)
slots(color,slot26x,slot26y)
slots(color,slot27x,slot27y)
slots(color,slot28x,slot28y)



    } 

     if x = 3
    {
slots(color,slot25x,slot25y)
slots(color,slot26x,slot26y)
slots(color,slot27x,slot27y)
slots(color,slot28x,slot28y)

    } 
}

seventhrowpk(color){
  global
getinventory()


slotsrange(color,slot25x,slot25y)
slotsrange(color,slot26x,slot26y)
slotsrange(color,slot27x,slot27y)
slotsrange(color,slot28x,slot28y)
}



;;; very important tightly wrapped function. Basically, use it on each inventory slot to determine whether to click a color or not


SearchSlot(color,x1,y1){

Pixelsearch, PX5, PY5, x1 -5, y1 -5, x1 + 5, y1+5, color,0, Fast, RGB
If !ErrorLevel
{
	click, %PX5%,%PY5% ; can use slots or color, color probably more consistent 
  sleep 10
}
}






slotsstatus(color)
{
 PixelSearch, px, py, itopleftx, itoplefty slot28x+10, slot28y+10, color,2, Fast RGB
 If (errorlevel = 0)
                {
        return true
                }
  if (errorlevel = 1)
        return false
}





slots(color,x,y)
{
 PixelSearch, px, py, x-10, y-10, x+10, y+10, color,2, Fast RGB
 If (errorlevel = 0)
                {
                    findspot(color, px-12, py-20, px+12,py+20)
                    return true
                }
    Else
        return false
}


slotsinv(color)
{
  global
  getinventory()
 PixelSearch, slotsinvxx, slotsinvyy, slot1x, slot1y, slot28w, slot28h, color,5, Fast RGB
 If (errorlevel = 0)
                {
                    findspot(color, slotsinvxx-12, slotsinvyy-20, slotsinvxx+12,slotsinvyy+20)
                    return true
                }
    Else
        return false
}



depslots(color,x,y)
{
 PixelSearch, px, py, x-10, y-10, x+10, y+10, color,2, Fast RGB
 If (errorlevel = 0)
                {
                    findspot(color, px-12, py-20, px+12,py+20)
                    randsleep(700,1000)
                    return true
                }
    Else
        return false
}


pkslots(color,x,y,w,h)
{
 PixelSearch, px, py, x, y, w, h, color,5, Fast RGB
 If (errorlevel = 0)
                {
                    findspot3(color, px-10, py-10, px+10,py+10)
                    return true
                }
    Else
        return false
}

pkslots2(color,x,y,w,h)
{
loop{
 PixelSearch, px, py, x, y, w, h, color,5, Fast RGB
 If (errorlevel = 0)
                {
                    findspot3(color, px-12, py-20, px+12,py+20)
                }
If (errorlevel = 1)
  break
}
}





slotsrange(color,x,y)
{

    
 PixelSearch, px, py, x-15, y-15, x+15, y+15, color,15, Fast RGB
 If (errorlevel = 0)
                {
                    mousemove, px+1, py+3
                    click
                    sleep 10
                    return true
                }
    Else
        return false
}





;;;;;; end inventory stuff








antiban(x)
		{
				Random, r1, 1, 100
				if (r1 < x) { ;change percentage to whatever customer wants
				Random, PercentageSleep, 4500, 15000
				Sleep, %PercentageSleep%
				}
		}


radial(color,spot){
    Random, MouseSpeed, 20,50
WinGetActiveStats, Runelite, Width, Height, X, Y
If Width <= 810
{
    centerx := (Width - 200) / 2
}
If Width > 810
{
    centerx := (Width) / 2
}
If Height <= 650
{
    centery := (Height - 160) / 2
}
If Height > 650
{
    centery := (Height) / 2
}


offset = 5
loop{
PixelSearch, px, py, centerx - offset,centery - offset,centerx + offset,centery + offset, color, 15, Fast RGB
    If (errorlevel = 0)
{        
        findspot(color,px-spot, py-spot, px + spot, py + spot)
        break
        }
    If (errorlevel = 1)
        offset += 10

        if offset > 1500
          break
}
}





reset(color){
    Random, MouseSpeed, 20,50
WinGetActiveStats, Runelite, Width, Height, X, Y
If Width <= 810
{
    centerx := (Width - 200) / 2
}
If Width > 810
{
    centerx := (Width) / 2
}
If Height <= 650
{
    centery := (Height - 160) / 2
}
If Height > 650
{
    centery := (Height) / 2
}
offset = 600
PixelSearch, px, py, centerx - offset,centery - offset,centerx + offset,centery + offset, color, 15, Fast RGB
    If (errorlevel = 0)    
      return true
        
    If (errorlevel = 1)
        return false

}








;;;;; Findspot Information

; Find spot is a function used to find the middle of a color on the client. This is used within many functions to provide the mouse movement and clicks. Do not modify unless you know what you are doing


findspot(color,x,y,w,h){
Random, ms, 3,5
Random, MouseSpeed, 165,220
mousegetpos, MouseXpos, MouseYpos
PixelSearch, OutputVarX, OutputVarY, x, y, w, h, color, 4, Fast RGB
sleep 120
    PixelSearch, OutputVarX2, OutputVarY2, w, h, x, y, color, 4, Fast RGB
                centerTileX := ((OutputVarX + OutputVarX2) / 2)
                centerTileY := ((OutputVarY + OutputVarY2) / 2)
        if (errorlevel = 0){ 
            RandomBezier( MouseXpos, MouseYpos, centerTileX+ weightedclick(-3,0,3), centerTileY+ weightedclick(-3,0,3), "T"MouseSpeed "P2-5")
             randsleep(50,90)
            click
            randsleep(50,90)
        }
}

findspot2stage(color,x,y,w,h){
Random, ms, 3,5
Random, MouseSpeed, 165,220
mousegetpos, MouseXpos, MouseYpos
PixelSearch, OutputVarX, OutputVarY, x, y, w, h, color, 4, Fast RGB
sleep 120
    PixelSearch, OutputVarX2, OutputVarY2, w, h, x, y, color, 4, Fast RGB
                centerTileX := ((OutputVarX + OutputVarX2) / 2)
                centerTileY := ((OutputVarY + OutputVarY2) / 2)
        if (errorlevel = 0){ 
            RandomBezier( MouseXpos, MouseYpos, centerTileX+ weightedclick(-3,0,3), centerTileY+ weightedclick(-3,0,3), "T"MouseSpeed "P2-5")
             randsleep(50,90)
            click
            randsleep(50,90)
        }
}




findspotright(color,x,y,w,h){
Random, ms, 3,5
Random, MouseSpeed, 180,250
mousegetpos, MouseXpos, MouseYpos
PixelSearch, OutputVarX, OutputVarY, x, y, w, h, color, 4, Fast RGB
sleep 500
    PixelSearch, OutputVarX2, OutputVarY2, w, h, x, y, color, 4, Fast RGB
                centerTileX := ((OutputVarX + OutputVarX2) / 2)
                centerTileY := ((OutputVarY + OutputVarY2) / 2)
        if (errorlevel = 0){ 
            RandomBezier( MouseXpos, MouseYpos, centerTileX+ weightedclick(-1,0,1), centerTileY+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
             randsleep(50,90)
            click,right
            randsleep(50,90)
        }
}


findspot3(color,x,y,w,h){
mousegetpos, MouseXpos, MouseYpos
PixelSearch, centerTileX, centerTileY, x, y, w, h, color, 15, Fast RGB
        if (errorlevel = 0){ 
            mousemove, centerTileX+1, centerTileY+3
            click
        }
}










;;; Some General useful functions

; Weighted clicks to target center of coordinates you output, integrated within findspot



Zip(FilesToZip,sZip)
{
If Not FileExist(sZip)
	CreateZipFile(sZip)
psh := ComObjCreate( "Shell.Application" )
pzip := psh.Namespace( sZip )
if InStr(FileExist(FilesToZip), "D")
	FilesToZip .= SubStr(FilesToZip,0)="\" ? "*.*" : "\*.*"
loop,%FilesToZip%,1
{
	zipped++
	ToolTip Zipping %A_LoopFileName% ..
	pzip.CopyHere( A_LoopFileLongPath, 4|16 )
	Loop
	{
		done := pzip.items().count
		if done = %zipped%
			break
	}
	done := -1
}
ToolTip
}

CreateZipFile(sZip)
{
	Header1 := "PK" . Chr(5) . Chr(6)
	VarSetCapacity(Header2, 18, 0)
	file := FileOpen(sZip,"w")
	file.Write(Header1)
	file.RawWrite(Header2,18)
	file.close()
}

Unz(sZip, sUnz)
{
    fso := ComObjCreate("Scripting.FileSystemObject")
    If Not fso.FolderExists(sUnz)  ;http://www.autohotkey.com/forum/viewtopic.php?p=402574
       fso.CreateFolder(sUnz)
    psh  := ComObjCreate("Shell.Application")
    zippedItems := psh.Namespace( sZip ).items().count
    psh.Namespace( sUnz ).CopyHere( psh.Namespace( sZip ).items, 4|16 )
    Loop {
        sleep 100
        unzippedItems := psh.Namespace( sUnz ).items().count
        ToolTip Unzipping in progress..
        IfEqual,zippedItems,%unzippedItems%
            break
    }
    ToolTip
}








weightedclick(min, target, max){
    Random, lower, min, target
    Random, upper, target, max
    Random, weighted, lower, upper
    Return, weighted
}

;;; randomized sleeps
randsleep(x,y){
Random, s1, %x%, %y%
sleep s1
}









; randomized mouse pathing
RandomBezier( X0, Y0, Xf, Yf, O="" ) {
    Time := RegExMatch(O,"i)T(\d+)",M)&&(M1>0)? M1: 60
    RO := InStr(O,"RO",0) , RD := InStr(O,"RD",0)
    N:=!RegExMatch(O,"i)P(\d+)(-(\d+))?",M)||(M1<2)? 2: (M1>19)? 19: M1
    If ((M:=(M3!="")? ((M3<2)? 2: ((M3>19)? 19: M3)): ((M1=="")? 5: ""))!="")
        Random, N, %N%, %M%
    OfT:=RegExMatch(O,"i)OT(-?\d+)",M)? M1: 100, OfB:=RegExMatch(O,"i)OB(-?\d+)",M)? M1: 30
    OfL:=RegExMatch(O,"i)OL(-?\d+)",M)? M1: 100, OfR:=RegExMatch(O,"i)OR(-?\d+)",M)? M1: 40
    MouseGetPos, XM, YM
    If ( RO )
        X0 += XM, Y0 += YM
    If ( RD )
        Xf += XM, Yf += YM
    If ( X0 < Xf )
        sX := X0-OfL, bX := Xf+OfR
    Else
        sX := Xf-OfL, bX := X0+OfR
    If ( Y0 < Yf )
        sY := Y0-OfT, bY := Yf+OfB
    Else
        sY := Yf-OfT, bY := Y0+OfB
    Loop, % (--N)-1 {
        Random, X%A_Index%, %sX%, %bX%
        Random, Y%A_Index%, %sY%, %bY%
    }
    X%N% := Xf, Y%N% := Yf, E := ( I := A_TickCount ) + Time
    While ( A_TickCount < E ) {
        U := 1 - (T := (A_TickCount-I)/Time)
        Loop, % N + 1 + (X := Y := 0) {
            Loop, % Idx := A_Index - (F1 := F2 := F3 := 1)
                F2 *= A_Index, F1 *= A_Index
            Loop, % D := N-Idx
                F3 *= A_Index, F1 *= A_Index+Idx
            M:=(F1/(F2*F3))*((T+0.000001)**Idx)*((U-0.000001)**D), X+=M*X%Idx%, Y+=M*Y%Idx%
        }
        MouseMove, %X%, %Y%, 0
        Sleep, 1
    }
    MouseMove, X%N%, Y%N%, 0
    Return N+1
}
























































































































































