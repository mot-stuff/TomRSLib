;;;;; Tom's Runescape Library ;;;;;
;
; - This library contains useful functions for coding ahk bots in runescape. Use #Include TomRSLib.ahk and it will compile into your script when you package it as an exe. 
; - This can only be used in fixed mode with the smallest window size. Sidebar can be open. It only reads game screen
;
;
;
;
;
;
; LATEST UPDATE: 12/26/22
; =====================; Function List ;===================== ;
;
;
; -- clickspot(color): Searches near character when fully zoomed out to full screen
; -- waitbank(sec): returns true or false if bank window is open, will scan for the amount of seconds you want it to, return true or false to perform actions
; -- checkminimap(color): checks for a color on the minimap and returns true or false
; -- mmpathing(color): clicks a color on the minimap and then waits til your character is next to it in game
; -- checkdrop(color): will check if inventory is full in the last spot and drop only marked items
; -- findspot(color,x,y,w,h): finds a spot on the screen and clicks it, always the center but randomized offset built in
; -- findspotright(color,x,y,w,h): finds a spot on the screen and right clicks it
; -- weightedclick(min, target, max): min, max, target, generates a value 
; -- randsleep(x,y): randomized sleep between two values
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
;;
;
;
;
;
;
;
;
; ================================================================ ;










;;;;; ClickSpot Information

;; clickspot(color) searches from the center of your character outwards in fixed mode. Runs about 4 different distances. This is for using findspot to click the center of the target closest to the player.
;; center out searching but still prefers top left, can add direction changing by using variables to pass through the function in the future
;;; Set to be used zoomed out mostly. can be adjusted by adding parameters but I felt it was too annoying so its used zoomed out







clickspot(color){




Pixelsearch,px,py, 516, 164, 538, 185, color, 15, Fast RGB
    If (errorlevel = 0){
        findspot(color, px-10, py-10, px + 10, py + 10)

    }
    If (errorlevel = 1){
        Pixelsearch,px,py, 225, 163, 297, 230, color, 15, Fast RGB
        If (errorlevel = 0){
            findspot(color, px-10, py-10, px + 10, py + 10)

            }
            If (errorlevel = 1){
                Pixelsearch,px,py, 151, 131, 351, 270, color, 15, Fast RGB
                    If (errorlevel = 0){
                    findspot(color, px-10, py-10, px + 10, py + 10)

                    }
                  If (errorlevel = 1){
                        Pixelsearch,px,py, 9, 36, 523, 368, color, 15, Fast RGB
                            If (errorlevel = 0){
                            findspot(color, px-10, py-10, px + 10, py + 10)

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
; checks minimap for color and clicks it, then waits until character is over the tile before returning 

mmpathing(color){
Random, ms, 3,5
Random, MouseSpeed, 180,250
mousegetpos, MouseXpos, MouseYpos
 PixelSearch, xx2, yy2, 586, 47, 720, 182, color, 10, Fast RGB
            If (errorlevel = 0)
            {
                RandomBezier( MouseXpos, MouseYpos, xx2+ weightedclick(-3,-1,0), yy2+ weightedclick(-4,0,4), "T"MouseSpeed "P2-5")
                randsleep(500,100)
                Click
                loop{
                PixelSearch, go1, go2, 235, 187, 295, 229, color, 5, Fast RGB
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







slots(color,x,y,w,h)
{
 PixelSearch, px, py, x, y, w, h, color,5, Fast RGB
 If (errorlevel = 0)
                {
                    findspot(color, px-12, py-20, px+12,py+20)
                }

}


;;;;;; end inventory stuff















;;;;; Findspot Information

; Find spot is a function used to find the middle of a color on the client. This is used within many functions to provide the mouse movement and clicks. Do not modify unless you know what you are doing


findspot(color,x,y,w,h){
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

