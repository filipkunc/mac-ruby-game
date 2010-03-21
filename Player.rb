# Player.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/14/10.
# For license see LICENSE.TXT.

class Player < GameObject
	attr_accessor :centerX, :centerY

	@@spritesLoaded = false

	def initialize(x, y)
		super(x, y)
		
		unless @@spritesLoaded
			@@leftMoves = []
			@@rightMoves = []	
		
			for i in 1..4
				@@leftMoves << Sprite.spriteWithName("lcopmov#{i}weap.png")
			end
			
			for i in 1..4
				@@rightMoves << Sprite.spriteWithName("rcopmov#{i}weap.png")
			end
			
			@@leftStand = Sprite.spriteWithName "lcopweap.png"
			@@rightStand = Sprite.spriteWithName "rcopweap.png"
			
			@@leftJump = Sprite.spriteWithName "lcopjumpweap.png"
			@@rightJump = Sprite.spriteWithName "rcopjumpweap.png"
			
			@@fire = Sprite.spriteWithName "fire.png"
			
			@@spritesLoaded = true
		end
		
		@isLeftOriented = true
		@currentSprite = @@leftStand
		@initialUpSpeed = 18
		@upSpeed = @initialUpSpeed
		@isJumping = false
		@isMoving = false
		
		@fires = []
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
	
	def moveUpdate(game)
		speed = 9		
		if game.pressedKeys.include?(NSLeftArrowFunctionKey)
			@isLeftOriented = true
			@isMoving = true
			@x -= speed
		elsif game.pressedKeys.include?(NSRightArrowFunctionKey)
			@isLeftOriented = false
			@isMoving = true
			@x += speed
		else
			@isMoving = false
		end
	end
	
	def jumpUpdate(game)
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
	end
	
	def fireUpdate(game)
		@fireCounter ||= 0
		@fireCounter += 1
		if (@fireCounter > 2)
			if (game.pressedKeys.include?(32)) # can't find any 'virtual code' for space 
				game.addFire(Fire.new(@isLeftOriented ? @x - 8 : @x + width, @y + 18, @isLeftOriented ? -30 : 30, 0))
				@fireCounter = 0
			end			
		end
	end
	
	def moveWorld(game)
		diffX = @oldX - @x
		diffY = @oldY - @y
		game.moveWorld(diffX, diffY)
		@x = @oldX
		@y = @oldY
	end
	
	def finalUpdate(game)
		updateCurrentSprite		
		moveWorld(game)
	end
	
	def update(game)
		super(game)
		moveUpdate(game)
		jumpUpdate(game)
		fireUpdate(game)
		finalUpdate(game)
	end
	
	def isGroundCreature
		true
	end
end
