# Soldier.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/17/10.
# For license see LICENSE.TXT.

require 'GameObject'

class Soldier < GameObject
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
	end
	
	def update(game)
		super(game)
		
		if @lives <= 0
			playSprites(@isLeftOriented ? @@leftDie : @@rightDie)
		else
			if @isLeftOriented
				@x -= 8			
			else
				@x += 8
			end
			@y += 5
			rc = game.platformCollision(self.rect)
			if NSIsEmptyRect(rc)
				@x = @oldX
				@isLeftOriented = !@isLeftOriented
			end
			@y = @oldY		
			loopSprites(@isLeftOriented ? @@leftMoves : @@rightMoves)
		end
	end	
	
	def addDamage(amount)
		if @lives > 0
			@lives -= amount	
			@wasDamaged = true
			return true
		end
		return false		
	end
	
	def draw
		if @currentSprite 
			motionBlur		
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

