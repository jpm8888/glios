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

-(instancetype) init :(Format) format :(int) width :(int) height :(BOOL) hasDepth : (int) scr_width: (int) scr_height;
//-(void) setTexture :(Texture*) texture;
-(void) bind;
-(void) unbind;
-(void) begin;
-(void) end;
-(void) end :(int) x :(int) y :(int) width :(int) height;
-(Texture*) getColorBufferTexture;
-(int) getHeight;
-(int) getWidth;
-(void) dispose;
-(GLuint) getFrameBufferHandle;
-(GLuint*) getFrameBufferHandleAdr;

@property int width, height;
@property GLuint defaultViewportWidth, defaultViewportHeight;
@property Texture *colorTexture;
@property const BOOL hasDepth;
@property const Format format;

@end
