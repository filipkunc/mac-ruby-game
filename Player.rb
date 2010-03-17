# Player.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/14/10.
# For license see LICENSE.TXT.

class Player < GameObject
	@@spritesLoaded = false

	def initialize(x, y)
		super(x, y)
		
		unless @@spritesLoaded
			@@leftMoves = []
			@@rightMoves = []	
		
			4.times do |i|
				@@leftMoves << Sprite.spriteWithName("lcopmov#{i+1}weap.png")
			end
			
			4.times do |i|
				@@rightMoves << Sprite.spriteWithName("rcopmov#{i+1}weap.png")
			end
			
			@@leftStand = Sprite.spriteWithName "lcopweap.png"
			@@rightStand = Sprite.spriteWithName "rcopweap.png"
			
			@@leftJump = Sprite.spriteWithName "lcopjumpweap.png"
			@@rightJump = Sprite.spriteWithName "rcopjumpweap.png"
			
			@@spritesLoaded = true
		end
		
		@isLeftOriented = true
		@currentSprite = @@leftStand
		@initialUpSpeed = 18
		@upSpeed = @initialUpSpeed
		@isJumping = false
		@isMoving = false
	end
	
	def stopJumpIfNeeded(rc)
		unless NSIsEmptyRect(rc)
			@y -= rc.size.height 
			@upSpeed = @initialUpSpeed
			@isJumping = false
		end
	end
	
	def updateCurrentSprite
		if @isJumping
			@currentSprite = @isLeftOriented ? @@leftJump : @@rightJump
		elsif @isMoving
			loopSprites(@isLeftOriented ? @@leftMoves : @@rightMoves)
		else
			@currentSprite = @isLeftOriented ? @@leftStand : @@rightStand
		end
	end
	
	def draw
		glColor4f(1, 1, 1, 1)
		@currentSprite.drawAtX @x, y:@y
	end
	
	def update(game)
		super(game)
		if game.pressedKeys.include?(NSLeftArrowFunctionKey)
			@isLeftOriented = true
			@isMoving = true
			@x -= 10
		elsif game.pressedKeys.include?(NSRightArrowFunctionKey)
			@isLeftOriented = false
			@isMoving = true
			@x += 10
		else
			@isMoving = false
		end
		if @upSpeed > 0 && !@isJumping && game.pressedKeys.include?(NSUpArrowFunctionKey)
			@isJumping = true
			@y -= @upSpeed
			@upSpeed -= 2
		elsif @upSpeed > 0 && @jumping
			@y -= @upSpeed
			@upSpeed -= 2
		else		
			unless @isJumping
				@isJumping = true
				@upSpeed = -1
			end
			rc = game.platformCollision(self.rect)
			if NSIsEmptyRect(rc)
				@y -= @upSpeed
				@upSpeed -= 3 if @upSpeed > -@initialUpSpeed
				rc = game.platformCollision(self.rect)
			end
			stopJumpIfNeeded(rc)			
		end
		updateCurrentSprite		
		diffX = @oldX - @x
		diffY = @oldY - @y
		game.moveWorld(diffX, diffY)
		@x = @oldX
		@y = @oldY
	end
end
