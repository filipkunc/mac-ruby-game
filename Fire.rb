# Fire.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/20/10.
# For license see LICENSE.TXT.

require 'GameObject'

module MacRubyGame
	class Fire < GameObject
		@@sprite = nil
		
		def initialize(x, y, dirX, dirY)
			super(x, y)
			@@sprite ||= Sprite.spriteWithName "fire.png"
			@currentSprite = @@sprite
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
end
