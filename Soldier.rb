# Soldier.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/17/10.
# For license see LICENSE.TXT.

require 'GameObject'

class Soldier < GameObject
	@@spritesLoaded = false
	
	def initialize(x, y)
		super(x, y)
		
		unless @@spritesLoaded
			@@leftMoves = []
			@@rightMoves = []	
		
			4.times do |i|
				@@leftMoves << Sprite.spriteWithName("lSolmov#{i+1}.png")
			end
			
			4.times do |i|
				@@rightMoves << Sprite.spriteWithName("rSolmov#{i+1}.png")
			end
		
			@@spritesLoaded = true
		end
		
		@currentSprite = @@leftMoves.first
		@isLeftOriented = true
	end
	
	def update(game)
		if @isLeftOriented
			@x -= 8			
		else
			@x += 8
		end
		@y += 5
		rc = game.platformCollision(self.rect)
		if NSIsEmptyRect(rc)
			@x = @oldX
			@isLeftOriented = !@isLeftOriented
		end
		@y = @oldY
		loopSprites(@isLeftOriented ? @@leftMoves : @@rightMoves)
	end	
end

