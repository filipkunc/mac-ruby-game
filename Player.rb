# Player.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/14/10.
# For license see LICENSE.TXT.

require 'GroundCreature'

module MacRubyGame
	class Player < GroundCreature
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
			@isMoving = false			
			@fires = []
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
		
		def draw(isVisible)
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
		
		def fireUpdate(game)
			@fireCounter ||= 0
			@fireCounter += 1
			if @fireCounter > 2
				if game.pressedKeys.include?(' '.ord)
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
			jumpUpdate(game, false)
			fireUpdate(game)
			finalUpdate(game)
		end
	end
end