# AppController.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/28/10.
# For license see LICENSE.TXT.

module MacRubyGame
	class AppController
		attr_accessor :gameObjectPalette
		
		def createObject(imageName, displayName)
			{ "image" => NSImage.imageNamed(imageName), "name" => displayName }
		end
		
		def initialize
			@gameObjectPalette = []
			@gameObjectPalette << createObject("lcopweap.png", "Player")
			# enemies
			@gameObjectPalette << createObject("rSoldie1.png", "Soldier")
			@gameObjectPalette << createObject("rskull.png", "Skull")
			@gameObjectPalette << createObject("rdaemon01.png", "Daemon")			
			# platforms
			@gameObjectPalette << createObject("platform.png", "Platform")
			@gameObjectPalette << createObject("elevator.png", "Elevator")
			@gameObjectPalette << createObject("walkway5.png", "Left Walkway")
			@gameObjectPalette << createObject("walkway1.png", "Right Walkway")
		end
	end
end