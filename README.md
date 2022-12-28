# TomRSLib
Tom's Old School RuneScape AHK Library. Contains functions for creating a bot very easily.

Function List:

-- setup(x): Use "North", "South", "East" , or "West" in place of x to setup for the script
-- clickspot(color): Searches near character when fully zoomed out to full screen
-- waitbank(sec): returns true or false if bank window is open, will scan for the amount of seconds you want it to, return true or false to perform actions
-- checkminimap(color): checks for a color on the minimap and returns true or false
-- mmpathing(color): clicks a color on the minimap and then waits til your character is next to it in game
-- checkdrop(color): will check if inventory is full in the last spot and drop only marked items
-- findspot(color,x,y,w,h): finds a spot on the screen and clicks it, always the center but randomized offset built in
-- findspotright(color,x,y,w,h): finds a spot on the screen and right clicks it
-- weightedclick(min, target, max): min, max, target, generates a value 
-- randsleep(x,y): randomized sleep between two values
-- bank(tilecolor,bankcolor,itemcolor,sec): clicks tile, runs to tile, clicks bank, waits for it to open, deposits color in inventory
-- antiban(x) - randomized small sleeps with the ability to set a percentage
-- antibanstats() - perfectly waited for randomly checking thes stats page for a few seconds, just place into a function that is looping or where you want the chance of checking the page. I personally place it in downtime loops
-- antibanfriends() - perfectly weighted to check friends list randomly for a few seconds  
-- checkobject(color): checks if a specific color is on screen and returns true or flase
-- checklast(color): checks last spot in inventory and returns true or false
