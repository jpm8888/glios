//
//  FakeScreen.m
//  glios
//
//  Created by Jitu JPM on 4/20/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "FakeScreen.h"
#import "FrameBuffer.h"
#import "Texture.h"

@implementation FakeScreen{
    FrameBuffer *framebuffer;
}

-(void) render : (float) viewX : (float) viewY{
    framebuffer = [[FrameBuffer alloc] init:RGBA :512 :512 :NO : viewX : viewY];

    [framebuffer begin];
        glClearColor(1, 1,0,1);
        glClear(GL_COLOR_BUFFER_BIT);
    [framebuffer end];
}

-(Texture*)getTexture{
    return [framebuffer getColorBufferTexture];
}

@end
