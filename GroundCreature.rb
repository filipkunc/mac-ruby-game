# GroundCreature.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/30/10.
# For license see LICENSE.TXT.

require 'GameObject'

module MacRubyGame
	class GroundCreature < GameObject
			def initialize(x, y)
			super(x, y)
			@initialUpSpeed = 18
			@upSpeed = @initialUpSpeed
			@isJumping = false
		end
	
		def stopJumpIfNeeded(rc)
			unless NSIsEmptyRect(rc)
				@y -= rc.size.height 
				@upSpeed = @initialUpSpeed
				@isJumping = false				
			end
		end	
		
		def jumpUpdate(game, ignorePressedKeys = true)
			upArrowPressed = !ignorePressedKeys && game.pressedKeys.include?(NSUpArrowFunctionKey)
			if @upSpeed > 0 && !@isJumping && upArrowPressed
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
				rc = game.platformCollision(groundRect)
				if NSIsEmptyRect(rc)
					@y -= @upSpeed
					@upSpeed -= 3 if @upSpeed > -@initialUpSpeed
					rc = game.platformCollision(groundRect)
				end
				stopJumpIfNeeded(rc)
			end
		end
		
		def groundRect
			NSMakeRect(@x + width / 2 - 5, @y + height - 12, 12, 12)			
		end
		
		def isGroundCreature
			true
		end
	end
end
