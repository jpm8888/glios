//
//  FrameBuffer.h
//  GLKViewExample
//
//  Created by Psi Gem on 01/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Texture.h"

@interface FrameBuffer : NSObject

-(instancetype) initFrameBuffer :(Format) format :(int) width :(int) height :(BOOL) hasDepth;
-(void) setTexture :(Texture*) texture;
-(void) dispose;
-(void) bind;
-(void) unbind;
-(void) begin;
-(void) end;
-(void) end :(int) x :(int) y :(int) width :(int) height;
-(Texture*) getColorBufferTexture;
-(int) getHeight;
-(int) getWidth;

   
/** the framebuffer handle **/
@property int framebufferHandle;
    
/** the depthbuffer render object handle **/
@property int depthbufferHandle;

/** width **/
@property const int width;

/** height **/
 @property const int height;

/** depth **/
@property const BOOL hasDepth;

/** the frame buffers **/
//	private final static Map<Application, Array<FrameBuffer>> buffers = new HashMap<Application, Array<FrameBuffer>>();

/** the color buffer texture **/
@property Texture *colorTexture;

/** format **/
//	protected final Pixmap.Format format;

@property const Format format;

@end
