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

@implementation Plane2D{
    Mesh *mesh;
    ShaderProgram *shader;
    Texture *texture;
    Color *colorLeftTop, *colorLeftBottom, *colorRightTop, *colorRightBottom;
    
    GLKVector2 pos;
    GLKVector2 size;
    GLfloat *vertices;
    GLfloat *color;
    GLfloat *texCoords;
    Rectangle * bounds;
    BOOL dirty;
}

-(instancetype) init : (float) x : (float) y : (float) w : (float) h : (Texture*) tex{
    if (!self) self = [super init];
    texture = tex;
    dirty = true;
    vertices = (GLfloat*) calloc(2 * 4, sizeof(GLfloat));
    color = (GLfloat*) calloc(4 * 4, sizeof(GLfloat));
    texCoords = (GLfloat*) calloc(2 * 4, sizeof(GLfloat));
    [self setPosition: x : y];
    [self setSize: w :h];
    
    bounds = [[Rectangle alloc] init:x :y :w :h];
    [self setupMesh];
    return self;
}

-(void) setupMesh{
    VertexAttribute *posAttrib = [[VertexAttribute alloc] init:GL_FLOAT :2 :8 :vertices :@"a_pos"];
    VertexAttribute *colorAttrib = [[VertexAttribute alloc] init:GL_FLOAT :4 :16 :color :@"a_color"];
    VertexAttribute *texCoordsAttrib = [[VertexAttribute alloc] init:GL_FLOAT :2 :8 :texCoords :@"a_tex"];
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:posAttrib];
    [array addObject:colorAttrib];
    [array addObject:texCoordsAttrib];
    
    
    NSString *defaultVertexShader = [NSString stringWithFormat:@"attribute vec4 a_pos; \n"
                                                                "attribute vec2 a_tex;\n"
                                                                "attribute vec4 a_color;\n"
                                                                "uniform mat4 combined;\n"
                                                                "varying vec2 v_tex;\n"
                                                                "varying vec4 v_color;\n"
                                                                "void main(void) {\n"
                                                                "v_color = a_color;\n"
                                                                "v_tex = a_tex;\n"
                                                                "gl_Position = combined * a_pos;\n"
                                                                "}\n" ];
    
    NSString *defaultFragmentShader = [NSString stringWithFormat:@"#ifdef GL_ES\n"
                                                "precision mediump float;\n"
                                                "#endif\n"
                                                "varying vec2 v_tex;\n"
                                                "varying vec4 v_color;\n"
                                                "uniform sampler2D u_texture;\n"
                                                "void main(void) {\n"
                                                "gl_FragColor =  v_color * texture2D(u_texture, v_tex);\n"
                                       "}\n"];
    
    shader = [[ShaderProgram alloc] init:defaultVertexShader :defaultFragmentShader];
    mesh = [[Mesh alloc] init:array :shader];
    
    colorLeftTop = [[Color alloc] init:1 :1 :1 :1];
    colorLeftBottom = [[Color alloc] init:1 :1 :1 :1];
    colorRightTop = [[Color alloc] init:1 :1 :1 :1];
    colorRightBottom = [[Color alloc] init:1 :1 :1 :1];
    
}


-(void) render : (GLKMatrix4) matrix{
    if (dirty) [self update];
    [shader enableBlending];
    [shader begin];
        [texture bind];
        [shader setUniformMatrixWithName:"combined" withMatrix4:matrix transpose:GL_FALSE];
        [mesh render:GL_TRIANGLE_FAN];
    [shader end];
}

-(GLKVector2) getPosition{
    return pos;
}

-(float) getPositionX{
    return pos.x;
}

-(float) getPositionY{
    return pos.y;
}

-(void) setPositionX : (float) x{
    [self setPosition: GLKVector2Make(x, [self getPositionY])];
}

-(void) setPositionY : (float) y{
    [self setPosition:GLKVector2Make([self getPositionX], y)];
}

-(void) setPosition : (float) x : (float) y{
    [self setPosition:GLKVector2Make(x, y)];
}

-(void) setPosition : (GLKVector2) vec{
    dirty = true;
    pos = vec;
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

-(void) setWidth : (float) w{
    [self setSize: GLKVector2Make(w, [self getHeight])];
}

-(void) setHeight : (float) h{
    [self setSize: GLKVector2Make([self getWidth], h)];
}

-(void) setSize : (float) w : (float) h{
    [self setSize:GLKVector2Make(w, h)];
}

-(void) setSize : (GLKVector2) vec{
    dirty = true;
    size = vec;
}

-(void) setColor : (Color*) lb : (Color*) lt : (Color*) rb : (Color*) rt{
    colorLeftBottom = lb;
    colorLeftTop = lt;
    colorRightBottom = rb;
    colorRightTop = rt;
    dirty = true;
}

-(void) setTexture : (Texture*) tex{
    [texture dispose];
    texture = tex;
}

-(void) update{
    if (!dirty) return;
    [self updateVertices];
    [self updateTexCoords];
    [self updateColor];
    dirty = false;
}

-(void) updateVertices{
    int idx = 0;
    vertices[idx++] = pos.x;
    vertices[idx++] = pos.y;
    vertices[idx++] = pos.x;
    vertices[idx++] = pos.y + size.y;
    vertices[idx++] = pos.x + size.x;
    vertices[idx++] = pos.y + size.y;
    vertices[idx++] = pos.x + size.x;
    vertices[idx++] = pos.y;
    [bounds set:pos.x :pos.y :size.x :size.y];
}

-(void) updateTexCoords{
    int idx = 0;
    texCoords[idx++] = 0;
    texCoords[idx++] = 1;
    
    texCoords[idx++] = 0;
    texCoords[idx++] = 0;
    
    texCoords[idx++] = 1;
    texCoords[idx++] = 0;
    
    texCoords[idx++] = 1;
    texCoords[idx++] = 1;
}

-(void) updateColor{
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
    free(vertices);
    free(color);
    free(texCoords);
    [shader dispose];
}


@end
