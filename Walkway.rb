# Walkway.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/21/10.
# For license see LICENSE.TXT.

require 'GameObject'

class Walkway < GameObject
	@@spritesLoaded = false
	
	def initialize(x, y, isLeftOriented)
		super(x, y)
		
		unless @@spritesLoaded
			@@sprites = []
	
			for i in 1..8
				@@sprites << Sprite.spriteWithName("walkway#{i}.png")
			end
			
			@@spritesLoaded = true
		end
		
		@isLeftOriented = isLeftOriented
		loopSprites(@@sprites)
	end
	
	def moveGameObject(gameObject)
		speed = 2
		if gameObject.isGroundCreature && !(gameObject.wasMovedByMovingPlatform)
			rc = gameObject.rect
			rc.origin.y += 2
			if NSIntersectsRect(rc, self.rect)
				@isLeftOriented ? gameObject.x -= speed : gameObject.x += speed
				gameObject.wasMovedByMovingPlatform = true
			end
		end
	end
	
	def update(game)
		loopSprites(@@sprites)
		
		game.gameObjects.each do |gameObject|
			moveGameObject(gameObject)
		end
		
		moveGameObject(game.player)
		game.player.moveWorld(game)
	end
	
	def isPlatform
		true
	end
end



