//
//  BlendTexture.m
//  glios
//
//  Created by Jitendra P Maindola on 01/05/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "BlendTexture.h"
#import "Mesh.h"
#import "Texture.h"
#import "VertexAttribute.h"
#import "Texture.h"
#import "Plane.h"
#import "FrameBuffer.h"
#import "Plane2D.h"

@implementation BlendTexture{
    Plane2D *finalPlane;
    
    Mesh *mesh;
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
    framebuffer = [[FrameBuffer alloc] init:RGBA :200 : 200 :FALSE];
    
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
    
    finalPlane = [[Plane2D alloc] init:0 :0 :100 :100 :[framebuffer getColorBufferTexture]];
    [finalPlane translateTo:50 :50];
    [finalPlane flipY];
//    [self initMesh];
    return self;
}

//-(void) initMesh{
//    float *vertices = [Plane getVertices : 0 : 0 : 100 : 100];
//    float *textureCoords = [Plane getTextureCoordinates];
//    
//    VertexAttribute *posAttrib = [[VertexAttribute alloc] init:GL_FLOAT :2 :8 :vertices :@"a_pos"];
//    VertexAttribute *texCoordsAttrib = [[VertexAttribute alloc] init:GL_FLOAT :2 :8 :textureCoords :@"a_tex"];
//    NSMutableArray * array = [NSMutableArray array];
//    [array addObject:posAttrib];
//    [array addObject:texCoordsAttrib];
//    
//    shader = [[ShaderProgram alloc] init:@"blendvsh" :@"blendfsh" :@"glsl"];
//    mesh = [[Mesh alloc] init:array :shader];
//    
//}


/**
 source:
 http://stackoverflow.com/questions/5097145/opengl-mask-with-multiple-textures
 @param combined camera matrix for final render to screen.
 */
-(void) render : (GLKMatrix4) combined{
    [camera update];
    [framebuffer begin];
    glClearColor(1, 1 , 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [oPlane render:camera.combined];
    
    
    glBlendFuncSeparate(GL_ZERO, GL_ONE, GL_SRC_COLOR, GL_ZERO);
    [mPlane render:camera.combined];
    
//    glBlendFunc(GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
//    [bPlane render:camera.combined];
    
    glDisable(GL_BLEND);
    [framebuffer end];
    
    [finalPlane render:combined];
//    [shader begin];
//    
//    [bTexture bind : 0];
//    [mTexture bind : 1];
//    
//    [shader setUniformiWithName:"bTexture" value:0];
//    [shader setUniformiWithName:"mTexture" value:1];
//    
//    [shader setUniformMatrixWithName:"combined" withMatrix4:camera.combined transpose:GL_FALSE];
//    [mesh render:GL_TRIANGLE_FAN];
//    
//    [shader end];
}

-(void) updateTexture : (UIImage*) bImage : (UIImage*) oImage : (UIImage*) mImage{
    [bTexture updateTexture:bImage];
    [oTexture updateTexture:oImage];
    [mTexture updateTexture:mImage];
}

-(void) dispose{
    [mesh dispose];
    [bTexture dispose];
    [oTexture dispose];
    [mTexture dispose];
}

@end
