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
		@initialUpSpeed = 18
		@upSpeed = -1
		@falling = false
	end
	
	def stopJumpIfNeeded(rc)
		unless NSIsEmptyRect(rc)
			@y -= rc.size.height 
			@upSpeed = -1			
			@falling = false			
		else
			@falling = true
		end		
	end
	
	def update(game)
		super(game)
		
		if @lives <= 0
			loopSprites(@isLeftOriented ? @@leftDie : @@rightDie, true, true)
			rc = game.platformCollision(self.rect)
			if NSIsEmptyRect(rc)
				@y -= @upSpeed
				@upSpeed -= 3 if @upSpeed > -@initialUpSpeed
				@falling = true				
				rc = game.platformCollision(self.rect)
			end
			stopJumpIfNeeded(rc)
		else
			if @isLeftOriented
				@x -= 8			
			else
				@x += 8
			end
			@y += 2
			rc = game.platformCollision(self.rect)
			if NSIsEmptyRect(rc)
				@x = @oldX
				@isLeftOriented = !@isLeftOriented unless @falling
				@y -= @upSpeed
				@upSpeed -= 3 if @upSpeed > -@initialUpSpeed
				rc = game.platformCollision(self.rect)
			end			
			stopJumpIfNeeded(rc)
			loopSprites(@isLeftOriented ? @@leftMoves : @@rightMoves)
		end
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
	
	def isGroundCreature
		true
	end
end

