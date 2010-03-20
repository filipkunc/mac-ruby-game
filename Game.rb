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
		@fireObjects = []
		@player = Player.new(400, 140)
		@gameObjects.addObject Platform.new(50, 200)		
		@gameObjects.addObject Platform.new(220, 200)
		@gameObjects.addObject Platform.new(420, 260)
		soldier = Soldier.new(80, 200)
		soldier.y -= soldier.height
		@gameObjects.addObject soldier
		
		@player.x = @width / 2 - @player.width / 2;
		@player.y = @height / 2 - @player.height / 2;
		moveWorld(@player.x - @player.oldX, @player.y - @player.oldY)
		@player.oldX = @player.x
		@player.oldY = @player.y
		
		@gameObjects.each do |gameObject|
			gameObject.blurX = gameObject.x
			gameObject.blurY = gameObject.y
		end
	end
	
	def addFire(fireObject)
		@fireObjects.addObject(fireObject)
	end

	def update
		@gameObjects.each do |gameObject|
			gameObject.update(self)
		end
		@fireObjects.each do |fireObject|
			fireObject.update(self)
			unless NSIntersectsRect(fireObject.rect, self.rect) 
				@fireObjects.removeObject(fireObject)
			else
				@gameObjects.each do |gameObject|
					if NSIntersectsRect(gameObject.rect, fireObject.rect) 
						@fireObjects.removeObject(fireObject) if gameObject.addDamage(fireObject.damage)	
						break
					end
				end
			end
		end
		@player.update(self)
	end
	
	def drawObject(gameObject)
		gameObject.draw if NSIntersectsRect(gameObject.rect, self.rect)
	end
	
	def draw
		@gameObjects.each do |gameObject|
			drawObject(gameObject)
		end
		@fireObjects.each do |fireObject|
			drawObject(fireObject)
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
			if gameObject.isPlatform
				rect = NSIntersectionRect(gameObject.rect, playerRect)
				return rect unless NSIsEmptyRect(rect)			
			end
		end
		return NSZeroRect
	end
	
	def rect
		NSMakeRect(0, 0, @width, @height)
	end
end
