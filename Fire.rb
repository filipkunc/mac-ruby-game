# Fire.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/20/10.
# For license see LICENSE.TXT.

require 'GameObject'

class Fire < GameObject
	@@spritesLoaded = false
	
	def initialize(x, y, dirX, dirY)
		super(x, y)
		
		unless @@spritesLoaded
			@@fire = Sprite.spriteWithName "fire.png"
		
			@@spritesLoaded = true
		end
		
		@currentSprite = @@fire
		@dirX = dirX
		@dirY = dirY
	end
	
	def update(game)
		super(game)
		
		@x += @dirX
		@y += @dirY
	end	
	
	def damage
		1
	end
end



