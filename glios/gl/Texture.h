//
//  Texture.h
//  GLKViewExample
//
//  Created by Psi Gem on 01/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GLUtil.h"
#define NO_VALUE -1

@interface Texture : NSObject

typedef enum {
    NEAREST = GL_NEAREST,
    Linear = GL_LINEAR,
    MipMap = GL_LINEAR_MIPMAP_LINEAR,
    MipMapNearestNearest = GL_NEAREST_MIPMAP_NEAREST,
    MipMapLinearNearest = GL_LINEAR_MIPMAP_NEAREST,
    MipMapNearestLinear = GL_NEAREST_MIPMAP_LINEAR,
    MipMapLinearLinear = GL_LINEAR_MIPMAP_LINEAR
} TextureFilter;

typedef enum {
    MirroredRepeat = GL_MIRRORED_REPEAT,
    ClampToEdge = GL_CLAMP_TO_EDGE,
    Repeat = GL_REPEAT
} TextureWrap;

typedef enum {
    RGBA = GL_RGBA,
    RGB = GL_RGB,
    RGBA4 = GL_RGBA4,
    RGB565 = GL_RGB565,
    ALPHA = GL_ALPHA,
    LUMINANCE = GL_LUMINANCE,
    LUMINANCE_ALPHA = GL_LUMINANCE_ALPHA
} Format;

@property int width, height;
@property TextureFilter minFilter, magFilter;
@property TextureWrap uWrap,vWrap;


-(instancetype) init :(UIImage*) image;
-(instancetype) initUsingFilePath : (NSString*) imgFilePath;
-(instancetype) init : (GLuint) texName : (int) w : (int) h;
-(instancetype) initEmptyImage : (int) w : (int) h : (Format) f;
-(GLuint) setupTexture :(UIImage*) image;
-(void) checkTextureError :(GLuint) tex;
-(void) setFilter :(TextureFilter) minFilter :(TextureFilter) magFilter;
-(void) setWrap :(TextureWrap) u :(TextureWrap) v;
-(TextureFilter) getMinFilter;
-(TextureFilter) getMagFilter;
-(TextureWrap) getuWrap;
-(TextureWrap) getvWrap;
-(void) assignDimensions :(UIImage*) image;
-(void) bind;
-(void) bind : (int) unit ;
-(BOOL) checkPowerofTwo;
-(void) updateTexture :(UIImage*) image;
-(GLuint) getTextureHandle;
-(void) dispose;

@end
