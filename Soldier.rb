# Soldier.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/17/10.
# For license see LICENSE.TXT.

require 'GroundCreature'

module MacRubyGame
	class Soldier < GroundCreature
		@@spritesLoaded = false
		
		def initialize(x, y)
			super(x, y)
			
			unless @@spritesLoaded
				@@leftMoves = []
				@@rightMoves = []
				@@leftDie = []
				@@rightDie = []	
			
				for i in 1..4
					@@leftMoves << Sprite.spriteWithName("lSolmov#{i}.png")
				end
				
				for i in 1..4
					@@rightMoves << Sprite.spriteWithName("rSolmov#{i}.png")
				end
				
				for i in 1..4
					@@leftDie << Sprite.spriteWithName("lSoldie#{i}.png")
				end
				
				for i in 1..4
					@@rightDie << Sprite.spriteWithName("rSoldie#{i}.png")
				end
			
				@@spritesLoaded = true
			end
			
			@currentSprite = @@leftMoves.first
			@lives = 5
			@wasDamaged = false
			@isLeftOriented = true
			@changedOrientation = false
		end
		
		def updateCurrentSprite
			if @lives <= 0
				loopSprites(@isLeftOriented ? @@leftDie : @@rightDie, true, true)
			else
				loopSprites(@isLeftOriented ? @@leftMoves : @@rightMoves)
			end
		end
		
		def moveUpdate(game)
			if @lives > 0
				if @isLeftOriented
					@x -= 8			
				else
					@x += 8
				end	
			end
		end
		
		def update(game)
			super(game)
			moveUpdate(game)			
			jumpUpdate(game)
			if @isJumping && @lives > 0
				@isLeftOriented = !@isLeftOriented unless @changedOrientation
				@changedOrientation = true
				@x = @oldX
			else
				@changedOrientation = false
			end
			updateCurrentSprite
		end	
		
		def collidesWithFire
			@lives > 0
		end
		
		def addDamage(amount)
			if @lives > 0
				@lives -= amount	
				@wasDamaged = true			
			end
		end
		
		def draw(isVisible)
			if @currentSprite 
				motionBlur(isVisible)
				if isVisible		
					if @wasDamaged
						glColor4f(1, 0.5, 0.5, 1)
						@wasDamaged = false
					else
						glColor4f(1, 1, 1, 1)
					end
					@currentSprite.drawAtX @x, y:@y
				end
			end
		end	
	end
end
