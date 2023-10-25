
; Tom's OSRS AHK Functions
; = Contains super useful functions for finding all screen coodinates
; call initialize() to get pretty much everything
; This is the improved version

#include <Vis2>


#NoEnv
CoordMode, Mouse, Client
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
; SetControlDelay 1
; SetWinDelay 0
; SetKeyDelay -1
; SetBatchLines -1
; setmousedelay, 0




; hardware level mousemovement and clicking

mousemove2(x, y) {
    ; Call SetCursorPos directly
    DllCall("SetCursorPos", "int", x, "int", y)
}


SendLeftClick() {
    ; MOUSEEVENTF_LEFTDOWN = 0x0002
    ; MOUSEEVENTF_LEFTUP = 0x0004
    DllCall("mouse_event", "UInt", 0x0002, "UInt", 0, "UInt", 0, "UInt", 0, "UInt", 0) ; Mouse down
    DllCall("mouse_event", "UInt", 0x0004, "UInt", 0, "UInt", 0, "UInt", 0, "UInt", 0) ; Mouse up
}



SendRightClick() {
    ; MOUSEEVENTF_RIGHTDOWN = 0x0008
    ; MOUSEEVENTF_RIGHTUP = 0x0010
    DllCall("mouse_event", "UInt", 0x0008, "UInt", 0, "UInt", 0, "UInt", 0, "UInt", 0) ; Right mouse button down
    DllCall("mouse_event", "UInt", 0x0010, "UInt", 0, "UInt", 0, "UInt", 0, "UInt", 0) ; Right mouse button up
}


; end hardware level inputs






global itemsFilePath := A_Temp . "\items.txt" ; We'll store the downloaded file in the temp directory
URLDownloadToFile, https://raw.githubusercontent.com/mot-stuff/tplessentials/main/items.txt, %itemsFilePath%
; Create a dictionary for item name to ID mapping
global itemNameToID := Object()

; Read the contents of the file into a variable
FileRead, itemsContent, %itemsFilePath%

; Parse the content by lines
Loop, Parse, itemsContent, `n, `r
{
    ; Split each line at the tab to separate item ID and name
    parts := StrSplit(A_LoopField, "`t") ; `t represents tab in AHK

    if (parts.Length() >= 3) ; Considering there are two tabs
    {
        itemName := Trim(parts[3]) ; Name is after the two tabs
        itemID := Trim(parts[1]) ; ID is before the tabs

        itemNameToID[itemName] := itemID ; Map the name to ID in the dictionary
    }
}


; Initialize()
; This function gets all our coordinates for the game - call it manually to update at any time
; if slots are not working you need to adjust the offsets from the color you find
initializebank(){
    WinGetActiveStats, RuneLite, winW, winH, X, Y
sleep 50

Pixelsearch, bank1,bank2,0, 0, winW, winH,0xFF981F, 0, Fast RGB
    If (errorlevel = 0)
        {
            global bank1x := bank1+25
            global bank1y := bank2+85
            global bank2x := bank1x + 50
            global bank2y := bank1y
            global bank3x := bank2x + 50
            global bank3y := bank2y
        }
Pixelsearch, dep1,dep2,0, 0, winW, winH,0x26FA2B, 3, Fast RGB
}

initialize(){
winactivate, ahk_class SunAwtFrame
; Fetch position and size of the window with the specified ahk_class
WinGetActiveStats, RuneLite, winW, winH, X, Y

; Adjust the width and height by removing 300 pixels from the right and bottom
global searchableW := winW - 300
global searchableH := winH - 300

; Set the searchable area's X and Y to the original window's X and Y
global searchableX := winX
global searchableY := winY

Pixelsearch, compassx2,compassy2,0, 0, winW, winH,0xCF7610, 0, Fast RGB
    If (errorlevel = 0)
    {
WinGetActiveStats, Runelite, Width, Height, X, Y
If (Width <= 1100) and (Height <=650)
{
    global compassx := compassx2-175
}
If Width > 1100
{
    global compassx := compassx2-15
}
If Height <= 650
{
   global compassy := compassy2-40
}
If Height > 650
{
   global compassy := compassy2-150
}
        global qpx := compassx-13
        global qpy := compassy+75
         global mapcenterxx :=  qpx + 90
        global mapcenteryy := qpy - 20
    }   


sleep 300
Pixelsearch, px, py, 0, 0, winW, winH, 0x303749, 0, Fast RGB
If (errorlevel = 0)
{
    px += 5

    ; Initial offsets and distances
    xOffset := px - 26
    yOffset := py + 22
    slotWidth := 20
    slotHeight := 28
    distanceX := 25
    distanceY := 8

    global Slots := []

    ; Loop through rows
    Loop, 7 ; 7 rows
    {
        currentYOffset := (A_Index - 1) * (slotHeight + distanceY)

        ; Loop through slots in a row
        Loop, 4 ; 4 slots per row
        {
            currentXOffset := (A_Index - 1) * (slotWidth + distanceX)

            slot := {}
            slot.x := xOffset + currentXOffset
            slot.y := yOffset + currentYOffset
            slot.w := slot.x + slotWidth
            slot.h := slot.y + slotHeight
            slot.midX := (slot.x + slot.w) / 2
            slot.midY := (slot.y + slot.h) / 2
            sleep 50
            Slots.Push(slot)
        }
        
    }

}

sleep 500

; declare some other things
global spectabx := slots[1].x -20
global spectaby := slots[1].y -25
global Statsx := slots[1].x + 10
global Statsy := slots[1].y -25
global Inventorytabx := slots[1].x + 80
global Inventorytaby := slots[1].y -25
global equiptabx := slots[1].x + 80 + 30
global equiptaby := slots[1].y -25
global prayertabx := slots[1].x + 80 + 30 + 39
global prayertaby := slots[1].y -25
global magictabx := slots[1].x + 80 + 30 + 30 + 35
global magictaby := slots[1].y -25
global friendstabx := slots[1].x + 15
global friendstaby := slots[1].y + 270
global logouttabx := slots[1].x + 85
global logouttaby := slots[1].y +270
global logoutbuttonx := slots[1].x + 85
global logoutbuttony := slots[1].y +220
global settingsx := slots[1].x + 80 + 35
global settingsy := slots[1].y +270
global clantabx := slots[1].x -20
global clantaby := slots[1].y +270





; Debugging to check the value of slots[1].x and slots[1].y
; Gui Main:New
; global text1 := "Welcome to Tom's Scripts"
; Gui Main: -Caption +AlwaysOnTop +LastFound

; Gui Main: Color, 000000
; Gui Main: Font, s8 cWhite
; Gui Main: Add, Text, w200 vtext1, %text1%

; WinGetPos, wtx, wty, wwtx, wwty, ahk_class SunAwtFrame
; wty += 0
; wtx += 0
; wwty -= 40
; WinActivate, ahk_class SunAwtFrame
; Gui Main: Show, x%wtx% y%wwty%
; Tooltip
; WinSet, TransColor, 000000





; UpdateText("Starting Setup.")
; randsleep(500,1500)
; UpdateText("Loading.....")
; randsleep(500,1500)
; UpdateText("Loading...")
; randsleep(500,1500)
; UpdateText("Loading..")
; randsleep(1000,1500)
; UpdateText("Loaded. Please Wait.")
; randsleep(500,1500)
; UpdateText("Ready to Start.")

    ; end fancy gui


    ; debugging and extras
    ;
    ;
    ; can declare all slots different names if you want
    ; Global slot1x := Slots[1].x
    ; Global slot1y := Slots[1].y
    ; Global slot1w := Slots[1].w
    ; Global slot1h := Slots[1].h
    ;etc
    ;
        ; ; Display tooltips on each slot's middle position
        ; for index, slot in Slots {
        ;     ToolTip, x, slots[A_Index].midX, slots[A_Index].midY
        ;     Sleep, 1000 ; Display the tooltip for 1 second (adjust as needed)
        ;     ToolTip
;                       }


; outputs slot coords
; outputFile := A_Desktop . "\slots.txt"
; ; If file exists, delete to start fresh
; if FileExist(outputFile)
;     FileDelete, %outputFile%

; ; Loop through the Slots array and write data to file
; Loop, 28 ; Given that you have 28 slots
; {
;     slot := Slots[A_Index]
    
;     slotInfo := "Slot #" . A_Index . "`n" 
;         . "x: " . slot.x . "`n"
;         . "y: " . slot.y . "`n"
;         . "w: " . slot.w . "`n"
;         . "h: " . slot.h . "`n"
;         . "midX: " . slot.midX . "`n"
;         . "midY: " . slot.midY . "`n`n"
    
;     ; Append data to file
;     FileAppend, %slotInfo%, %outputFile%
; }
; ; Notify user that the data has been written

}

CheckSlotsForColor(Slots, colorToCheck) {
    for index, slot in Slots {
        PixelSearch, foundX, foundY, slot.x, slot.y, slot.w, slot.h, colorToCheck, 0, Fast RGB
        if errorlevel {
            ; Color was found in the slot's region. You can take some action here.
            ; For instance:
            mousemove, slot.midX, slot.midY
        }
    }
}


randomaction(){
global
Random, action, 1,3
if action = 1
    {
        Random, pp, -5,5
        Random, mousespeed, 250,500
        mousegetpos, MouseXpos, MouseYpos
        RandomBezier( MouseXpos, MouseYpos, Statsx+pp, Statsy+pp, "T"MouseSpeed "P2-5")
        randsleep(50,200)
        click
        randsleep(5000,12000)
        Random, pp, -5,5
        Random, mousespeed, 250,500
        mousegetpos, MouseXpos, MouseYpos
        RandomBezier( MouseXpos, MouseYpos, Inventorytabx+pp, Inventorytaby+pp, "T"MouseSpeed "P2-5")
        randsleep(50,200)
        click
    }
if action = 2
        {
            Random, pp, -5,5
            Random, mousespeed, 250,500
            mousegetpos, MouseXpos, MouseYpos
            RandomBezier( MouseXpos, MouseYpos, friendstabx+pp, friendstaby+pp, "T"MouseSpeed "P2-5")
            randsleep(50,200)
            click
            randsleep(5000,12000)
            Random, pp, -5,5
            Random, mousespeed, 250,500
            mousegetpos, MouseXpos, MouseYpos
            RandomBezier( MouseXpos, MouseYpos, Inventorytabx+pp, Inventorytaby+pp, "T"MouseSpeed "P2-5")
            randsleep(50,200)
            click
        }
if action = 3
            {
                Random, pp, -5,5
                Random, mousespeed, 250,500
                mousegetpos, MouseXpos, MouseYpos
                RandomBezier( MouseXpos, MouseYpos, clantabx+pp, clantaby+pp, "T"MouseSpeed "P2-5")
                randsleep(50,200)
                click
                randsleep(5000,12000)
                Random, pp, -5,5
                Random, mousespeed, 250,500
                mousegetpos, MouseXpos, MouseYpos
                RandomBezier( MouseXpos, MouseYpos, Inventorytabx+pp, Inventorytaby+pp, "T"MouseSpeed "P2-5")
                randsleep(50,200)
                click
            }
    

}





UpdateText(newText) {
    global
    GuiControl, Main:, text1, %newText%

    Gui, Main:Hide ; Hide the GUI
    Gui, Main:Show ; Show the GUI again to force a redraw
    WinActivate, ahk_class SunAwtFrame
}

; end ini
checkInventory(color){
    global
    UpdateText("Checking Inventory.")
    ; Bounds of the entire slot region
    startX := Slots[1].x
    startY := Slots[1].y
    endX := Slots[28].w
    endY := Slots[28].h

    Pixelsearch, itemXs, itemYs, startX, startY, endX, endY, color, 15, Fast RGB
    If (errorlevel = 0)
        {
        UpdateText("Items in Inventory")
        return true
        }
    If (errorlevel = 1)
    {
        UpdateText("Items NOT in Inventory")
        return false
    }
}


; checks activity bar on top left 3rd party plugin - breaks if not active

progresscheck(){
    global
    loop{
Pixelsearch, progx,progy, 0, 0, 0+200, 0+109, 0xFF0000,3, Fast RGB
    If (errorlevel = 0)
        {
            UpdateText("Still Active.")
            sleep 30
        }
    If errorlevel = 1
        {
            UpdateText("No Longer Active.")
            break
        }
    }



}



bank(color,item, mode){
    global
radialobject(color,90)
randsleep(1200,1500)
initializebank()

if mode = 1
    {
        Deposit(item)
        UpdateText("Getting Items.")
        randsleep(660,900)
        Random, pp, -5,5
Random, mousespeed, 250,500
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, bank1x+pp, bank1y+pp, "T"MouseSpeed "P2-5")
randsleep(50,200)
click
antiban(10)
UpdateText("Closing Bank.")
randsleep(850,1300)
Send {Esc}
randsleep(1800,2300)
UpdateText("Waiting for next action...")
    }
if mode = 2
{
    Deposit(item)
    UpdateText("Getting Items.")
    randsleep(660,900)
    Random, pp, -5,5
Random, mousespeed, 250,500
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, bank1x+pp, bank1y+pp, "T"MouseSpeed "P2-5")
randsleep(50,200)
click
randsleep(660,900)
Random, pp, -5,5
Random, mousespeed, 250,500
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, bank2x+pp, bank2y+pp, "T"MouseSpeed "P2-5")
randsleep(50,200)
click
antiban(10)
UpdateText("Closing Bank.")
randsleep(850,1300)
Send {Esc}
randsleep(1800,2300)
UpdateText("Waiting for next action...")
}
if mode = 3
{
    Deposit(item)
    UpdateText("Getting Items.")
    randsleep(660,900)
    Random, pp, -5,5
Random, mousespeed, 250,500
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, bank1x+pp, bank1y+pp, "T"MouseSpeed "P2-5")
randsleep(50,200)
click
randsleep(660,900)
Random, pp, -5,5
Random, mousespeed, 250,500
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, bank2x+pp, bank2y+pp, "T"MouseSpeed "P2-5")
randsleep(50,200)
click
randsleep(660,900)
Random, pp, -5,5
Random, mousespeed, 250,500
mousegetpos, MouseXpos, MouseYpos
RandomBezier( MouseXpos, MouseYpos, bank3x+pp, bank3y+pp, "T"MouseSpeed "P2-5")
randsleep(50,200)
click
antiban(10)
UpdateText("Closing Bank.")
randsleep(850,1300)
Send {Esc}
randsleep(1800,2300)
UpdateText("Waiting for next action...")
}
if mode = 4
    {
        Deposit(item)
        randsleep(500,1000)
        UpdateText("Closing Bank.")
randsleep(850,1300)
Send {Esc}
randsleep(1800,2300)
UpdateText("Waiting for next action...")

    }

}






; helper function to pass through multi color
clickobjectdefined(color,xx,yy,ww,hh){
    global
    UpdateText("Performing Action.")
Random, ms, 3,5
Random, MouseSpeed, 165,220
mousegetpos, MouseXpos, MouseYpos
PixelSearch, OutputVarX, OutputVarY, xx, yy, ww, hh, color, 5, Fast RGB
sleep 300
    PixelSearch, OutputVarX2, OutputVarY2, ww, hh, xx, yy, color, 5, Fast RGB
                centerTileX := ((OutputVarX + OutputVarX2) / 2)
                centerTileY := ((OutputVarY + OutputVarY2) / 2)
        if (errorlevel = 0){ 
            RandomBezier( MouseXpos, MouseYpos, centerTileX - 3 + weightedclick(-1,0,1), centerTileY+ weightedclick(-1,0,1), "T"MouseSpeed "P2-5")
             randsleep(50,90)
            click
            randsleep(50,90)
            mousegetpos, MouseXpos, MouseYpos
            UpdateText("Waiting for next action...")
        }
        if (errorlevel = 1)
            {
                UpdateText("Nothing was found.")   
            }
    }



clickobject(color){
    global
    UpdateText("Performing Action.")
Random, ms, 3,5
Random, MouseSpeed, 165,220
mousegetpos, MouseXpos, MouseYpos
PixelSearch, OutputVarX, OutputVarY, searchableX, searchableY, searchableW, searchableH, color, 5, Fast RGB
sleep 300
    PixelSearch, OutputVarX2, OutputVarY2, searchableW, searchableH, searchableX, searchableY, color, 5, Fast RGB
                centerTileX := ((OutputVarX + OutputVarX2) / 2)
                centerTileY := ((OutputVarY + OutputVarY2) / 2)
        if (errorlevel = 0){ 
            RandomBezier( MouseXpos, MouseYpos, centerTileX - 3 + weightedclick(-1,0,1), centerTileY+ weightedclick(-1,0,1), "T"MouseSpeed "P2-5")
             randsleep(50,90)
            click
            randsleep(50,90)
            mousegetpos, MouseXpos, MouseYpos
            UpdateText("Waiting for next action...")
        }
    }



; if multiple objects of same color are on screen search to click it with this if closest to center otherwise define search area using helper function
radialobject(color,offset)
{
    UpdateText("Performing Action.")
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
    
loop{
PixelSearch, px, py, CenterX - offset,CenterY - offset,CenterX + offset,CenterY + offset, color, 1, Fast RGB
    If (errorlevel = 0)
{        
        clickobjectdefined(color,px+offset,py+offset,px-offset,py-offset)
        mousegetpos, MouseXpos, MouseYpos
        break
        }
    If (errorlevel = 1)
        offset += 10

        if offset > 600
          {
            UpdateText("No Banker was found. Restarting in 10.")
            sleep 1000
            UpdateText("No Banker was found. Restarting in 9.")
            sleep 1000
            UpdateText("No Banker was found. Restarting in 8.")
            sleep 1000
            UpdateText("No Banker was found. Restarting in 7.")
            sleep 1000
            UpdateText("No Banker was found. Restarting in 6.")
            sleep 1000
            UpdateText("No Banker was found. Restarting in 5.")
            sleep 1000
            UpdateText("No Banker was found. Restarting in 4.")
            sleep 1000
            UpdateText("No Banker was found. Restarting in 3.")
            sleep 1000
            UpdateText("No Banker was found. Restarting in 2.")
            sleep 1000
            UpdateText("No Banker was found. Restarting in 1.")
            sleep 1000
            UpdateText("Restarting...")
            sleep 1000
            reload
          }
}
UpdateText("Waiting for next action...")
    }



    checklast(color){
        global Slots
        
        ; Start checking from the last slot and move backwards
        Loop, 28
        {
            currentSlot := Slots[28 - A_Index + 1]
            Pixelsearch, lastx, lasty, currentSlot.x, currentSlot.y, currentSlot.w, currentSlot.h, color, 5, Fast RGB
            If (errorlevel = 0)
                return true
        }
        return false
    }


; ClickSlot(color) clicks all slots in inventory of a certain color
; completely randomized pattern each time

ClickSlot(color)
{
    
    global
    UpdateText("Performing Action.")
    mousegetpos, MouseXpos, MouseYpos
    ; Create an array of indices representing slots
    indices := []
    Loop, 28
        indices.Push(A_Index)

    ; Shuffle the array
    Loop, 28
    {
        ; Pick a random index from the indices array
        Random, rand, 1, indices.Length()
        
        ; Retrieve the slot's number from the randomized index
        slotNum := indices[rand]

        ; Remove that index to avoid processing it again
        indices.RemoveAt(rand)

        ; Obtain slot's coordinates using slotNum
        x1 := Slots[slotNum, "x"]
        y1 := Slots[slotNum, "y"]
        x2 := Slots[slotNum, "w"]
        y2 := Slots[slotNum, "h"]
        midX := Slots[slotNum, "midX"]
        midY := Slots[slotNum, "midY"]

        ; Search for the color in the slot's area
        PixelSearch, foundX, foundY, %x1%, %y1%, %x2%, %y2%, color, 0, Fast RGB
        
        ; If the color is found within the area, click the middle of the slot
        if (!ErrorLevel)
        {
            Random, ms, 3, 5
            Random, MouseSpeed, 165, 220
            mousegetpos, MouseXpos, MouseYpos
            RandomBezier(MouseXpos, MouseYpos, midX + weightedclick(-3, 0, 3), midY + weightedclick(-3, 0, 3), "T" . MouseSpeed . "P2-5")
            click
            
            ; Optional delay after clicking, adjust or remove as necessary ; waits for 0.5 seconds
        }
        if (errorlevel)
            {
                UpdateText("No items were found")   
            }
    }
    randsleep(740,1000)
    UpdateText("Waiting for next action...")
}


Deposit(color)
{
    
    global
    UpdateText("Depositing.")
    mousegetpos, MouseXpos, MouseYpos
    ; Create an array of indices representing slots
    indices := []
    Loop, 28
        indices.Push(A_Index)

    ; Shuffle the array
    Loop, 28
    {
        ; Pick a random index from the indices array
        Random, rand, 1, indices.Length()
        
        ; Retrieve the slot's number from the randomized index
        slotNum := indices[rand]

        ; Remove that index to avoid processing it again
        indices.RemoveAt(rand)

        ; Obtain slot's coordinates using slotNum
        x1 := Slots[slotNum, "x"]
        y1 := Slots[slotNum, "y"]
        x2 := Slots[slotNum, "w"]
        y2 := Slots[slotNum, "h"]
        midX := Slots[slotNum, "midX"]
        midY := Slots[slotNum, "midY"]

        ; Search for the color in the slot's area
        PixelSearch, foundX, foundY, %x1%, %y1%, %x2%, %y2%, color, 0, Fast RGB
        
        ; If the color is found within the area, click the middle of the slot
        if (!ErrorLevel)
        {
            Random, ms, 3, 5
            Random, MouseSpeed, 165, 220
            mousegetpos, MouseXpos, MouseYpos
            RandomBezier(MouseXpos, MouseYpos, midX + weightedclick(-3, 0, 3), midY + weightedclick(-3, 0, 3), "T" . MouseSpeed . "P2-5")
            click
            break
            
            ; Optional delay after clicking, adjust or remove as necessary ; waits for 0.5 seconds
        }
        if (ErrorLevel)
            {
                UpdateText("No Items to Deposit.")   
            }
    }
    randsleep(740,1000)
    UpdateText("Waiting for next action...")
}


ClickSlotPK(color)
{
    global
    UpdateText("Performing Action.")
    mousegetpos, mxp, myp
    ; Create an array of indices representing slots
    indices := []
    Loop, 28
        indices.Push(A_Index)

    ; Shuffle the array
    Loop, 28
    {
        ; Pick a random index from the indices array
        Random, rand, 1, indices.Length()
        
        ; Retrieve the slot's number from the randomized index
        slotNum := indices[rand]

        ; Remove that index to avoid processing it again
        indices.RemoveAt(rand)

        ; Obtain slot's coordinates using slotNum
        x1 := Slots[slotNum, "x"]
        y1 := Slots[slotNum, "y"]
        x2 := Slots[slotNum, "w"]
        y2 := Slots[slotNum, "h"]
        midX := Slots[slotNum, "midX"]
        midY := Slots[slotNum, "midY"]

        ; Search for the color in the slot's area
        PixelSearch, foundX, foundY, %x1%, %y1%, %x2%, %y2%, color, 0, Fast RGB
        
        ; If the color is found within the area, click the middle of the slot
        if (!ErrorLevel)
        {
            Random, ms, 3, 5
            Random, MouseSpeed, 165, 220

            mousegetpos, MouseXpos, MouseYpos
            mousemove, midX, midY
            click
            sleep 38
            
            ; Optional delay after clicking, adjust or remove as necessary ; waits for 0.5 seconds
        }
        
    }
    mousemove, mxp, myp
    UpdateText("Waiting for next action...")
}

CalculateMargin(itemIDToCheck, logFilePath)
{
    ; Extract item prices from the log file for the specified ID
    FileRead, logData, %logFilePath%

    buyForPrice := 0
    sellForPrice := 0
    hasBought := false
    hasSold := false
    firstTimestamp2 := ""
    lastTimestamp2 := ""

    ; Split the log data by lines
    logLines := StrSplit(logData, "`n")

    ; Extract timestamp from the first line for completeness
    if (RegExMatch(logLines[1], "(\d{4}-\d{2}-\d{2},\d{2}:\d{2}:\d{2})", firstMatch))
    {
        firstTimestamp2 := firstMatch1
    }

    Pattern := "(\d{4}-\d{2}-\d{2},\d{2}:\d{2}:\d{2}),(BOUGHT|SOLD),(\d+),(" . itemIDToCheck . "),1,(\d+),(\d)"

    ; Read the log lines from bottom to top
    Loop, % logLines.MaxIndex()
    {
        line := logLines[logLines.MaxIndex() + 1 - A_Index]
        if (!RegExMatch(line, Pattern))
            continue
        
        if (RegExMatch(line, Pattern, match)) 
        {
            
            state := match2
            totalCost := match5  ; Total cost from the matched log
            ; quantity := match5   ; Quantity from the matched log
            pricePerItem := (quantity > 0) ? (totalCost // quantity) : 0 ; Ensure we don't divide by zero
            
            if (state = "BOUGHT" && !hasBought)
            {
                hasBought := true
                sellForPrice := match5  ; Use the matched price for BOUGHT
                lastTimestamp2 := match1  ; Update the last timestamp
            }
            else if (state = "SOLD" && !hasSold)
                {
                    hasSold := true
                    buyForPrice := match5  ; Use the matched price for SOLD
                    desiredProfitPercentage := 1.07  ; Assuming 3% for illustration, you can change it to 1.02 or 1.04 or whatever you desire

                    ; Adjust the sell price for 1% tax if it's over 100
                    sellForPrice := (buyForPrice * desiredProfitPercentage) / 0.99 ; Adjust for 1% tax
                
                    lastTimestamp2 := match1 ; Update the last timestamp
                }
                
        

        ; Exit loop if we've obtained both BOUGHT and SOLD states
        if (hasBought && hasSold)
        {
            break
        }
    }
    }
    
    ; Calculate time difference
 
  timeDiff := TimeDifference(firstTimestamp2, lastTimestamp2)
    ; Create a result object
    result := {}
    result.BuyPrice := buyForPrice
    result.SellPrice := sellForPrice

    ; if (timeDiff > 40)
    ; {
    ;     result.Action := "reload"
    ; }
    if (hasBought && hasSold)
    {
        
        result.Margin := sellForPrice - buyForPrice
        result.Action := "both"
    }
    else if (hasBought)
    {
        result.Action := "boughtOnly"
    }
    else if (hasSold)
    {
        result.Action := "soldOnly"
    }
    else
    {
        result.Action := "neither"
    }

    return result
}

                    


TimeDifference(startTime, endTime)
{
    ; Parse the time from start timestamp
    StringSplit, startParts, startTime, `,`
    StringSplit, startTimeValues, startParts2, `:`

    ; Parse the time from end timestamp
    StringSplit, endParts, endTime, `,`
    StringSplit, endTimeValues, endParts2, `:`

    ; Convert hours and minutes to total minutes
    startTotalMinutes := (startTimeValues1 * 60) + startTimeValues2
    endTotalMinutes := (endTimeValues1 * 60) + endTimeValues2

    ; Calculate the time difference in minutes
    timeDiff := endTotalMinutes - startTotalMinutes

    return timeDiff
}



DropSlot(color)
{
    global
    UpdateText("Dropping...")
    Winactivate, ahk_class SunAwtFrame
    Send {Shift Down}

    ; Create an array of indices representing slots
    indices := []
    Loop, 28
        indices.Push(A_Index)

    ; Shuffle the array
    Loop, 28
    {
        ; Pick a random index from the indices array
        Random, rand, 1, indices.Length()
        
        ; Retrieve the slot's number from the randomized index
        slotNum := indices[rand]

        ; Remove that index to avoid processing it again
        indices.RemoveAt(rand)

        ; Obtain slot's coordinates using slotNum
        x1 := Slots[slotNum, "x"]
        y1 := Slots[slotNum, "y"]
        x2 := Slots[slotNum, "w"]
        y2 := Slots[slotNum, "h"]
        midX := Slots[slotNum, "midX"]
        midY := Slots[slotNum, "midY"]

        ; Search for the color in the slot's area
        PixelSearch, foundX, foundY, %x1%, %y1%, %x2%, %y2%, color, 0, Fast RGB
        
        ; If the color is found within the area, click the middle of the slot
        if (!ErrorLevel)
        {
            Random, ms, 3, 5
            Random, MouseSpeed, 165, 220
            mousegetpos, MouseXpos, MouseYpos
            RandomBezier(MouseXpos, MouseYpos, midX + weightedclick(-3, 0, 3), midY + weightedclick(-3, 0, 3), "T" . MouseSpeed . "P2-5")
            click

            ; Optional delay after clicking, adjust or remove as necessary ; waits for 0.5 seconds
        }
    }
    Send {Shift Up}
    UpdateText("Waiting for next action...")
}


; UseSlots(color1,color2)
; use two slots together, randomizes which it clicks on

UseSlots(color1, color2)
{
    global
    UpdateText("Performing Action.")
    ; Create arrays to store slot indices for each color
    slotsWithColor1 := []
    slotsWithColor2 := []

    ; Loop through all slots
    Loop, 28
    {
        ; Obtain slot's coordinates using slotNum
        x1 := Slots[A_Index, "x"]
        y1 := Slots[A_Index, "y"]
        x2 := Slots[A_Index, "w"]
        y2 := Slots[A_Index, "h"]

        ; Search for color1 in the slot's area
        PixelSearch, foundX, foundY, %x1%, %y1%, %x2%, %y2%, color1, 0, Fast RGB

        ; If color1 is found within the area, add the slot index to the array for color1
        if (!ErrorLevel)
            slotsWithColor1.Push(A_Index)

        ; Search for color2 in the slot's area
        PixelSearch, foundX, foundY, %x1%, %y1%, %x2%, %y2%, color2, 0, Fast RGB

        ; If color2 is found within the area, add the slot index to the array for color2
        if (!ErrorLevel)
            slotsWithColor2.Push(A_Index)
    }

    ; Randomly click one slot for each color if slots are found
    if (slotsWithColor1.Length() > 0 && slotsWithColor2.Length() > 0)
    {
        ; Randomly select a slot index for each color
        Random, randIndex1, 1, slotsWithColor1.Length()
        Random, randIndex2, 1, slotsWithColor2.Length()

        ; Obtain the slot numbers from the randomized indices
        slotNum1 := slotsWithColor1[randIndex1]
        slotNum2 := slotsWithColor2[randIndex2]

        ; Obtain slot coordinates for both slots
        x1_1 := Slots[slotNum1, "x"]
        y1_1 := Slots[slotNum1, "y"]
        midX_1 := Slots[slotNum1, "midX"]
        midY_1 := Slots[slotNum1, "midY"]

        x1_2 := Slots[slotNum2, "x"]
        y1_2 := Slots[slotNum2, "y"]
        midX_2 := Slots[slotNum2, "midX"]
        midY_2 := Slots[slotNum2, "midY"]

        ; Click the middle of both slots together
        Random, MouseSpeed, 165, 220
        mousegetpos, MouseXpos, MouseYpos

        RandomBezier(MouseXpos, MouseYpos, midX_1 + weightedclick(-3, 0, 3), midY_1 + weightedclick(-3, 0, 3), "T" . MouseSpeed . "P2-5")
        Click
        mousegetpos, MouseXpos, MouseYpos
        ; Delay for a brief moment between the clicks (adjust as necessary)
        Sleep 250

        RandomBezier(MouseXpos, MouseYpos, midX_2 + weightedclick(-3, 0, 3), midY_2 + weightedclick(-3, 0, 3), "T" . MouseSpeed . "P2-5")
        Click
    }
    UpdateText("Waiting for next action...")
}















antiban(x)
		{
				Random, r1, 1, 1000
				if (r1 < x) { ;change percentage to whatever customer wants
                UpdateText("Performing Antiban.")
				Random, PercentageSleep, 14500, 35000
				Sleep, %PercentageSleep%
                randomaction()
                UpdateText("Waiting for next action...")
				}
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

Box_Draw_Simple(X, Y, W, H, GuiName) {
    Gui, %GuiName%: +ToolWindow -Caption +AlwaysOnTop 
    Gui, %GuiName%: Color, white
    
    Options := "x" . X . " y" . Y . " w" . W . " h" . H
    Gui, Show, %Options%
}


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

IsValidJSON(data) {
    ; Simple validation check
    return (SubStr(data, 1, 1) = "{" and SubStr(data, 0) = "}")
}

IsNumeric(value)
{
    return RegExMatch(value, "^\d+$")
}
GetRSItemData(itemID) {
    ; Ensure the itemID is valid and numeric
    if (itemID = "" || !IsNumeric(itemID))
        return "Error: Invalid ID"

    ; Create a WinHttpRequest object
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        
    ; Define the API endpoint URL
    url := "http://services.runescape.com/m=itemdb_oldschool/api/catalogue/detail.json?item=" . itemID
        
    ; Send a GET request
    whr.Open("GET", url, false)
    whr.Send()

    ; Check the status code of the response
    if (whr.Status != 200)
        return "Error: " . whr.Status . " " . whr.StatusText ; This will return "Error: 404 Not Found" for example

    ; Get the response text
    return whr.ResponseText
}

    SearchRSItemByName(name) {
        ; For this example, let's pretend the Abyssal whip is the only item
        ; and it's returned when the name "whip" is searched.
        if (InStr(name, "")) {
            ; Fetching the item details for Abyssal whip
            return GetRSItemData(4151)
        }
        return ""
    }
    
    SearchRSItemsStartingWith(startingString) {
        ; Create a WinHttpRequest object
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        
        ; Define the API endpoint URL
        url := "https://secure.runescape.com/m=itemdb_oldschool/api/catalogue/items.json?category=1&alpha=" . startingString . "&page=1"
        
        ; Send a GET request
        whr.Open("GET", url, false)
        whr.Send()
        
        ; Get the response text
        response := whr.ResponseText
        return response
    }


    ExportSavedListToFile() {
        ; Get the saved items from the SavedItemList control
        Gui,1: submit,nohide
        GuiControlGet, savedItemsText,, SavedItemList
        
        ; Split the saved items by newline
        savedItems := StrSplit(savedItemsText, "`n", "`r")
        
        ; Prepare the content for the file
        fileContent := ""
        
        ; Loop through each saved item, retrieve its ID from the itemsList, and append it to the file content
        for _, itemName in savedItems {
            itemID := GetIDByName(itemName)
            if (itemID != "") ; Check if we found a matching ID
                fileContent .= itemID . ":" . itemName . "`n"
        }
        
        ; Choose a filename
        fileSavePath := A_Desktop . "\SavedItemList.txt"
        ; Export the fileContent to the chosen file
        FileAppend, %fileContent%, %fileSavePath%
        
        MsgBox, Saved List exported successfully to: %fileSavePath%
    }
    
    
    GetIDByName(itemName) {
        global itemsData
        return itemsData.nameToID.hasKey(itemName) ? itemsData.nameToID[itemName] : ""
    }
    
    ; Function to read and parse the buy limits from the given file
    GetBuyLimitsFromFile(filePath) {
        ; Create an object to hold the buy limits
        limits := {}
        
        ; Read the file
        FileRead, content, %filePath%
        Clipboard := "File Content: " . content
    
        MsgBox, % "File Content: " . content ; Debug line
        
        ; Split the file content into lines
        lines := StrSplit(content, "`n", "`r")
        
        ; Parse each line
        for _, line in lines {
            itemName := ""
            buyLimit := ""
            
            ; Loop through each character in the line
            for index, char in StrSplit(line) {
                ; Check if char is a digit
                if (char is "digit") {
                    buyLimit .= char
                } else if (buyLimit = "") { ; Only add to name if buyLimit hasn't started
                    itemName .= char
                }
            }
            
            ; Store the parsed name and buy limit in the dictionary
            limits[itemName] := buyLimit
        }
        
        return limits
    }
    
    IsSimilar(s1, s2, threshold=0.2) {
        distance := LDistance(s1, s2)
        maxLength := Max(StrLen(s1), StrLen(s2))
        normalizedDistance := distance / maxLength
    
        return (normalizedDistance <= threshold)
    }
    
    LDistance( a, b )
    {
        da := {}
        d := []
        a := StrSplit( a )
        b := StrSplit( b )
        maxdist := a.Length() + b.Length()
        d[-1, -1] := maxdist
        Loop % a.Length() + 1
        {
            i := A_Index - 1
            d[i, -1] := maxdist
            d[i, 0] := i
        }
        Loop % b.Length() + 1
        {
            j := A_Index - 1
            d[-1, j] := maxdist
            d[0, j] := j
        }
        Loop % a.Length()
        {
            db := 0
            i := A_Index
            Loop % b.Length()
            {
                j := A_Index
                k :=  da.HasKey(b[j]) ?  da[b[j]] : da[b[j]] := 0
                l := db
                if !( cost := !(a[i] == b[j]) )
                    db := j
                d[i, j] := _lmin( d[i-1, j-1] + cost, d[i,   j-1] + 1, d[i-1, j  ] + 1, d[k-1, l-1] + (i-k-1) + 1 + (j-l-1 ) ) 
            }
            da[a[i]] := i
        }
        return d[a.Length(), b.Length()] ;I cant understand why but it always reports 1 more than it should. Since I'm a fan of easy solutions I just subtract 1 here
    }
    
    _lMin( p* )
    {
        Ret := p.Pop()
        For each,Val in p
            if ( Val < Ret )
            {
                Ret := Val
            }
        return Ret
    }

    
    OCRSubAreaOfWindow(windowIdentifier, xOffset, yOffset, width, height) {
        ; Retrieve the window's position and size
        WinGetPos, x, y, w, h, % windowIdentifier
    
        ; Adjust the values based on the subarea you want
        x += xOffset
        y += yOffset
    
        ; ; Highlight the area with a transparent window
        ; HighlightArea(x, y, width, height)
        
        ; Use Vis2's OCR function to get text from the specified area
        return OCR([x, y, width, height])
    }

    GetLatestBoughtItems(filePath) {
        FileRead, content, % filePath
        lines := StrSplit(content, "`n", "`r")
    
        ; Counter for found items
        foundCount := 0
        ; Array to store the items found
        items := []
    
        ; Iterate over lines in reverse to get the latest entries
        Loop, % lines.Length()
        {
            line := lines[lines.Length() - A_Index + 1]
            if (InStr(line, "state: BOUGHT")) {
                item := {}
                RegExMatch(line, "item: (\d+)", match)
                item.ItemID := match1
                RegExMatch(line, "worth: (\d+)", match)
                item.Price := match1
                items.Push(item)
                foundCount++
                if (foundCount >= 2)  ; We found the latest two "BOUGHT" entries
                    break
            }
        }
        return items
    }
    
    SetSystemCursor(Cursor := "", cx := 0, cy := 0) {

        static SystemCursors := {APPSTARTING: 32650, ARROW: 32512, CROSS: 32515, HAND: 32649, HELP: 32651, IBEAM: 32513, NO: 32648
                             ,  SIZEALL: 32646, SIZENESW: 32643, SIZENS: 32645, SIZENWSE: 32642, SIZEWE: 32644, UPARROW: 32516, WAIT: 32514}
     
        if (Cursor = "") {
           VarSetCapacity(AndMask, 128, 0xFF), VarSetCapacity(XorMask, 128, 0)
     
           for CursorName, CursorID in SystemCursors {
              CursorHandle := DllCall("CreateCursor", "ptr", 0, "int", 0, "int", 0, "int", 32, "int", 32, "ptr", &AndMask, "ptr", &XorMask, "ptr")
              DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
           }
           return
        }
     
        if (Cursor ~= "^(IDC_)?(?i:AppStarting|Arrow|Cross|Hand|Help|IBeam|No|SizeAll|SizeNESW|SizeNS|SizeNWSE|SizeWE|UpArrow|Wait)$") {
           Cursor := RegExReplace(Cursor, "^IDC_")
     
           if !(CursorShared := DllCall("LoadCursor", "ptr", 0, "ptr", SystemCursors[Cursor], "ptr"))
              throw Exception("Error: Invalid cursor name")
     
           for CursorName, CursorID in SystemCursors {
              CursorHandle := DllCall("CopyImage", "ptr", CursorShared, "uint", 2, "int", cx, "int", cy, "uint", 0, "ptr")
              DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
           }
           return
        }
     
        if FileExist(Cursor) {
           SplitPath Cursor,,, Ext ; auto-detect type
           if !(uType := (Ext = "ani" || Ext = "cur") ? 2 : (Ext = "ico") ? 1 : 0)
              throw Exception("Error: Invalid file type")
     
           if (Ext = "ani") {
              for CursorName, CursorID in SystemCursors {
                 CursorHandle := DllCall("LoadImage", "ptr", 0, "str", Cursor, "uint", uType, "int", cx, "int", cy, "uint", 0x10, "ptr")
                 DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
              }
           } else {
              if !(CursorShared := DllCall("LoadImage", "ptr", 0, "str", Cursor, "uint", uType, "int", cx, "int", cy, "uint", 0x8010, "ptr"))
                 throw Exception("Error: Corrupted file")
     
              for CursorName, CursorID in SystemCursors {
                 CursorHandle := DllCall("CopyImage", "ptr", CursorShared, "uint", 2, "int", 0, "int", 0, "uint", 0, "ptr")
                 DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
              }
           }
           return
        }
     
        throw Exception("Error: Invalid file path or cursor name")
     }
     
     RestoreCursor() {
        return DllCall("SystemParametersInfo", "uint", SPI_SETCURSORS := 0x57, "uint", 0, "ptr", 0, "uint", 0)
     }
    
    ProcessText(text) {
        text := StrReplace(text, "(unf)", "")
        text := StrReplace(text, "(ung)", "")
        text := StrReplace(text, "(un)", "")
        text := StrReplace(text, "(un", "")
        text := StrReplace(text, "(unf", "")
        text := StrReplace(text, "[", "I")
        text := StrReplace(text, "Cooked karambuwan", "Cooked karambwan")
        text := StrReplace(text, "Raw karambuwan", "Raw karambwan")
        text := StrReplace(text, "Yeu logs", "Yew Logs")
        text := StrReplace(text, " (e)", "")
        text := StrReplace(text, "arrou", "arrow")
        text := StrReplace(text, "arrouw", "arrow")
        text := StrReplace(text, "bou", "bow")
        text := StrReplace(text, "Rau anglerfish", "Raw anglgerfish")
        text := StrReplace(text, "Angler fish", "Anglerfish")
        text := StrReplace(text, "imepdragon potion    (unf)", "Snapdragon potion")
        text := StrReplace(text, "imepdragon potion", "Snapdragon potion")
        return Trim(text)
    }
    FormatToOneLine(ocrOutput) {
        ; Replace both newline characters with spaces and then trim the string
        return Trim(StrReplace(StrReplace(ocrOutput, "`n", " "), "`r", " "))
    }


    IsSet(ByRef var) {
        try
            return var != "" 
        catch
            return false
    }

    LoadItems(filePath) {
        FileRead, content, % filePath
        lines := StrSplit(content, "`n", "`r")
        nameToID := {}
        idToName := {}
        Loop, % lines.Length()
        {
            line := lines[A_Index]
            parts := StrSplit(line, "`t`t") ; Splitting on two tabs
            if (parts.Length() >= 2) {
                idToName[parts[1]] := parts[2]
                nameToID[parts[2]] := parts[1]
            }
        }
        return {nameToID: nameToID, idToName: idToName}
    }

    GetRSItemName(itemID) {
        ; Fetch item details using the given item ID
        itemDetails := GetRSItemData(itemID)
    
        ; Error handling for invalid API response
        if (SubStr(itemDetails, 1, 6) = "Error:") {
            return "Error: Invalid ID or API response."
        }
    
        ; Parse the item details to extract the item name
        json := new JSON
        itemData := json.Load(itemDetails)
        
        ; Extract item name from the API data
        itemNameFromAPI := itemData.item.name
    
        return itemNameFromAPI
    }