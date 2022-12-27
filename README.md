# TomRSLib
Tom's Old School RuneScape AHK Library. Contains functions for creating a bot very easily.
Open an issue if you need help but I would recommend doing something like this in your script at execution

ifnotexist,TomRSLib.ahk
{

    urldownloadtofile,https://github.com/tom239955/TomRSLib/raw/main/TomRSLib.ahk,TomRSLib.ahk
    sleep 500
    reload
    
}
#Include TomRSLib.ahk

