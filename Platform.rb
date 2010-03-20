# GameClasses.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/13/10.
# For license see LICENSE.TXT.

require 'GameObject'

class Platform < GameObject
	@@sprite = nil

	def initialize(x, y)
		super(x, y)
				
		@@sprite = Sprite.spriteWithName "platform.png" unless @@sprite
		@currentSprite = @@sprite
	end
	
	def isPlatform
		true
	end
end




