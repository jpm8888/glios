//
//  FrameBuffer.m
//  GLKViewExample
//
//  Created by Psi Gem on 01/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "FrameBuffer.h"

@implementation FrameBuffer{
    GLint defaultFrameBufferHandle;
    GLuint framebufferHandle;
    GLuint depthbufferHandle;
}


-(instancetype) init :(Format) format :(int) width :(int) height :(BOOL) hasDepth : (float) viewportWidth : (float) viewportHeight{
    if (!self) self = [super init];
    self.width = width;
    self.height = height;
    self.format = format;
    self.hasDepth = hasDepth;
    self.defaultViewportWidth = viewportWidth;
    self.defaultViewportHeight = viewportHeight;
    [self build];
    return self;
}

-(void) setupTexture{
    self.colorTexture = [[Texture alloc] initEmptyImage:self.width :self.height :self.format];
}

-(void) setFrameBufferViewport {
    glViewport(0, 0, _defaultViewportWidth, _defaultViewportHeight);
}

-(void) setDefaultFrameBufferViewport {
    glViewport(0, 0, 480, 800);
}

-(void) build {
    GLint dfh[1];
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, dfh);
    [GLUtil checkGlError:"Framebuffer.build().glGetIntegerv()"];
    
    defaultFrameBufferHandle = dfh[0];
    NSLog(@"default frame buffer --> %d", defaultFrameBufferHandle);
    [self setupTexture];
    
    glGenFramebuffers(1, &framebufferHandle);
    [GLUtil checkGlError:"Framebuffer.build().glGenFramebuffers()"];
    
    if (_hasDepth) {
        glGenRenderbuffers(1, &depthbufferHandle);
        [GLUtil checkGlError:"Framebuffer.build().glGenRenderbuffers()"];
    }
    
    glBindTexture(GL_TEXTURE_2D, [_colorTexture getTextureHandle]);
    [GLUtil checkGlError:"Framebuffer.build().glBindTexture()"];
    
    if (_hasDepth) {
        glBindRenderbuffer(GL_RENDERBUFFER, depthbufferHandle);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, [_colorTexture width], [_colorTexture height]);
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebufferHandle);
    [GLUtil checkGlError:"Framebuffer.build().glBindFramebuffer()"];
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, [_colorTexture getTextureHandle], 0);
    [GLUtil checkGlError:"Framebuffer.build().glFramebufferTexture2D()"];
    
    if (_hasDepth) {
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthbufferHandle);
    }
    
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    int result = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBufferHandle);
    
    if (result != GL_FRAMEBUFFER_COMPLETE) {
        [_colorTexture dispose];
        
        if (_hasDepth) glDeleteRenderbuffers(1, &depthbufferHandle);
        glDeleteFramebuffers(1, &framebufferHandle);
        
        if (result == GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT)
            [GLUtil LOG:@"FrameBuffer" :@"frame buffer couldn't be constructed: incomplete attachment"];
        if (result == GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS)
            [GLUtil LOG:@"FrameBuffer" :@"frame buffer couldn't be constructed: incomplete dimensions"];
        if (result == GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT)
            [GLUtil LOG:@"FrameBuffer" :@"frame buffer couldn't be constructed: missing attachment"];
        if (result == GL_FRAMEBUFFER_UNSUPPORTED)
            [GLUtil LOG:@"FrameBuffer" :@"frame buffer couldn't be constructed: unsupported combination of formats"];
        
        [GLUtil LOG:@"FrameBuffer" : [NSString stringWithFormat:@"frame buffer couldn't be constructed: unknown error %d", result ]];
    }
}


-(void) bind {
    glBindFramebuffer(GL_FRAMEBUFFER, framebufferHandle);
    [GLUtil checkGlError:"FrameBuffer.bind().glBindFramebuffer()"];
}

-(void) unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBufferHandle);
    [GLUtil checkGlError:"FrameBuffer.unbind().glBindFramebuffer()"];
}
    

-(void) begin {
    [self setFrameBufferViewport];
    [self bind];
}

-(void) end {
    [self setDefaultFrameBufferViewport];
    [self unbind];
}


-(void) end :(int) x :(int) y :(int) w :(int) h {
    [self unbind];
    glViewport(x, y, w, h);
}
    

-(Texture*) getColorBufferTexture {
    return _colorTexture;
}
    

-(int) getHeight {
    return [_colorTexture height];
}

-(int) getWidth {
    return [_colorTexture width];
}

-(void) dispose{
    GLuint handle = NO_VALUE;
    [_colorTexture dispose];
    if (_hasDepth) {
        handle = depthbufferHandle;
        glDeleteRenderbuffers(1, &handle);
    }
    
    handle = framebufferHandle;
    glDeleteFramebuffers(1, &handle);
}

-(GLuint) getFrameBufferHandle{
    return framebufferHandle;
}


-(GLuint*) getFrameBufferHandleAdr{
    return &framebufferHandle;
}


@end
