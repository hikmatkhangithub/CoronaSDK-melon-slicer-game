-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() )

composer.gotoScene( "menu" )