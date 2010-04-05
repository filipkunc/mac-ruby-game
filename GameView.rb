# GameView.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/10/10.
# For license see LICENSE.TXT.

require 'Game'

module MacRubyGame
	class GameView < NSOpenGLView
		attr_accessor :gameObjectFactory
	
		def initWithCoder(coder)
			super
			
			@timer = NSTimer.scheduledTimerWithTimeInterval 0.05,
				target:self,
				selector:'timerMethod',
				userInfo:nil,
				repeats:true		
					
			self.setupSharedContext
			
			glClearColor(0.3, 0.4, 0.4, 1.0)
			glEnable(GL_TEXTURE_RECTANGLE_ARB)
			glEnable(GL_BLEND)
			glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
			
			@game = Game.new
			
			draggedTypes = []
			draggedTypes << NSStringPboardType
			self.registerForDraggedTypes(draggedTypes)
			
			@startSelection = @endSelection = NSZeroPoint
			@draggingSelection = false
			@draggingObjects = false
			
			return self
		end
		
		def timerMethod
			if @gameObjectFactory.selectedMode == "Game"
				@game.update
			end
			self.needsDisplay = true
		end

		def reshape
			self.openGLContext.makeCurrentContext
			size = self.reshapeFlippedOrtho2D
			@game.resize(size.width, size.height)
			self.needsDisplay = true
		end
			
		def drawRect(rect)
			glClear(GL_COLOR_BUFFER_BIT)
			@game.draw
			if @draggingSelection
				glColor4f(1, 1, 1, 0.1)
				glRecti(@startSelection.x, @startSelection.y, @endSelection.x, @endSelection.y)
				glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
				glColor4f(1, 1, 1, 0.5)
				glRecti(@startSelection.x, @startSelection.y, @endSelection.x, @endSelection.y)
				glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
			end
			self.openGLContext.flushBuffer
		end
		
		def acceptsFirstResponder
			true
		end
		
		def processKeyChar(event, isKeyDown)
			characters = event.characters
			if characters.length == 1 && !event.isARepeat
				character = characters.characterAtIndex(0)
				@game.processKeyChar(character, isKeyDown)
			end
		end
		
		def keyDown(event)
			processKeyChar(event, true)
		end
		
		def keyUp(event)
			processKeyChar(event, false)
		end
		
		def draggingEntered(sender)
			if sender.draggingSource == self
				NSDragOperationNone
			else
				NSDragOperationCopy
			end
		end
		
		def draggingExited(sender)
			
		end
		
		def prepareForDragOperation(sender)
			true
		end
		
		def performDragOperation(sender)
			@draggedObject = nil
			
			if sender.draggingPasteboard.types.include?(NSStringPboardType)
				name = sender.draggingPasteboard.stringForType(NSStringPboardType)
				@draggedObject = @gameObjectFactory.createGameObjectByName(name)
			end
			
			return @draggedObject != nil				
		end
		
		
		def concludeDragOperation(sender)
			point = self.convertPoint(sender.draggedImageLocation, fromView:nil)
			point.y = @game.height - point.y

			gameObject = @draggedObject
			gameObject.setPosition(point.x, point.y - gameObject.height)
		
			if gameObject.is_a?(Player)
				@game.moveWorld(@game.player.x - gameObject.x, @game.player.y - gameObject.y)
			else
				@game.addGameObject gameObject
			end
		end
		
		def mouseDown(event)
			@draggingObjects = @draggingSelection = false
			@endSelection = self.flippedNSPoint(self.locationFromNSEvent(event))
			if @game.isSelectedUnderMouse(@endSelection)
				@draggingObjects = true
			else
				@startSelection = @endSelection
				@draggingSelection = true
				
			end
			self.needsDisplay = true
		end
		
		def mouseDragged(event)
			location = self.flippedNSPoint(self.locationFromNSEvent(event))
			if @draggingObjects
				@game.moveSelected(location.x - @endSelection.x, location.y - @endSelection.y)			
			end
			@endSelection = location
			self.needsDisplay = true
		end
		
		def mouseUp(event)
			unless @draggingObjects
				@game.selectAll(false)
				if @draggingSelection
					if NSIsEmptyRect(selectionRect)
						point = self.flippedNSPoint(self.locationFromNSEvent(event))
						@game.selectOneUnderMouse(point)
					else
						@game.selectAllIntersectingRect(selectionRect)
					end
					@draggingObjects = @draggingSelection = false
				end
			end			
			self.needsDisplay = true
		end
		
		def selectionRect
			minX = Math.min(@startSelection.x, @endSelection.x)
			maxX = Math.max(@startSelection.x, @endSelection.x)
			minY = Math.min(@startSelection.y, @endSelection.y)
			maxY = Math.max(@startSelection.y, @endSelection.y)
			return NSMakeRect(minX, minY, maxX - minX, maxY - minY)
		end
	end
end