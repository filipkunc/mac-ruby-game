# AppController.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/28/10.
# For license see LICENSE.TXT.

module MacRubyGame
	class AppController
		attr_accessor :gameObjectPalette, :selectedMode
		
		def createPaletteObject(imageName, displayName, block)
			{ "image" => NSImage.imageNamed(imageName), "name" => displayName, "block" => block }
		end
		
		def createGameObjectByName(displayName)
			@gameObjectLookup[displayName].call
		end
		
		def initialize
			@gameObjectPalette = []
			@gameObjectPalette << createPaletteObject("lcopweap.png", "Player", ->(){ Player.new(0, 0) })
			# enemies
			@gameObjectPalette << createPaletteObject("rSoldie1.png", "Soldier", ->(){ Soldier.new(0, 0) })
			#@gameObjectPalette << createPaletteObject("rskull.png", "Skull")
			#@gameObjectPalette << createPaletteObject("rdaemon01.png", "Daemon")			
			# platforms
			@gameObjectPalette << createPaletteObject("platform.png", "Platform", ->(){ Platform.new(0, 0) })
			@gameObjectPalette << createPaletteObject("elevator.png", "Elevator", ->(){ Elevator.new(0, 0, 0, -100) } )
			@gameObjectPalette << createPaletteObject("walkway5.png", "Left Walkway", ->(){ Walkway.new(0, 0, true) } )
			@gameObjectPalette << createPaletteObject("walkway1.png", "Right Walkway", ->(){ Walkway.new(0, 0, false) })
			
			@gameObjectLookup = {}
			@gameObjectPalette.each do |paletteObject|
				@gameObjectLookup[paletteObject["name"]] = paletteObject["block"]
			end
			
			@selectedMode = "Game"
		end
		
		def collectionView(view, writeItemsAtIndexes:indexes, toPasteboard:pasteboard)
			types = []
			NSStringPboardType
			types << NSStringPboardType
			pasteboard.declareTypes(types, owner:self)
			pasteboard.setString(@gameObjectPalette[indexes.firstIndex]["name"], forType:types.first)
			true
		end
		
		def collectionView(view, draggingImageForItemsAtIndexes:indexes, withEvent:event, offset:dragImageOffset)
			@gameObjectPalette[indexes.firstIndex]["image"]
		end		
	end
end