# Elevator.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/22/10.
# For license see LICENSE.TXT.

require 'GameObject'

module MacRubyGame
	class ElevatorPart < GameObject
		def initialize(x, y, sprite)
			super(x, y)
			@currentSprite = sprite # needed for width, and height
		end
	end

	class Elevator < GameObject
		@@sprite = nil
		
		def initialize(x, y, endX, endY)
			super(x, y)
			@@sprite ||= Sprite.spriteWithName "elevator.png"
			@currentSprite = @@sprite
			@parts = []
			@parts << ElevatorPart.new(@x, @y, @@sprite)
			@parts << ElevatorPart.new(endX.ceil, endY.ceil, @@sprite)
			@movingTowardsEnd = true
		end
		
		def setPosition(x, y)
			super(x, y)
			@parts[1].x += @x - @parts[0].x
			@parts[1].y += @y - @parts[0].y
			@parts[1].x = @parts[1].x.ceil
			@parts[1].y = @parts[1].y.ceil
			@parts[0].x = @x
			@parts[0].y = @y			
		end
		
		def draw(isVisible)
			super(isVisible)			
			glColor4f(1, 1, 1, 0.1)
			@parts.each do |part|
				@currentSprite.drawAtX part.x, y:part.y
			end
			glColor4f(1, 1, 1, 0.2)
			glDisable(GL_TEXTURE_RECTANGLE_ARB)			
			glBegin(GL_LINES)
			@parts.each do |part|
				glVertex2f(part.x + width / 2, part.y + height / 2)
			end
			glEnd()
			glEnable(GL_TEXTURE_RECTANGLE_ARB)
		end
		
		def moveGameObject(gameObject, speedX, speedY)
			if gameObject.isGroundCreature && !(gameObject.wasMovedByMovingPlatform)
				rc = gameObject.groundRect
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
				diffX = @parts[1].x - @x
				diffY = @parts[1].y - @y
			else
				diffX = @parts[0].x - @x
				diffY = @parts[0].y - @y
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
		
		def parts
			@parts
		end
	end
end