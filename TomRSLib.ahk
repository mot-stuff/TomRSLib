;;;;; Tom's Runescape Library ;;;;; Stored on Github for live updating
;
; - This library contains useful functions for coding ahk bots in runescape. Use #Include TomRSLib.ahk and it will compile into your script when you package it as an exe. 
; - This can only be used in fixed mode with the smallest window size. Sidebar can be open. It only reads game screen
; #Include C:\Users\tomal\OneDrive\Documents\GitHub\TomRSLib\TomRSLib.ahk
;
;
; LATEST UPDATE: 12/28/22
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
; -- bank(tilecolor,bankcolor,itemcolor,sec): clicks tile, runs to tile, clicks bank, waits for it to open, deposits color in inventory
; -- antiban(x) - randomized small sleeps with the ability to set a percentage
; -- antibanstats() - perfectly waited for randomly checking thes stats page for a few seconds, just place into a function that is looping or where you want the chance of checking the page. I personally place it in downtime loops
; -- antibanfriends() - perfectly weighted to check friends list randomly for a few seconds  
; -- checkobject(color): checks if a specific color is on screen and returns true or flase
; -- checklast(color): checks last spot in inventory and returns true or false
; -- checkhwid(x): checks hwid from a list store at a link, reads txt file with HWIDS in it and checks the HWID of the user. Good for security
; -- UUID(): Grabs the current users HWID to compare against the list
; -- combine(color1,color2,sendspace): Uses one color on another in the inventory, just uses the slots function using inventory coordinates. 0 is no for sending spacebar, 1 is yes
; -- zoomin(x) and zoomout(x): sends the wheel in either direction, pretty straight forward
;
;
;
;
; == Function Groups == ; functions mainly specialized for something above, but could be useful
;
;; + clicks rows function group, used within checkdrop(color) + ;;
; -- slots(color,x,y,w,h): used to determine each slot and search it for a color
; -- firstrow(color): only uses color to pass through to the function above
; -- secondrow(color)
; -- thirdrow(color)
; -- fourthrow(color)
; -- fifthrow(color)
; -- sixthrow(color)
; -- seventhrow(color)
; -- checklast(color): returns true or false if last inventory slot is filled
;
;
;
; ==============================================================================================================================================================================================================================;
;
;
;
;
;
;----------- Start library -----------------;
;;
;;
;;
;;
;;
;; setup functions
;; these functions help with setting up the compass, zoom level, and position of the camera. Used for setting up an automated script
;; must be input as: setup("North")


setup(x){
Random, cx, 558, 575
Random, cy, 39,58
Random, MouseSpeed, 180,250
mousegetpos, MouseXpos, MouseYpos
Random, ccx, 624, 682
Random, ccy, 92,133
Random,cscx, 134,386
Random, cscy, 140,285
Random, eastx,528, 575
Random, easty, 83,94
Random, southx,543, 590
Random, southy, 98,106
Random, westx,524, 571
Random, westy,112,123

if x = North
{
RandomBezier( MouseXpos, MouseYpos, cx+ weightedclick(-1,0,1), cy+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(50,100)
click
randsleep(50,100)
Send {Up Down}
randsleep(3000,5000)
Send {Up Up}
randsleep(50,100)
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, ccx+ weightedclick(-1,0,1), ccy+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(50,100)
Send {WheelDown 100}
randsleep(50,100)
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, cscx+ weightedclick(-1,0,1), cscy+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(50,100)
Send {WheelDown 100}

}

if x = East
{
RandomBezier( MouseXpos, MouseYpos, cx+ weightedclick(-1,0,1), cy, "T"MouseSpeed "P4-3")
randsleep(50,100)
click,right
randsleep(500,1000)
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, eastx+ weightedclick(-1,0,1), easty, "T"MouseSpeed "P4-3")
randsleep(500,1000)
click
randsleep(50,100)
Send {Up Down}
randsleep(3000,5000)
Send {Up Up}
randsleep(50,100)
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, ccx+ weightedclick(-1,0,1), ccy, "T"MouseSpeed "P4-3")
randsleep(50,100)
Send {WheelDown 100}
randsleep(50,100)
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, cscx+ weightedclick(-1,0,1), cscy, "T"MouseSpeed "P4-3")
randsleep(50,100)
Send {WheelDown 100}



}


if x = South
{
RandomBezier( MouseXpos, MouseYpos, cx+ weightedclick(-1,0,1), cy+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(500,1000)
click,right
randsleep(500,1000)
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, southx+ weightedclick(-1,0,1), southy+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(500,1000)
click
randsleep(50,100)
Send {Up Down}
randsleep(3000,5000)
Send {Up Up}
randsleep(50,100)
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, ccx+ weightedclick(-1,0,1), ccy+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(50,100)
Send {WheelDown 100}
randsleep(50,100)
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, cscx+ weightedclick(-1,0,1), cscy+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(50,100)
Send {WheelDown 100}



}

if x = West
{
RandomBezier( MouseXpos, MouseYpos, cx+ weightedclick(-1,0,1), cy+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(50,100)
click,right
randsleep(500,1000)
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, westx+ weightedclick(-1,0,1), westy+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(500,1000)

click
randsleep(50,100)
Send {Up Down}
randsleep(3000,5000)
Send {Up Up}
randsleep(50,100)
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, ccx+ weightedclick(-1,0,1), ccy+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(50,100)
Send {WheelDown 100}
randsleep(50,100)
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, cscx+ weightedclick(-1,0,1), cscy+ weightedclick(-1,0,1), "T"MouseSpeed "P4-3")
randsleep(50,100)
Send {WheelDown 100}



}


}



zoomin(x){

Send {WheelUp %x%}


}


zoomout(x){

Send {WheelDown %x%}

}




combine(color1,color2,sendspace){
slots(color1, 553,236,741,491)
slots(color2, 553,236,741,491)
randsleep(500,1000)
if sendspace = 0
{
sleep 10
}
if sendspace = 1
{
    randsleep(50,150)
    Send {space}
}
}




;checks if an object is nearby enough to go to next thread

checkobject(color){
PixelSearch, px, py, 196, 104, 341, 248, color, 10, Fast RGB
    If (errorlevel = 0)
        return true
    If (errorlevel = 1)
        return false


}



; south 543, 98, 590, 106
; West 524, 112, 571, 123







;;check last slot color
checklast(color){
PixelSearch, xx1, yy1, 693, 458, 725, 490, color, 5, Fast RGB
    IF (errorlevel = 0)
        return True
    If (errorlevel = 1)
        return false

}



;;banking - one screen
bank(tilecolor,bankcolor,itemcolor,sec){
loop{
If (scanbank(bankcolor) == False)
{
    mmpathing(tilecolor)
    randsleep(500,1000)
}
else if (scanbank(bankcolor) == True)
{
clickspot(bankcolor)
waitbank(sec)
deposit(itemcolor)
break
}
}
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







;; Deposit Information
;;; deposit(color) is used to deposit the color of an item when bank is open

deposit(color){
loop{
PixelSearch, xx1, yy1, 693, 458, 725, 490, color, 5, Fast RGB
    If (errorlevel = 0)
        {
                pattern = 1
            
                If (pattern = 1){
                  PixelSearch, xx2, yy2, 556, 235, 737, 492, color, 5, Fast RGB
                    If (errorlevel = 0){
                            ; send {shift down}
                            firstrow(color)
                            randsleep(100,250)
                            secondrow(color)
                            randsleep(100,250)                            
                            thirdrow(color)
                            randsleep(100,250)
                            fourthrow(color)
                            randsleep(100,250)
                            fifthrow(color)
                            sixthrow(color)
                            seventhrow(color)
                            break
                        }
                        Else
                            break
                }
}
}
Send {Esc}
randsleep(1000,2000)
}




checkmouse(){
randsleep(2000,3000)
clickspot(0x00FF00)
loop{
mousegetpos, x,y

PixelSearch, mx, my, x-5,y-5,x+5,y+5, color, 5, Fast RGB
    If (errorlevel = 0)
        sleep 100
    If (errorlevel = 1)
        break


}

}



;; This function will continue waiting if an xp drop is found within x amount of seconds. Some scripts need a unique xp drop color depending on location
xpdropcontinue(color,x){
wait = 0
loop{
PixelSearch, xpx, xpy, 467, 81, 521, 127, color, 0, Fast RGB
    If (errorlevel = 0){
        randsleep(300,600)
    }
    If (errorlevel = 1)
    {
        wait +=1

        if wait > %x%
        {
            wait = 0
            randsleep(300,600)
            break
        }
             if wait < %x%
        {
            randsleep(1000,1400)
        }
    }
}
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
Tooltip, Valid HWID, 0,30
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

mmpathing(color){
Random, ms, 3,5
Random, MouseSpeed, 180,250
mousegetpos, MouseXpos, MouseYpos
 PixelSearch, xx2, yy2, 587, 46, 713, 174, color, 26, Fast RGB
            If (errorlevel = 0)
            {
                RandomBezier( MouseXpos, MouseYpos, xx2+ weightedclick(-3,-1,0), yy2+ weightedclick(-4,0,4), "T"MouseSpeed "P2-5")
                randsleep(500,100)
                Click
                randsleep(2500,2700)
                loop{
                PixelSearch, go1, go2, 235, 182, 296, 230, color, 15, Fast RGB
                    If (errorlevel = 0){
                        randsleep(1600,1700)
                        break
                    }
                    If (errorlevel = 1)
                        randsleep(300,500)
                    }
            }




                } 








;;;; Check Drop Information

;; checkdrop(color) can be used to drop any color in any inventory slot quickly if your inventory is full.

;; Uses a randombezier curve to move the mouse, optimized for human like movement for Tom's scripts.

;;; You can run at any point you want to in your script and it will drop anything highlighted in the color you input








checkdrop(color){
loop{
PixelSearch, xx1, yy1, 693, 458, 725, 490, color, 5, Fast RGB
    If (errorlevel = 0)
        {
                Random, pattern, 1,3
            
                If (pattern = 1){
                  PixelSearch, xx2, yy2, 556, 235, 737, 492, color, 5, Fast RGB
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
                    PixelSearch, xx2, yy2, 556, 235, 737, 492, color, 5, Fast RGB
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
                    PixelSearch, xx2, yy2, 556, 235, 737, 492, color, 5, Fast RGB
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

Random, x, 1,3

if x = 1
{

slots(color,568, 242, 599, 272)
slots(color,613, 244, 638, 270)
slots(color,648, 243, 680, 273)
slots(color,686, 241, 724, 275)
}

if x = 2
{
slots(color,648, 243, 680, 273)
slots(color,686, 241, 724, 275)
slots(color,568, 242, 599, 272)
slots(color,613, 244, 638, 270)
}

if x = 3
{
slots(color,613, 244, 638, 270)
slots(color,568, 242, 599, 272)
slots(color,648, 243, 680, 273)
slots(color,686, 241, 724, 275)

}

}




secondrow(color){
Random, x, 1,3
if x = 1
{

slots(color,562, 278, 600, 310)
slots(color,604, 278, 645, 310)
slots(color,651, 277, 683, 311)
slots(color,687, 275, 726, 310)

}
if x = 2
{
slots(color,604, 278, 645, 310)
slots(color,562, 278, 600, 310)
slots(color,687, 275, 726, 310)
slots(color,651, 277, 683, 311)

}
if x = 3
{
slots(color,651, 277, 683, 311)
slots(color,687, 275, 726, 310)
slots(color,562, 278, 600, 310)
slots(color,604, 278, 645, 310)

}


}



thirdrow(color){
Random, x, 1,3
    if x = 1
{

    slots(color,565, 316, 595, 343)
    slots(color,605, 312, 646, 345)
    slots(color,649, 318, 683, 345)
    slots(color,688, 315, 722, 343)


}
    if x = 2
{

    slots(color,649, 318, 683, 345)
    slots(color,688, 315, 722, 343)
    slots(color,565, 316, 595, 343)
    slots(color,605, 312, 646, 345)


}
    if x = 3
{

    slots(color,688, 315, 722, 343)
    slots(color,605, 312, 646, 345)
    slots(color,649, 318, 683, 345)
    slots(color,565, 316, 595, 343)


}
}


fourthrow(color){
Random, x, 1,3
     if x = 1
    {
        slots(color,691, 349, 727, 381)
        slots(color,644, 346, 685, 383)
        slots(color,607, 349, 641, 381)
        slots(color,560, 352, 604, 383)


    }     
     if x = 2
    {
        slots(color,607, 349, 641, 381)
        slots(color,560, 352, 604, 383)
        slots(color,691, 349, 727, 381)
        slots(color,644, 346, 685, 383)


    } 
     if x = 3
    {
        slots(color,560, 352, 604, 383)
        slots(color,644, 346, 685, 383)
        slots(color,607, 349, 641, 381)
        slots(color,560, 352, 604, 383)
        slots(color,691, 349, 727, 381)

    }       



}



fifthrow(color){
    Random, x, 1,3
     if x = 1
    {
        slots(color,694, 389, 724, 415)
        slots(color,655, 393, 680, 415)
        slots(color,611, 390, 641, 412)
        slots(color,568, 390, 596, 414)


    } 
     if x = 2
    {
        slots(color,611, 390, 641, 412)
        slots(color,568, 390, 596, 414)
        slots(color,694, 389, 724, 415)
        slots(color,655, 393, 680, 415)


    } 
     if x = 3
    {
        slots(color,568, 390, 596, 414)
        slots(color,655, 393, 680, 415)
        slots(color,611, 390, 641, 412)
        slots(color,694, 389, 724, 415)


    } 


}

sixthrow(color){
    Random, x, 1,3
     if x = 1
    {
        slots(color,691, 425, 723, 453)
        slots(color,650, 425, 684, 455)
        slots(color,606, 425, 642, 450)
        slots(color,569, 423, 595, 447)



    } 
     if x = 2
    {
        slots(color,606, 425, 642, 450)
        slots(color,569, 423, 595, 447)
        slots(color,691, 425, 723, 453)
        slots(color,650, 425, 684, 455)



    } 
     if x = 3
    {
                slots(color,569, 423, 595, 447)
        slots(color,650, 425, 684, 455)
        slots(color,606, 425, 642, 450)
        slots(color,691, 425, 723, 453)



    } 

}


seventhrow(color){
Random, x, 1,3
     if x = 1
    {
    slots(color,694, 458, 726, 487)
    slots(color,645, 457, 681, 489)
    slots(color,603, 455, 641, 487)
    slots(color,563, 456, 601, 486)


    } 
     if x = 2
    {
    slots(color,603, 455, 641, 487)
    slots(color,563, 456, 601, 486)
    slots(color,694, 458, 726, 487)
    slots(color,645, 457, 681, 489)



    } 

     if x = 3
    {
    slots(color,563, 456, 601, 486)
    slots(color,645, 457, 681, 489)
    slots(color,603, 455, 641, 487)
    slots(color,694, 458, 726, 487)


    } 
}





;;; very important tightly wrapped function. Basically, use it on each inventory slot to determine whether to click a color or not

slots(color,x,y,w,h)
{
 PixelSearch, px, py, x, y, w, h, color,5, Fast RGB
 If (errorlevel = 0)
                {
                    findspot(color, px-12, py-20, px+12,py+20)
                    return true
                }
    Else
        return false
}





;







;;;;;; end inventory stuff




antibanstats(){
Random, r1, 1,100

if (r1 < 5)
{
Random, r2, 1,100
    if (r2 < 3)
    {
        Random, x1,573, 593
        Random, y1,202,222
        Random, x2,637, 658
        Random, y2,204,222
        Random, MouseSpeed, 165,220
        mousegetpos, MouseXpos, MouseYpos
        RandomBezier( MouseXpos, MouseYpos, x1+ weightedclick(-1,0,1), y1 + weightedclick(-1,0,1), "T"MouseSpeed "P3-1")
        randsleep(50,90)
        click
        randsleep(3200,5300)
         mousegetpos, MouseXpos, MouseYpos
        RandomBezier( MouseXpos, MouseYpos, x2+ weightedclick(-1,0,1), y2 + weightedclick(-1,0,1), "T"MouseSpeed "P3-1")
        randsleep(50,90)
        click 
        randsleep(50,90)       
    }

} 

}


antibanfriends(){
Random, r1, 1,100

if (r1 < 3)
{
Random, r2, 1,100
    if (r2 < 3)
    {
        Random, x1,574, 587
        Random, y1,504,517
        Random, x2,637, 658
        Random, y2,204,222
        Random, MouseSpeed, 165,220
        mousegetpos, MouseXpos, MouseYpos
        RandomBezier( MouseXpos, MouseYpos, x1+ weightedclick(-1,0,1), y1 + weightedclick(-1,0,1), "T"MouseSpeed "P3-1")
        randsleep(50,90)
        click
        randsleep(3200,5300)
         mousegetpos, MouseXpos, MouseYpos
        RandomBezier( MouseXpos, MouseYpos, x2+ weightedclick(-1,0,1), y2 + weightedclick(-1,0,1), "T"MouseSpeed "P3-1")
        randsleep(50,90)
        click 
        randsleep(50,90)       
    }

} 

}





antiban(x)
		{
				Random, r1, 1, 100
				if (r1 < x) { ;change percentage to whatever customer wants
				Random, PercentageSleep, 4500, 15000
				Sleep, %PercentageSleep%
				}
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
            RandomBezier( MouseXpos, MouseYpos, centerTileX+ weightedclick(-1,0,1), centerTileY+ weightedclick(-1,0,1), "T"MouseSpeed "P3-1")
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












;;; Some General useful functions

; Weighted clicks to target center of coordinates you output, integrated within findspot


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

