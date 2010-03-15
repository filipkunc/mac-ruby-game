//
//  Sprite.m
//  MacRubyGame
//
//  Created by Filip Kunc on 3/13/10.
//  For license see LICENSE.TXT.
//

#import "Sprite.h"

@implementation Sprite

@synthesize width, height;

+ (Sprite *)spriteWithName:(NSString *)name
{
	return [[[Sprite alloc] initWithName:name] autorelease];
}

- (id)initWithName:(NSString *)name
{
	self = [super init];
	if (self)
	{
		NSLog(@"loading %@", name);
		
		NSImage *image = [NSImage imageNamed:name];
		width = [image size].width;
		height = [image size].height;
		
		glEnable(GL_TEXTURE_RECTANGLE_ARB);
		glGenTextures(1, &textureID);
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, textureID);
		
		NSBitmapImageRep * bitmap = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
		
		glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, 4, 
					 [image size].width, [image size].height, 0,
					 GL_RGBA, GL_UNSIGNED_BYTE, [bitmap bitmapData]);
		
		glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	}
	return self;
}

- (void)dealloc
{
	glDeleteTextures(1, &textureID);
	[super dealloc];
}

- (void)drawAtX:(int)x y:(int)y
{
	glBindTexture(GL_TEXTURE_RECTANGLE_ARB, textureID);
	
	glBegin(GL_QUADS);
	
	glTexCoord2i(0, 0);
	glVertex2i(x, y);
	
	glTexCoord2i(width, 0);
	glVertex2i(x + width, y);
	
	glTexCoord2i(width, height);
	glVertex2i(x + width, y + height);
	
	glTexCoord2i(0, height);
	glVertex2i(x, y + height);
	
	glEnd();
}

@end
