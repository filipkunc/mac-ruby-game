//
//  NSOpenGLView+Helpers.m
//  MacRubyGame
//
//  Created by Filip Kunc on 3/25/10.
//  For license see LICENSE.TXT.
//

#import "NSOpenGLView+Helpers.h"

NSOpenGLPixelFormat *globalPixelFormat = nil;
NSOpenGLContext *globalGLContext = nil;

@implementation NSOpenGLView(Helpers)

+ (NSOpenGLPixelFormat *)sharedPixelFormat
{
	if (!globalPixelFormat)
	{
		NSOpenGLPixelFormatAttribute attribs[] = 
		{
			NSOpenGLPFAAccelerated,
			NSOpenGLPFADoubleBuffer,
			NSOpenGLPFAColorSize, 1,
			NSOpenGLPFADepthSize, 1,
			0 
		};
		
		globalPixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribs];
	}
	return globalPixelFormat;
}

+ (NSOpenGLContext *)sharedContext
{
	if (!globalGLContext)
	{
		globalGLContext = [[NSOpenGLContext alloc] initWithFormat:[NSOpenGLView sharedPixelFormat]
													 shareContext:nil];
	}
	return globalGLContext;
}

- (void)setupSharedContext
{
	[self clearGLContext];
	NSOpenGLContext *context = [[NSOpenGLContext alloc] initWithFormat:[NSOpenGLView sharedPixelFormat]
														  shareContext:[NSOpenGLView sharedContext]];
	[self setOpenGLContext:context];
	[context release];
	[[self openGLContext] makeCurrentContext];
}

- (NSSize)reshapeFlippedOrtho2D
{
	NSRect baseRect = [self convertRectToBase:[self bounds]];
	
	glViewport(0, 0, baseRect.size.width, baseRect.size.height);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D(0, baseRect.size.width, 0, baseRect.size.height);
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glTranslatef(0, baseRect.size.height, 0);
	glScalef(1, -1, 1);
	
	return baseRect.size;
}

@end
