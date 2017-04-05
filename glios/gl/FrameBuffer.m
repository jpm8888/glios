//
//  FrameBuffer.m
//  GLKViewExample
//
//  Created by Psi Gem on 01/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "FrameBuffer.h"

@implementation FrameBuffer

/** the default framebuffer handle, a.k.a screen. */
static int defaultFramebufferHandle;
/** true if we have polled for the default handle already. */
static BOOL defaultFramebufferHandleInitialized = false;


/** Creates a new FrameBuffer having the given dimensions and potentially a depth buffer attached.
 *
 * @param format the format of the color buffer; according to the OpenGL ES 2.0 spec, only RGB565, RGBA4444 and RGB5_A1 are
 *           color-renderable
 * @param width the width of the framebuffer in pixels
 * @param height the height of the framebuffer in pixels
 * @param hasDepth whether to attach a depth buffer
 * @throws GdxRuntimeException in case the FrameBuffer could not be created */
-(instancetype) init :(Format) format :(int) width :(int) height :(BOOL) hasDepth {
    if (!self) self = [super init];
        self.width = width;
        self.height = height;
        self.format = format;
        self.hasDepth = hasDepth;
        [self build];
    return self;
}
    
/** Override this method in a derived class to set up the backing texture as you like. */
-(void) setupTexture  {
        //colorTexture = new Texture(width, height);
    self.colorTexture = [[Texture alloc] initWithTexture:self.width height:self.height format:self.format];
    [self.colorTexture setFilter :Linear :Linear];
    [self.colorTexture setWrap :ClampToEdge :ClampToEdge];
}

    
-(void) setTexture :(Texture*) texture {
        //		this.colorTexture = texture;
        //		build();
        
}

-(void) build {
        
    // iOS uses a different framebuffer handle! (not necessarily 0)
    //		if (!defaultFramebufferHandleInitialized) {
    //			defaultFramebufferHandleInitialized = true;
    //			if (Gdx.app.getType() == ApplicationType.iOS) {
    //				IntBuffer intbuf = ByteBuffer.allocateDirect(16 * Integer.SIZE / 8).order(ByteOrder.nativeOrder()).asIntBuffer();
    //				GLES20glGetIntegerv(GLES20.GL_FRAMEBUFFER_BINDING, intbuf);
    //				defaultFramebufferHandle = intbuf.get(0);
    //			} else {
    //				defaultFramebufferHandle = 0;
    //			}
    //		}
    defaultFramebufferHandle = 0;
    [self setupTexture];
    
    IntBuffer handle = BufferUtils.allocIntBuffer(1);
    glGenFramebuffers(1, handle);
    framebufferHandle = [handle get:0];
    
    if (hasDepth) {
        [handle clear];
        glGenRenderbuffers(1, handle);
        depthbufferHandle = [handle get:0];
    }
    
    glBindTexture(GL_TEXTURE_2D, [colorTexture getTextureHandle]);
    
    if (hasDepth) {
        glBindRenderbuffer(GL_RENDERBUFFER, depthbufferHandle);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, [colorTexture getWidth],
                              [colorTexture getHeight]);
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebufferHandle);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D,
                           [colorTexture getTextureHandle], 0);
    if (hasDepth) {
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthbufferHandle);
    }
    int result = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebufferHandle);
    
    if (result != GL_FRAMEBUFFER_COMPLETE) {
        [colorTexture dispose];
        if (hasDepth) {
            [handle clear];
            [handle put :depthbufferHandle];
            [handle flip];
            glDeleteRenderbuffers(1, handle);
        }
        
        [colorTexture dispose];
        [handle clear];
        [handle put :framebufferHandle];
        [handle flip];
        glDeleteFramebuffers(1, handle);
        
        if (result == GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT)
            NSLog(@"frame buffer couldn't be constructed: incomplete attachment");
        if (result == GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS)
            NSLog(@"frame buffer couldn't be constructed: incomplete dimensions");
        if (result == GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT)
            NSLog(@"frame buffer couldn't be constructed: missing attachment");
        if (result == GL_FRAMEBUFFER_UNSUPPORTED)
            NSLog(@"frame buffer couldn't be constructed: unsupported combination of formats");
            NSLog(@"frame buffer couldn't be constructed: unknown error");
    }
}

/** Releases all resources associated with the FrameBuffer. */
-(void) dispose {
    IntBuffer handle = BufferUtils.allocIntBuffer(1);
    
    [colorTexture dispose];
    if (hasDepth) {
        [handle put :depthbufferHandle];
        [handle flip];
        glDeleteRenderbuffers(1, handle);
    }
    
    [handle clear];
    [handle put :framebufferHandle];
    [handle flip];
    glDeleteFramebuffers(1, handle);
    
        //if (buffers.get(Gdx.app) != null) buffers.get(Gdx.app).removeValue(this, true);
}
    
/** Makes the frame buffer current so everything gets drawn to it. */
-(void) bind {
    glBindFramebuffer(GL_FRAMEBUFFER, framebufferHandle);
}
    
/** Unbinds the framebuffer, all drawing will be performed to the normal framebuffer from here on. */
-(void) unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebufferHandle);
}
    
/** Binds the frame buffer and sets the viewport accordingly, so everything gets drawn to it. */
-(void) begin {
    [self bind];
    [self setFrameBufferViewport];
        //setDefaultFrameBufferViewport();
}
    
/** Sets viewport to the dimensions of framebuffer. Called by {@link #begin()}. */
-(void) setFrameBufferViewport {
    glViewport(0, 0, [colorTexture getWidth], [colorTexture getHeight]);
}
    
/** Unbinds the framebuffer, all drawing will be performed to the normal framebuffer from here on. */
-(void) end {
    [self unbind];
    [self setDefaultFrameBufferViewport];
}
    
/** Sets viewport to the dimensions of default framebuffer (window). Called by {@link #end()}. */
-(void) setDefaultFrameBufferViewport {
    glViewport(0, 0, 480, 800);
}
    
/** Unbinds the framebuffer and sets viewport sizes, all drawing will be performed to the normal framebuffer from here on.
 *
 * @param x the x-axis position of the viewport in pixels
 * @param y the y-asis position of the viewport in pixels
 * @param width the width of the viewport in pixels
 * @param height the height of the viewport in pixels */
-(void) end :(int) x :(int) y :(int) width :(int) height {
    [self unbind];
    glViewport(x, y, width, height);
}
    
/** @return the color buffer texture */
-(Texture*) getColorBufferTexture {
    return colorTexture;
}
    
/** @return the height of the framebuffer in pixels */
-(int) getHeight {
    return [colorTexture getHeight];
}
    
/** @return the width of the framebuffer in pixels */
-(int) getWidth {
    return [colorTexture getWidth];
}
    
    //	private static void addManagedFrameBuffer (Application app, FrameBuffer frameBuffer) {
    //		Array<FrameBuffer> managedResources = buffers.get(app);
    //		if (managedResources == null) managedResources = new Array<FrameBuffer>();
    //		managedResources.add(frameBuffer);
    //		buffers.put(app, managedResources);
    //	}
    
    /** Invalidates all frame buffers. This can be used when the OpenGL context is lost to rebuild all managed frame buffers. This
     * assumes that the texture attached to this buffer has already been rebuild! Use with care. */
    //	public static void invalidateAllFrameBuffers (Application app) {
    //		if (GLES20 == null) return;
    //
    //		Array<FrameBuffer> bufferArray = buffers.get(app);
    //		if (bufferArray == null) return;
    //		for (int i = 0; i < bufferArray.size; i++) {
    //			bufferArray.get(i).build();
    //		}
    //	}
    
    //	public static void clearAllFrameBuffers (Application app) {
    //		buffers.remove(app);
    //	}
    
    //	public static StringBuilder getManagedStatus (final StringBuilder builder) {
    //		builder.append("Managed buffers/app: { ");
    //		for (Application app : buffers.keySet()) {
    //			builder.append(buffers.get(app).size);
    //			builder.append(" ");
    //		}
    //		builder.append("}");
    //		return builder;
    //	}
    
    //	public static String getManagedStatus () {
    //		return getManagedStatus(new StringBuilder()).toString();
    //	}


@end
