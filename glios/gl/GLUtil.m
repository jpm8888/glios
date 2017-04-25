//
//  GLUtil.m
//  GLKViewExample
//
//  Created by Jitu JPM on 2/10/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "GLUtil.h"

@implementation GLUtil
static BOOL debug = NO;

+(void) checkGlError :(const char*) op{
    if (!debug) return;
    for (GLint error = glGetError(); error; error= glGetError()) {
        NSLog(@"after %s() glError (0x%x)\n", op, error);
    }
}


+(void) printGLString :(const char *) name :(GLenum) s{
    if (!debug) return;
    const char *v = (const char *) glGetString(s);
    NSLog(@"GL %s = %s\n", name, v);
}


+(void) LOG :(NSString*) TAG :(NSString *) msg{
    if (!debug) return;
    NSLog(@"%@ :- %@",TAG , msg);
}

+(void)setDebug:(BOOL) val{
    debug = val;
}

+(UIImage*) getUIImage : (int) width : (int) height{
    int backingWidth = width;
    int backingHeight = height;
    GLubyte *buffer = (GLubyte *) malloc(backingWidth * backingHeight * 4);
    GLubyte *buffer2 = (GLubyte *) malloc(backingWidth * backingHeight * 4);
//    GLvoid *pixel_data = nil;
    glReadPixels(0, 0, backingWidth, backingHeight, GL_RGBA, GL_UNSIGNED_BYTE,
                 (GLvoid *)buffer);
    for (int y = 0; y < backingHeight; y++) {
        for (int x = 0; x < backingWidth * 4; x++) {
            buffer2[y * 4 * backingWidth + x] = buffer[(backingHeight - y - 1) * backingWidth * 4 + x];
        }
    }
    CGDataProviderRef provider;
    provider = CGDataProviderCreateWithData(NULL, buffer2, backingWidth * backingHeight * 4, releaseBufferData);
    // set up for CGImage creation
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * backingWidth;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    // Use this to retain alpha
    //CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(backingWidth, backingHeight,
                                        bitsPerComponent, bitsPerPixel,
                                        bytesPerRow, colorSpaceRef,
                                        bitmapInfo, provider,
                                        NULL, NO,
                                        renderingIntent);
    // this contains our final image.
    UIImage *newUIImage = [UIImage imageWithCGImage:imageRef];
    return newUIImage;
}

void releaseBufferData(void *info, const void *data, size_t size){
    free((void*)data);
}


@end
