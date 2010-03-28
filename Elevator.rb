# Elevator.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/22/10.
# For license see LICENSE.TXT.

require 'GameObject'

module MacRubyGame
	class Elevator < GameObject
		@@sprite = nil
		
		def initialize(x, y, endX, endY)
			super(x, y)
			@@sprite ||= Sprite.spriteWithName "elevator.png"
			@currentSprite = @@sprite
			@startX = @x
			@startY = @y
			@endX = endX.ceil
			@endY = endY.ceil
			@movingTowardsEnd = true
		end
		
		def moveGameObject(gameObject, speedX, speedY)
			if gameObject.isGroundCreature && !(gameObject.wasMovedByMovingPlatform)
				rc = gameObject.rect
				rc.origin.y += 2
				if NSIntersectsRect(rc, self.rect)
					gameObject.x += speedX
					gameObject.y += speedY
					gameObject.wasMovedByMovingPlatform = true
				end
			end
		end
		
		def update(game)
			if @movingTowardsEnd
				diffX = @endX - @x
				diffY = @endY - @y
			else
				diffX = @startX - @x
				diffY = @startY - @y
			end
			
			speed = 7
			diffX = Math.absmin(diffX, speed)
			diffY = Math.absmin(diffY, speed)
			
			if diffX == 0 && diffY == 0
				@movingTowardsEnd = !@movingTowardsEnd
			end		
			
			game.gameObjects.each do |gameObject|
				moveGameObject(gameObject, diffX, diffY)
			end
			
			moveGameObject(game.player, diffX, diffY)
			game.player.moveWorld(game)
			
			@x += diffX
			@y += diffY		
		end
		
		def isPlatform
			true
		end
		
		def moveWorld(offsetX, offsetY)
			super(offsetX, offsetY)
			@startX += offsetX
			@startY += offsetY
			@endX += offsetX
			@endY += offsetY
		end
	end
end