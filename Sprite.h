//
//  Sprite.h
//  MacRubyGame
//
//  Created by Filip Kunc on 3/13/10.
//  For license see LICENSE.TXT.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>

@interface Sprite : NSObject
{
	uint textureID;	
	int width;
	int height;
}

@property (readonly, assign) int width;
@property (readonly, assign) int height;

+ (Sprite *)spriteWithName:(NSString *)name;
- (id)initWithName:(NSString *)name;
- (void)drawAtX:(int)x y:(int)y;

@end
