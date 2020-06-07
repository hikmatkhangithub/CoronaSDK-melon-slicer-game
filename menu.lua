
local composer = require( "composer" )

local scene = composer.newScene()

local function gotoGame()
	composer.gotoScene( "game" )
end

local function gotoHighScores()
	composer.gotoScene( "highscore" )
end

function scene:create( event )

    local sceneGroup = self.view
   
    local background = display.newImage(sceneGroup,"game-background.png",true)
	background.x = display.contentWidth / 2
	background.y = display.contentHeight / 2
    
    local banana = display.newImage(sceneGroup,"banana.png", true)
    banana.x = display.contentWidth / 1.3
    banana.y = display.contentHeight / 2.5
    
    local apple = display.newImage(sceneGroup,"Green_Apple.png", true)
    apple.x = display.contentWidth / 2
    apple.y = display.contentHeight / 3.2

    local SanSei = display.newImage(sceneGroup,"SenSeiSlice (1).png", true)
    SanSei.x = display.contentWidth / 5.5
    SanSei.y = display.contentHeight / 1.78
    SanSei.width = 520
    SanSei.height = 520

local hikmatSlicer = display.newImage(sceneGroup, "hikmatLogo.png")
    hikmatSlicer.x = display.contentWidth / 2
    hikmatSlicer.y = display.contentHeight / 4

    local Slicer = display.newImage(sceneGroup, "slicer.png")
    Slicer.x = display.contentWidth / 2
    Slicer.y = display.contentHeight / 2.8

local SanseiRight = display.newImage(sceneGroup,"SenSei.png", true)
    SanseiRight.x = display.contentWidth / 1.15
    SanseiRight.y = display.contentHeight / 1.41
    
	local playButton = display.newImage(sceneGroup, "newPlayButton.png")
    playButton.x = display.contentWidth / 2
    playButton.y = display.contentHeight / 2
    
    local highscoreButton = display.newImage(sceneGroup, "HighscoreButton.png")
    highscoreButton.x = display.contentWidth / 2
    highscoreButton.y = display.contentHeight / 1.4

    playButton:addEventListener( "tap", gotoGame )
    highscoreButton:addEventListener( "tap", gotoHighScores )

end
-- -- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
-- -- -----------------------------------------------------------------------------------
return scene