# Game.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/13/10.
# For license see LICENSE.TXT.

require 'set'

class Game
	attr_reader :pressedKeys, :gameObjects, :player
	
	def initialize
		@pressedKeys = Set.new
		@width = 100
		@height = 100
		reset
	end
	
	def resize(width, height)
		@width = width
		@height = height
		@player.x = @width / 2 - @player.width / 2;
		@player.y = @height / 2 - @player.height / 2;
		moveWorld(@player.x - @player.oldX, @player.y - @player.oldY)
		@player.oldX = @player.x
		@player.oldY = @player.y
		
		@gameObjects.each do |gameObject|
			gameObject.blurX = gameObject.x
			gameObject.blurY = gameObject.y
		end
		
		@fireObjects.each do |fireObject|
			fireObject.blurX = fireObject.x
			fireObject.blurY = fireObject.y
		end
	end
	
	def reset
		@gameObjects = []
		@fireObjects = []
		@player = Player.new(580, 150)
		for i in 1..3
			walkway = Walkway.new(0, 200, true)
			walkway.x += i * walkway.width
			@gameObjects.addObject walkway
		end
		
		@gameObjects.addObject Platform.new(520, 250)
		
		for i in 1..2
			walkway = Walkway.new(0, 420, false)
			walkway.x += i * walkway.width
			@gameObjects.addObject walkway
		end
		
		for i in 1..2
			walkway = Walkway.new(-330, 420, true)
			walkway.x += i * walkway.width
			@gameObjects.addObject walkway
		end
		
		@gameObjects.addObject Platform.new(380, 350)
		
		for i in 1..3
			soldier = Soldier.new(i * 80 - 20, 200)
			soldier.y -= soldier.height * 2
			@gameObjects.addObject soldier
		end
		
		@gameObjects.addObject Elevator.new(20, 460, 20, 140)
		
		resize(@width, @height)
	end
	
	def addFire(fireObject)
		@fireObjects.addObject(fireObject)
	end
	
	def update
		reset if pressedKeys.include?('r'.ord)
	
		@gameObjects.each do |gameObject|
			gameObject.wasMovedByMovingPlatform = false
		end
		@player.wasMovedByMovingPlatform = false
		@gameObjects.each do |gameObject|
			gameObject.update(self)
		end
		@fireObjects.each do |fireObject|
			fireRect = fireObject.rect
			fireObject.update(self)
			unless NSIntersectsRect(fireObject.rect, self.rect) 
				@fireObjects.removeObject(fireObject)
			else
				@gameObjects.each do |gameObject|
					if gameObject.collidesWithFire
						fireRect = NSUnionRect(fireRect, fireObject.rect)
						if NSIntersectsRect(gameObject.rect, fireRect) 
							gameObject.addDamage(fireObject.damage)
							@fireObjects.removeObject(fireObject) 
							break
						end
					end
				end
			end
		end
		@player.update(self)
	end
	
	def drawObject(gameObject)
		gameObject.draw NSIntersectsRect(gameObject.rect, self.rect)
	end
	
	def draw
		@gameObjects.each do |gameObject|
			drawObject(gameObject)
		end
		@fireObjects.each do |fireObject|
			drawObject(fireObject)
		end
		@player.draw(true)
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
			gameObject.moveWorld(offsetX, offsetY)
		end		
		@fireObjects.each do |fireObject|
			fireObject.moveWorld(offsetX, offsetY)
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
