# Game.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/13/10.
# For license see LICENSE.TXT.

require 'set'

class Game
	attr_accessor :width, :height
	attr_reader :pressedKeys
	
	def initialize
		@pressedKeys = Set.new
		@width = 0
		@height = 0
		
		@gameObjects = []
		@fireObjects = []
		
		@player = Player.new(400, 140)		
	end
	
	def reset
		@gameObjects = []
		@player = Player.new(400, 140)
		@gameObjects.addObject Platform.new(50, 200)		
		@gameObjects.addObject Platform.new(220, 200)
		@gameObjects.addObject Platform.new(420, 260)		
		
		@player.x = @width / 2 - @player.width / 2;
		@player.y = @height / 2 - @player.height / 2;
		moveWorld(@player.x - @player.old_x, @player.y - @player.old_y)
		@player.old_x = @player.x
		@player.old_y = @player.y
	end

	def update
		@gameObjects.each do |gameObject|
			gameObject.update(self)
		end
		@player.update(self)
	end
	
	def draw
		@gameObjects.each do |gameObject|
			gameObject.draw
		end		
		@player.draw
	end
	
	def processKeyChar(character, isKeyDown)
		if isKeyDown
			@pressedKeys.add(character)
		else
			@pressedKeys.delete(character)
		end
	end
	
	def moveWorld(offsetX, offsetY)
		@gameObjects.each do |gameObject|
			gameObject.x += offsetX
			gameObject.y += offsetY
		end
		
		@fireObjects.each do |fireObject|
			fireObject.x += offsetX
			fireObject.y += offsetY
		end
	end
	
	def platformCollision(playerRect)
		@gameObjects.each do |gameObject|
			rect = NSIntersectionRect(gameObject.rect, playerRect)
			unless NSIsEmptyRect(rect)			
				return rect
			end
		end
		return NSZeroRect
	end
end
