# GameView.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/10/10.
# For license see LICENSE.TXT.

require 'Game'

module MacRubyGame
	class GameView < NSOpenGLView
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
			return self
		end
		
		def timerMethod
			@game.update
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
	end
end