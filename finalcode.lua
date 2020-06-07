
-- function createSplash(fruit)
	
-- 	local splash = getRandomSplash()
-- 	splash.x = fruit.x
-- 	splash.y = fruit.y
-- 	splash.rotation = math.random(-90,90)
-- 	splash.alpha = splashInitAlpha
-- 	splashGroup:insert(splash)
	
-- 	transition.to(splash, {time = splashFadeTime, alpha = 0,  y = splash.y + splashSlideDistance, delay = splashFadeDelayTime, onComplete = function(event) splash:removeSelf() end})		
	
-- end