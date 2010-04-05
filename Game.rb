# Game.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/13/10.
# For license see LICENSE.TXT.

require 'set'

module MacRubyGame
	class Game
		attr_reader :pressedKeys, :gameObjects, :player, :width, :height
				
		def initialize
			@pressedKeys = Set.new
			@width = 100
			@height = 100
			reset
		end
		
		def resize(width, height)
			@width = width
			@height = height
			@player.x = @width / 2 - @player.width / 2
			@player.y = @height / 2 - @player.height / 2
			@player.x  = @player.x.ceil
			@player.y  = @player.y.ceil
			moveWorld(@player.x - @player.oldX, @player.y - @player.oldY)
			@player.oldX = @player.x
			@player.oldY = @player.y
			
			clearBlur(@gameObjects)
			clearBlur(@helperObjects)
			clearBlur(@fireObjects)			
		end
		
		def clearBlur(gameObjects)
			gameObjects.each do |gameObject|
				gameObject.blurX = gameObject.x
				gameObject.blurY = gameObject.y
			end
		end
		
		def reset
			@gameObjects = []
			@helperObjects = []
			@fireObjects = []
			@player = Player.new(580, 150)
			for i in 1..3
				walkway = Walkway.new(0, 200, true)
				walkway.x += i * walkway.width
				addGameObject walkway
			end
			
			addGameObject Platform.new(520, 270)
			
			for i in 1..2
				walkway = Walkway.new(0, 420, false)
				walkway.x += i * walkway.width
				addGameObject walkway
			end
			
			for i in 1..2
				walkway = Walkway.new(-330, 420, true)
				walkway.x += i * walkway.width
				addGameObject walkway
			end
			
			addGameObject Platform.new(380, 350)
			
			for i in 1..3
				soldier = Soldier.new(i * 80 - 20, 200)
				soldier.y -= soldier.height * 2
				addGameObject soldier
			end
			
			addGameObject Elevator.new(20, 460, 20, 140)
			
			resize(@width, @height)
		end
		
		def addGameObject(gameObject)
			@gameObjects << gameObject
			if gameObject.parts
				gameObject.parts.each do |part|
					@helperObjects << part
				end
			end
		end
		
		def addFire(fireObject)
			@fireObjects << fireObject
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
		
		def drawObjects(gameObjects)
			gameObjects.each do |gameObject|
				drawObject(gameObject)
			end
		end
		
		def drawSelection(gameObjects)
			gameObjects.each do |gameObject| 
				gameObject.drawSelection
			end
		end
		
		def draw
			glEnable(GL_TEXTURE_RECTANGLE_ARB)			
			
			drawObjects(@gameObjects)
			drawObjects(@fireObjects)
			@player.draw(true)
			
			glDisable(GL_TEXTURE_RECTANGLE_ARB)
			glColor4f(1, 1, 1, 1)
			glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)			
			drawSelection(@gameObjects)
			drawSelection(@helperObjects)			
			@player.drawSelection			
			glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
		end
		
		def processKeyChar(character, isKeyDown)
			if isKeyDown
				@pressedKeys.add(character)
			else
				@pressedKeys.delete(character)
			end
		end
		
		def moveObjects(offsetX, offsetY, gameObjects)
			gameObjects.each do |gameObject|
				gameObject.move(offsetX, offsetY)
			end
		end
		
		def moveWorld(offsetX, offsetY)
			moveObjects(offsetX, offsetY, @gameObjects)
			moveObjects(offsetX, offsetY, @fireObjects)
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
		
		def selectAllObjects(isSelected, gameObjects)
			gameObjects.each do |gameObject|
				gameObject.isSelected = isSelected
			end
		end
		
		def selectAll(isSelected = true)
			selectAllObjects(isSelected, @gameObjects)
			selectAllObjects(isSelected, @helperObjects)
			@player.isSelected = isSelected
		end
		
		def selectOneUnderMouseInObjects(location, gameObjects)
			gameObjects.each do |gameObject|
				if NSPointInRect(location, gameObject.rect)
					gameObject.isSelected = true
					return true
				end				
			end
			return false
		end
		
		def selectOneUnderMouse(location)
			return if selectOneUnderMouseInObjects(location, @gameObjects)
			return if selectOneUnderMouseInObjects(location, @helperObjects)
			if NSPointInRect(location, @player.rect)
				@player.isSelected = true
			end
		end
		
		def selectAllObjectsIntersectingRect(selectionRect, isSelected, gameObjects)
			gameObjects.each do |gameObject|
				gameObject.isSelected = isSelected if NSIntersectsRect(selectionRect, gameObject.rect)
			end
		end
		
		def selectAllIntersectingRect(selectionRect, isSelected = true)
			selectAllObjectsIntersectingRect(selectionRect, isSelected, @gameObjects)
			selectAllObjectsIntersectingRect(selectionRect, isSelected, @helperObjects)
			@player.isSelected = isSelected if NSIntersectsRect(selectionRect, player.rect)
		end
		
		def isSelectedUnderMouseInObjects(location, gameObjects)
			gameObjects.each do |gameObject|
				return true if gameObject.isSelected && NSPointInRect(location, gameObject.rect)
			end
			return false
		end
		
		def isSelectedUnderMouse(location)
			return true if isSelectedUnderMouseInObjects(location, @gameObjects)
			return true if isSelectedUnderMouseInObjects(location, @helperObjects)
			return false
		end
		
		def moveSelectedObjects(offsetX, offsetY, gameObjects)
			gameObjects.each do |gameObject|
				gameObject.move(offsetX, offsetY) if gameObject.isSelected
			end			
		end
		
		def moveSelected(offsetX, offsetY)
			moveSelectedObjects(offsetX, offsetY, @gameObjects)
			moveSelectedObjects(offsetX, offsetY, @helperObjects)
		end
	end
end