
slashSounds = {slash1 = audio.loadSound("slash1.wav"), slash2 = audio.loadSound("slash2.wav"), slash3 = audio.loadSound("slash3.wav")}
slashSoundEnabled = true 
minTimeBetweenSlashes = 150 
minDistanceForSlashSound = 50 
choppedSound = {chopped1 = audio.loadSound("chopped1.wav"), chopped2 = audio.loadSound("chopped2.wav")}
preExplosion = audio.loadSound("preExplosion.wav")
explosion = audio.loadSound("explosion.wav")

avalFruit = {}
splashImgs = {}
gushProp = {density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 4, maskBits = 8} } 

minVelocityY = 850
maxVelocityY = 1100

minVelocityX = -200
maxVelocityX = 200

minAngularVelocity = 100
maxAngularVelocity = 200


minAngularVelocityChopped = 100
maxAngularVelocityChopped = 200

maxPoints = 5
lineThickness = 20
lineFadeTime = 250
endPoints = {}

minGushRadius = 10 
maxGushRadius = 25
numOfGushParticles = 15
gushFadeTime = 500
gushFadeDelay = 500

minGushVelocityX = -350
maxGushVelocityX = 350
minGushVelocityY = -350
maxGushVelocityY = 350

fruitShootingInterval = 1000
bombShootingInterval = 5000

splashFadeTime = 2500
splashFadeDelayTime = 5000
splashInitAlpha = .5
splashSlideDistance = 50 

function getRandomFruit()

	local fruitProp = avalFruit[math.random(1, #avalFruit)]
	local fruit = display.newImage(fruitProp.whole)
	fruit.whole = fruitProp.whole
	fruit.top = fruitProp.top
	fruit.bottom = fruitProp.bottom
	fruit.splash = fruitProp.splash
	
	return fruit
	
end
------------------------------------------------------------------------------------------------------------------
function initFruitAndSplash()
	
	local watermelon = {}
	watermelon.whole = "watermelonWhole.png"
	watermelon.top = "watermelonTop.png"
	watermelon.bottom = "watermelonBottom.png"
	watermelon.splash = "redSplash.png"
	table.insert(avalFruit, watermelon)
	
	local strawberry = {}
	strawberry.whole = "strawberryWhole.png"
	strawberry.top = "strawberryTop.png"
	strawberry.bottom = "strawberryBottom.png"
	strawberry.splash = "redSplash.png"
	table.insert(avalFruit, strawberry)
	
	-- Initialize splash images
	table.insert(splashImgs, "splash1.png")
	table.insert(splashImgs, "splash2.png")
	table.insert(splashImgs, "splash3.png")
end
------------------------------------------------------------------------------------------------------------------
function getRandomValue(min, max)
	return min + math.abs(((max - min) * math.random()))
end

function playRandomSlashSound()
	
	audio.play(slashSounds["slash" .. math.random(1, 3)])
end

function playRandomChoppedSound()
	
	audio.play(choppedSound["chopped" .. math.random(1, 2)])
end

function getRandomSplash()

 	return display.newImage(splashImgs[math.random(1, #splashImgs)])
end
------------------------------------------------------------------------------------------------------------------
function setUpCatchPlatform()
	
	local platform = display.newRect( 0, 0, display.contentWidth * 4, 50)
	platform.x =  (display.contentWidth / 2)
	platform.y = display.contentHeight + display.contentHeight
	physics.addBody(platform, "static", catchPlatformProp)
	
	platform.collision = onCatchPlatformCollision
	platform:addEventListener( "collision", platform )
end

function onCatchPlatformCollision(self, event)

	event.other:removeSelf()
end