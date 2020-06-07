
local composer = require( "composer" )
local scene = composer.newScene()
require ("physics")
local ui = require("ui")
local functions= require("functions")
physics.start()
-- physics.setDrawMode ( "hybrid" ) 	
physics.setGravity( 0, 9.8 * 2)

physics.start()

local bombTimer
local fruitTimer


local splashGroup 
local fruitGroup 
------------------------------------------------------------------------------------------------------------------
function main()

	display.setStatusBar( display.HiddenStatusBar )

	setUpBackground()
	setUpCatchPlatform()
	initGroups()
	initFruitAndSplash()
	Runtime:addEventListener("touch", drawSlashLine)
	
	startGame()
end
------------------------------------------------------------------------------------------------------------------
function startGame()
	shootObject("fruit")
	
	bombTimer = timer.performWithDelay(bombShootingInterval, function(event) shootObject("bomb") end, 0)
	fruitTimer = timer.performWithDelay(fruitShootingInterval, function(event) shootObject("fruit") end, 0)

end

function initGroups()
	 splashGroup = display.newGroup()
	 fruitGroup = display.newGroup()
end

function setUpBackground()
	
	local background = display.newImage("new.png", true)
	background.x = display.contentWidth / 2
	background.y = display.contentHeight / 2
	score()
end
--------------------------------------------------------------------------------------------------------------------

function score ()
 myscore =0
 myscoreDisplay=display.newText("score: "..myscore,95,130,native.systemFont,50);
myscoreDisplay:setFillColor(85,162,218 )
end
--------------------------------------------------------------------------------------------------------------------

local fruitProp = {density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 2, maskBits = 1}}
local catchPlatformProp = {density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 1, maskBits = 2}}
function getBomb()

	local bomb = display.newImage( "bomb.png")
	return bomb
end
------------------------------------------------------------------------------------------------------------------
function shootObject(type)
	
	local object = type == "fruit" and getRandomFruit() or getBomb()
	
	fruitGroup:insert(object)
	
	object.x = display.contentWidth / 2
	object.y = display.contentHeight  + object.height * 2

	fruitProp.radius = object.height / 2
	physics.addBody(object, "dynamic", fruitProp)

	if(type == "fruit") then
		object:addEventListener("touch", function(event) chopFruit(object) end)
	else
		local bombTouchFunction
		bombTouchFunction = function(event) explodeBomb(object, bombTouchFunction); end
		object:addEventListener("touch", bombTouchFunction)
	end
	
	local yVelocity = getRandomValue(minVelocityY, maxVelocityY) * -1 -- Need to multiply by -1 so the fruit shoots up 
	local xVelocity = getRandomValue(minVelocityX, maxVelocityX)
	object:setLinearVelocity(xVelocity,  yVelocity)
		
	local minAngularVelocity = getRandomValue(minAngularVelocity, maxAngularVelocity)
	local direction = (math.random() < .5) and -1 or 1
	minAngularVelocity = minAngularVelocity * direction
	object.angularVelocity = minAngularVelocity
	
end
------------------------------------------------------------------------------------------------------------------
function explodeBomb(bomb, listener)

	bomb:removeEventListener("touch", listener)

	bomb.bodyType = "kinematic"
	bomb:setLinearVelocity(0,  0)
	bomb.angularVelocity = 0
	
	-- Shake the stage
	local stage = display.getCurrentStage()
	
	local moveRightFunction
	local moveLeftFunction
	local rightTrans
	local leftTrans
	local shakeTime = 50
	local shakeRange = {min = 1, max = 25}

 	moveRightFunction = function(event) rightTrans = transition.to(stage, {x = math.random(shakeRange.min,shakeRange.max), y = math.random(shakeRange.min, shakeRange.max), time = shakeTime, onComplete=moveLeftFunction}); end 
	moveLeftFunction = function(event) leftTrans = transition.to(stage, {x = math.random(shakeRange.min,shakeRange.max) * -1, y = math.random(shakeRange.min,shakeRange.max) * -1, time = shakeTime, onComplete=moveRightFunction});  end 
	
	moveRightFunction()

	local linesGroup = display.newGroup()

	-- Generate a bunch of lines to simulate an explosion
 -- 	local drawLine = function(event)

	-- 	local line = display.newLine(bomb.x, bomb.y, display.contentWidth * 2, display.contentHeight * 2)
	-- 	line.rotation = math.random(1,360)
	-- 	line.width = math.random(15, 25)
	-- 	linesGroup:insert(line)
	-- end
	local lineTimer = timer.performWithDelay(100, drawLine, 0)
	
	local explode = function(event)
	
		audio.play(explosion)
		blankOutScreen(bomb, linesGroup);
		-- timer.cancel(lineTimer)
		stage.x = 0 
		stage.y = 0
		transition.cancel(leftTrans)
		transition.cancel(rightTrans)
		
	end 

	audio.play(preExplosion, {onComplete = explode})
	timer.cancel(fruitTimer)
	timer.cancel(bombTimer)	
	
end
------------------------------------------------------------------------------------------------------------------
function blankOutScreen(bomb, linesGroup)
	
	local gameOver = displayGameOver()
	gameOver.alpha = 0 
	
	local circle = display.newCircle( bomb.x, bomb.y, 5 )
	local circleGrowthTime = 300
	local dissolveDuration = 1000
	
	local dissolve = function(event) transition.to(circle, {alpha = 0, time = dissolveDuration, delay = 0, onComplete=function(event) gameOver.alpha = 1 end}); gameOver.alpha = 1  end
	
	circle.alpha = 0
	transition.to(circle, {time=circleGrowthTime, alpha = 1, width = display.contentWidth * 3, height = display.contentWidth * 3, onComplete = dissolve})
	
	-- Vibrate the phone
	system.vibrate()
	
	bomb:removeSelf()
	linesGroup:removeSelf()
	
end
------------------------------------------------------------------------------------------------------------------
function displayGameOver()
	
	local group = display.newGroup()
	local gameOver = display.newImage( "gameover.png")
	gameOver.x = display.contentWidth / 2
	gameOver.y = display.contentWidth / 2.5
	group:insert(gameOver)	
	
	newscore=myscore
	local newscoreDisplay=display.newText("score: "..newscore,display.contentWidth / 2,330,native.systemFont,50);

	local replayButton = ui.newButton{
		default = "newReplayButton.png",
		over = "newReplayButton.png",
		onRelease = function(event) group:removeSelf(); startGame() score() newscoreDisplay:removeSelf() end
	}
	group:insert(replayButton)
	
	replayButton.x = display.contentWidth / 2
	replayButton.y = gameOver.y + gameOver.height / 2 + replayButton.height / 2

	myscoreDisplay:removeSelf()
	
	return group
end
------------------------------------------------------------------------------------------------------------------
function chopFruit(fruit)
	
	playRandomChoppedSound()
	
	createFruitPiece(fruit, "top")
	createFruitPiece(fruit, "bottom")
	
	createSplash(fruit)
	createGush(fruit)
	
	fruit:removeSelf()
	myscore = myscore + 5;
myscoreDisplay.text="score:"..myscore;
end
------------------------------------------------------------------------------------------------------------------
function createGush(fruit)

	local i
	for  i = 0, numOfGushParticles do
		local gush = display.newCircle( fruit.x, fruit.y, math.random(minGushRadius, maxGushRadius) )
		gush:setFillColor(255, 0, 0, 255)
		
		gushProp.radius = gush.width / 2
		physics.addBody(gush, "dynamic", gushProp)

		local xVelocity = math.random(minGushVelocityX, maxGushVelocityX)
		local yVelocity = math.random(minGushVelocityY, maxGushVelocityY)

		gush:setLinearVelocity(xVelocity, yVelocity)
		
		transition.to(gush, {time = gushFadeTime, delay = gushFadeDelay, width = 0, height = 0, alpha = 0, onComplete = function(event) gush:removeSelf() end})		
	end
end
------------------------------------------------------------------------------------------------------------------
function createSplash(fruit)
	
	local splash = getRandomSplash()
	splash.x = fruit.x
	splash.y = fruit.y
	splash.rotation = math.random(-90,90)
	splash.alpha = splashInitAlpha
	splashGroup:insert(splash)
	
	transition.to(splash, {time = splashFadeTime, alpha = 0,  y = splash.y + splashSlideDistance, delay = splashFadeDelayTime, onComplete = function(event) splash:removeSelf() end})		
	
end
------------------------------------------------------------------------------------------------------------------
function createFruitPiece(fruit, section)

	local fruitVelX, fruitVelY = fruit:getLinearVelocity()

	
	local half = display.newImage(fruit[section])
	half.x = fruit.x - fruit.x 
	local yOffSet = section == "top" and -half.height / 2 or half.height / 2
	half.y = fruit.y + yOffSet - fruit.y
	
	local newPoint = {}
	newPoint.x = half.x * math.cos(fruit.rotation * (math.pi /  180)) - half.y * math.sin(fruit.rotation * (math.pi /  180))
	newPoint.y = half.x * math.sin(fruit.rotation * (math.pi /  180)) + half.y * math.cos(fruit.rotation * (math.pi /  180))
	
	half.x = newPoint.x + fruit.x 
	half.y = newPoint.y + fruit.y
	fruitGroup:insert(half)
	
	
	half.rotation = fruit.rotation
	fruitProp.radius = half.width / 2  
	physics.addBody(half, "dynamic", fruitProp)
	
	local velocity  = math.sqrt(math.pow(fruitVelX, 2) + math.pow(fruitVelY, 2))
	local xDirection = section == "top" and -1 or 1
	local velocityX = math.cos((fruit.rotation + 90) * (math.pi /  180)) * velocity * xDirection
	local velocityY = math.sin((fruit.rotation + 90) * (math.pi /  180)) * velocity
	half:setLinearVelocity(velocityX,  velocityY)

 	local minAngularVelocity = getRandomValue(minAngularVelocityChopped, maxAngularVelocityChopped)
	local direction = (math.random() < .5) and -1 or 1
	half.angularVelocity = minAngularVelocity * direction
end
------------------------------------------------------------------------------------------------------------------
function drawSlashLine(event)
	
	
-- 	if(endPoints ~= nil and endPoints[1] ~= nil) then
-- 		local distance = math.sqrt(math.pow(event.x - endPoints[1].x, 2) + math.pow(event.y - endPoints[1].y, 2))
-- 		if(distance > minDistanceForSlashSound and slashSoundEnabled == true) then 
-- 			playRandomSlashSound();  
-- 			slashSoundEnabled = false
-- 			timer.performWithDelay(minTimeBetweenSlashes, function(event) slashSoundEnabled = true end)
-- 		end
	-- end
	table.insert(endPoints, 1, {x = event.x, y = event.y, line= nil}) 

	if(#endPoints > maxPoints) then 
		table.remove(endPoints)
	end

	for i,v in ipairs(endPoints) do
		local line = display.newLine(v.x, v.y, event.x, event.y)
		line.width = lineThickness
		transition.to(line, {time = lineFadeTime, alpha = 0, width = 0, onComplete = function(event) line:removeSelf() end})		
	end

	if(event.phase == "ended") then		
		while(#endPoints > 0) do
			table.remove(endPoints)
		end
	end
end
main()
return scene;