//
//  BlendTexture.m
//  glios
//
//  Created by Jitendra P Maindola on 01/05/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "BlendTexture.h"
#import "Texture.h"
#import "VertexAttribute.h"
#import "Texture.h"
#import "Plane.h"
#import "FrameBuffer.h"
#import "Plane2D.h"

@implementation BlendTexture{
    Plane2D *finalPlane;
    
    Plane2D *bPlane, *oPlane, *mPlane;
    Texture *bTexture, *oTexture, *mTexture;
    OrthographicCamera *camera;
    ShaderProgram *shader;
    FrameBuffer *framebuffer;
}


/**
 Initialization

 @param bImage background image
 @param oImage overlay image
 @param mImage maskImage
 @return self
 */
-(instancetype) init : (UIImage*) bImage : (UIImage*) oImage : (UIImage*) mImage{
    if(!self) self = [super init];
    framebuffer = [[FrameBuffer alloc] init:RGBA :500 : 500 :FALSE];
    
    int width = [framebuffer getWidth];
    int height = [framebuffer getHeight];
    
    bTexture = [[Texture alloc] init:bImage];
    oTexture = [[Texture alloc] init:oImage];
    mTexture = [[Texture alloc] init:mImage];
    camera = [[OrthographicCamera alloc] init: width:height];
    camera.position = GLKVector3Make(camera.viewportWidth/2, camera.viewportHeight/2, 0);
    
    
    
    bPlane = [[Plane2D alloc] init:0 :0 :width :height :bTexture];
    [bPlane translateTo:width/2 :height/2];
    mPlane = [[Plane2D alloc] init:0 :0 :width :height :mTexture];
    [mPlane translateTo:width/2 :height/2];
    oPlane = [[Plane2D alloc] init:0 :0 :width :height :oTexture];
    [oPlane translateTo:width/2 :height/2];
    
    finalPlane = [[Plane2D alloc] init:0 :0 :200 :200 :[framebuffer getColorBufferTexture]];
    [finalPlane translateTo:100 :100];
    [finalPlane flipY];

    return self;
}


/**
 source:
 http://stackoverflow.com/questions/5097145/opengl-mask-with-multiple-textures
 http://www.andersriggelsen.dk/glblendfunc.php
 @param combined camera matrix for final render to screen.
 */
-(void) render : (GLKMatrix4) combined{
    [camera update];
    [framebuffer begin];
    glClearColor(1, 1 , 1, 1);
    
    glEnable(GL_BLEND);
    [mPlane render:camera.combined];
    
    glBlendFunc(GL_DST_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [bPlane render:camera.combined];
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [oPlane render:camera.combined];
    
    [framebuffer end];
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [finalPlane render:combined];
    
    glDisable(GL_BLEND);
}

-(void) move: (float) x : (float) y{
    [bPlane translateTo:x :y];
}

-(void) updateTexture : (UIImage*) bImage : (UIImage*) oImage : (UIImage*) mImage{
    [bTexture updateTexture:bImage];
    [oTexture updateTexture:oImage];
    [mTexture updateTexture:mImage];
}

-(void) dispose{
    [bTexture dispose];
    [oTexture dispose];
    [mTexture dispose];
}

@end
