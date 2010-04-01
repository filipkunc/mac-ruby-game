# GameObject.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/13/10.
# For license see LICENSE.TXT.

module MacRubyGame
	class GameObject
		attr_accessor :x, :y, :blurX, :blurY, :oldX, :oldY, :wasMovedByMovingPlatform, :isSelected
		
		def initialize(x, y)		
			@currentSprite = nil
			@oldSprite = nil
			setPosition(x, y)
			@wasMovedByMovingPlatform = false
			@isSelected = false
		end
		
		def setPosition(x, y)
			@x = x.ceil
			@y = y.ceil
			@blurX = @x
			@blurY = @y
			@oldX = @x
			@oldY = @y
		end
			
		def update(game)
			@oldSprite = @currentSprite
			@oldX = @x
			@oldY = @y
		end	
		
		def drawBlur(stepX, stepY, stepCount)
			stepX /= stepCount
			stepY /= stepCount		
			alphaStep = 0.001
			alpha = alphaStep
			x = @blurX
			y = @blurY		
			for i in (1..stepCount)
				glColor4f(1, 1, 1, alpha)
				if i < stepCount / 2 && @oldSprite
					@oldSprite.drawAtX x, y:y
				else
					@currentSprite.drawAtX x, y:y
				end
				x += stepX
				y += stepY
				alpha += alphaStep
			end		
		end
		
		def motionBlur(isVisible)
			stepX = @x - @blurX
			stepY = @y - @blurY
			stepCount = Math.max(stepX.abs, stepY.abs)
			stepCount = Math.max(stepCount.ceil, 1)
			drawBlur(stepX, stepY, stepCount) if isVisible
			@blurX += stepX * 0.75
			@blurY += stepY * 0.75
		end
		
		def collidesWithFire
			true
		end
		
		def addDamage(amount)
			
		end
		
		def draw(isVisible = true)
			if @currentSprite 
				motionBlur(isVisible)
				if isVisible
					glColor4f(1, 1, 1, 1)
					@currentSprite.drawAtX @x, y:@y
				end
			end
		end
		
		def drawSelection
			if @isSelected
				glRecti(@x, @y, @x + width, @y + height)				
			end
		end
		
		def loopSprites(sprites, playForward = true, playOnce = false)
			currentIndex = sprites.index(@currentSprite)
			if currentIndex
				@currentSprite = sprites[currentIndex + (playForward ? 1 : -1)]
				@currentSprite = playOnce ? sprites.last : sprites.first unless @currentSprite			
			else
				@currentSprite = sprites.first
			end
		end
			
		def width
			if @currentSprite
				@currentSprite.width
			else
				0
			end
		end
		
		def height
			if @currentSprite
				@currentSprite.height
			else
				0
			end
		end
		
		def rect
			NSMakeRect(@x, @y, width, height)		
		end
		
		def isPlatform
			false
		end
		
		def isGroundCreature
			false
		end
		
		def move(offsetX, offsetY)
			@x += offsetX
			@y += offsetY
		end
	end
end