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
    GLboolean defaultFramebufferHandleInitialized;
    GLuint framebufferHandle;
    GLint depthbufferHandle;
}


-(instancetype) init :(Format) format :(int) width :(int) height :(BOOL) hasDepth : (int) scr_width: (int) scr_height {
    if (!self) self = [super init];
    self.width = width;
    self.height = height;
    self.format = format;
    self.hasDepth = hasDepth;
    self.defaultViewportWidth = scr_width;
    self.defaultViewportHeight = scr_height;
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
    defaultFrameBufferHandle = 0;
    [self setupTexture];
    GLuint handle = NO_VALUE;
    glGenFramebuffers(1, &handle);
    
    framebufferHandle = handle;
    
    if (_hasDepth) {
        glGenRenderbuffers(1, &handle);
        depthbufferHandle = handle;
    }
    
    glBindTexture(GL_TEXTURE_2D, [_colorTexture getTextureHandle]);
    
    if (_hasDepth) {
        glBindRenderbuffer(GL_RENDERBUFFER, depthbufferHandle);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, [_colorTexture width], [_colorTexture height]);
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebufferHandle);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, [_colorTexture getTextureHandle], 0);
    if (_hasDepth) {
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthbufferHandle);
    }
    
    int result = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBufferHandle);
    
    if (result != GL_FRAMEBUFFER_COMPLETE) {
        [_colorTexture dispose];
        if (_hasDepth) {
            handle = depthbufferHandle;
            glDeleteRenderbuffers(1, &handle);
        }
        [_colorTexture dispose];
        handle = framebufferHandle;
        glDeleteFramebuffers(1, &handle);
        
        if (result == GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT){
            [GLUtil LOG:@"FrameBuffer" :@"frame buffer couldn't be constructed: incomplete attachment"];
        }
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
}

-(void) unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBufferHandle);
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
