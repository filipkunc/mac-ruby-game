# GameObject.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/13/10.
# For license see LICENSE.TXT.

class GameObject
	attr_accessor :x, :y, :old_x, :old_y
	
	def initialize(x, y)		
		@currentSprite = nil
		@oldSprite = nil
		@x = x
		@y = y
		@old_x = @x
		@old_y = @y
	end
		
	def update(game)
		@oldSprite = @currentSprite
		@old_x = @x
		@old_y = @y
	end
	
	def motionBlur
		stepCount = 6
		alpha = 0.01
		step_x = @x - @old_x
		step_y = @y - @old_y
		step_x /= stepCount
		step_y /= stepCount
		for i in (1..stepCount)
			glColor4f(1, 1, 1, alpha)
			if i < stepCount / 2 && @oldSprite
				@oldSprite.drawAtX @old_x, y:@old_y
			else
				@currentSprite.drawAtX @old_x, y:@old_y
			end
			@old_x += step_x
			@old_y += step_y
			alpha += 0.01
		end
		@old_x = @x
		@old_y = @y
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
end
