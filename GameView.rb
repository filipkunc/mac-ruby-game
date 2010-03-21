# GameView.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/10/10.
# For license see LICENSE.TXT.

class GameView < NSOpenGLView
	def initWithCoder(coder)
		super
		
		@timer = NSTimer.scheduledTimerWithTimeInterval 0.05,
			target:self,
			selector:'timerMethod',
			userInfo:nil,
			repeats:true		
			
		self.openGLContext.makeCurrentContext
		
		glClearColor(0.3, 0.4, 0.4, 1.0)
		glEnable(GL_TEXTURE_2D)
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
		
		baseRect = self.convertRectToBase(self.bounds)
		
		glViewport(0, 0, baseRect.size.width, baseRect.size.height)
		
		glMatrixMode(GL_PROJECTION)
		glLoadIdentity()
		gluOrtho2D(0, baseRect.size.width, 0, baseRect.size.height)
		
		glMatrixMode(GL_MODELVIEW)
		glLoadIdentity()
		
		glTranslatef(0, baseRect.size.height, 0)
		glScalef(1, -1, 1)		

		@game.width = baseRect.size.width
		@game.height = baseRect.size.height
		@game.reset
	
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