# GameObject.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/13/10.
# For license see LICENSE.TXT.

class GameObject
	attr_accessor :x, :y, :blurX, :blurY, :oldX, :oldY
	
	def initialize(x, y)		
		@currentSprite = nil
		@oldSprite = nil
		@x = x
		@y = y
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
	
	def motionBlur
		stepX = @x - @blurX
		stepY = @y - @blurY
		stepCount = Math.max(stepX.abs, stepY.abs)
		stepCount = Math.max(stepCount.ceil, 1)
		alphaStep = 0.001
		alpha = alphaStep
		stepX /= stepCount
		stepY /= stepCount
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
		@blurX += stepX * stepCount * 0.75
		@blurY += stepY * stepCount * 0.75
		@oldX = @x
		@oldY = @y		
	end
	
	def addDamage(amount)
		true
	end
	
	def draw
		if @currentSprite 
			motionBlur		
			glColor4f(1, 1, 1, 1)
			@currentSprite.drawAtX @x, y:@y
		end
	end
		
	def loopSprites(sprites)
		currentIndex = sprites.index(@currentSprite)
		if currentIndex
			@currentSprite = sprites[currentIndex + 1]
			@currentSprite = sprites.first unless @currentSprite
		else
			@currentSprite = sprites.first
		end
	end
	
	def playSprites(sprites)
		currentIndex = sprites.index(@currentSprite)
		if currentIndex
			@currentSprite = sprites[currentIndex + 1]
			@currentSprite = sprites.last unless @currentSprite
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
end
