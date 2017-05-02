//
//  Plane2D.m
//  glios
//
//  Created by Jitu JPM on 4/22/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "Plane2D.h"
#import "Rectangle.h"
#import "Mesh.h"
#import "VertexAttribute.h"
#import "ShaderProgram.h"
#import "Plane.h"

@implementation Plane2D{
    Mesh *mesh;
    ShaderProgram *shader;
    Texture *texture;
    Color *colorLeftTop, *colorLeftBottom, *colorRightTop, *colorRightBottom;
    
    GLKMatrix4 scaleMat;
    GLKMatrix4 rotationMat;
    GLKMatrix4 translateMat;
    
    GLKVector2 size, pos;
    GLKVector2 origin;
    GLfloat *vertices;
    GLfloat *color;
    GLfloat *texCoords;
    Rectangle * bounds;
    BOOL flippedX, flippedY;
}

-(instancetype) init : (float) x : (float) y : (float) w : (float) h : (Texture*) tex{
    if (!self) self = [super init];
    texture = tex;
    pos = GLKVector2Make(x, y);
    size = GLKVector2Make(w, h);
    origin = GLKVector2Make(size.x / 2.0, size.y / 2.0);
    bounds = [[Rectangle alloc] init:x :y :w :h];
    [self setupMesh];
    return self;
}


-(void) translateTo : (float) tx : (float) ty{
    translateMat = GLKMatrix4MakeTranslation(tx, ty, 0);
}

-(void) scaleTo : (float) scl{
    scaleMat = GLKMatrix4MakeScale(scl, scl, 0);
}

-(void) rotateTo : (float) rot{
    rotationMat = GLKMatrix4Translate(rotationMat, origin.x, origin.y, 0);
    rotationMat  = GLKMatrix4MakeRotation(rot, 0, 0, 1);
    rotationMat = GLKMatrix4Translate(rotationMat, -origin.x, -origin.y, 0);
}


-(void) setupMesh{
    colorLeftTop = [[Color alloc] init:1 :1 :1 :1];
    colorLeftBottom = [[Color alloc] init:1 :1 :1 :1];
    colorRightTop = [[Color alloc] init:1 :1 :1 :1];
    colorRightBottom = [[Color alloc] init:1 :1 :1 :1];
    
    vertices = (GLfloat*) calloc(2 * 4, sizeof(GLfloat));
    color = (GLfloat*) calloc(4 * 4, sizeof(GLfloat));
    texCoords = (GLfloat*) calloc(2 * 4, sizeof(GLfloat));
    
    [self initVertices];
    [self initColor];
    texCoords = (GLfloat*) [Plane getTextureCoordinates];
    
    VertexAttribute *posAttrib = [[VertexAttribute alloc] init:GL_FLOAT :2 :8 :vertices :@"a_pos"];
    VertexAttribute *colorAttrib = [[VertexAttribute alloc] init:GL_FLOAT :4 :16 :color :@"a_color"];
    VertexAttribute *texCoordsAttrib = [[VertexAttribute alloc] init:GL_FLOAT :2 :8 :texCoords :@"a_tex"];
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:posAttrib];
    [array addObject:colorAttrib];
    [array addObject:texCoordsAttrib];
    
    
    shader = [ShaderProgram getDefaultShader];
    mesh = [[Mesh alloc] init:array :shader];
    
    [self scaleTo:1];
    [self rotateTo:GLKMathDegreesToRadians(0)];
    [self translateTo:pos.x : pos.y];
}

-(void) enableBlending{
    [shader enableBlending];
}

-(void) render : (GLKMatrix4) matrix{
    [shader begin];
        [texture bind];
        GLKMatrix4 transformations = GLKMatrix4Multiply(translateMat, scaleMat); // T * S
        transformations = GLKMatrix4Multiply(transformations, rotationMat); // T * S * R
        transformations = GLKMatrix4Multiply(matrix, transformations); // T * S * R * Combined
        [shader setUniformMatrixWithName:"combined" withMatrix4:transformations transpose:GL_FALSE];
        [mesh render:GL_TRIANGLE_FAN];
    [shader end];
}

-(void) disableBlending{
    [shader disableBlending];
}

-(GLKVector2) getSize{
    return size;
}

-(float) getWidth{
    return size.x;
}

-(float) getHeight{
    return size.y;
}

-(void) setColor : (Color*) lb : (Color*) lt : (Color*) rb : (Color*) rt{
    colorLeftBottom = lb;
    colorLeftTop = lt;
    colorRightBottom = rb;
    colorRightTop = rt;
    [self initColor];
}

-(void) setTexture : (Texture*) tex{
    [texture dispose];
    texture = tex;
}

-(void) initVertices{
    vertices = (GLfloat*) [Plane getVertices:pos.x :pos.y :size.x :size.y];
    [bounds set:pos.x :pos.y :size.x :size.y];
}

-(void) flipX{
    for (int i = 0; i < 8; i++) {
        if (i % 2 == 0){
            texCoords[i] = 1 - texCoords[i];
        }
    }
}

-(void) flipY{
    for (int i = 0; i < 8; i++) {
        if (i % 2 != 0){
            texCoords[i] = 1 - texCoords[i];
        }
    }
}

-(void) initColor{
    int idx = 0;
    color[idx++] = colorLeftBottom.r;
    color[idx++] = colorLeftBottom.g;
    color[idx++] = colorLeftBottom.b;
    color[idx++] = colorLeftBottom.a;
    
    color[idx++] = colorLeftTop.r;
    color[idx++] = colorLeftTop.g;
    color[idx++] = colorLeftTop.b;
    color[idx++] = colorLeftTop.a;
    
    color[idx++] = colorRightTop.r;
    color[idx++] = colorRightTop.g;
    color[idx++] = colorRightTop.b;
    color[idx++] = colorRightTop.a;
    
    color[idx++] = colorRightBottom.r;
    color[idx++] = colorRightBottom.g;
    color[idx++] = colorRightBottom.b;
    color[idx++] = colorRightBottom.a;
}



-(BOOL) contains : (float) x : (float) y{
    if ([bounds contains:x :y]){
        return YES;
    }else{
        return NO;
    }
}

-(void) dispose{
    free(color);
    [mesh dispose];
}


@end
