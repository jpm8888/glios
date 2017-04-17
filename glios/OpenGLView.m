//
//  OpenGLView.m
//  glios
//
//  Created by Jitu JPM on 4/13/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "OpenGLView.h"
#import "ShaderProgram.h"
#import "Mesh.h"
#import "VertexAttribute.h"
#import "Texture.h"
#import "OrthographicCamera.h"

@implementation OpenGLView{
    OrthographicCamera *camera;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self render];
        
    }
    return self;
}

+(Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupFrameBuffer {
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)render {
    glClearColor(0.5, 0.5, 0.5, 0.5);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);

    
    
    [GLUtil setDebug:YES];
    GLfloat verts_array[] = {
        0, 0,
        0, 100,
        100,100,
        100, 0
    };
    
    GLfloat color_array[] = {
        1, 0, 0, 1,
        0, 1, 0, 1,
        0, 0, 1, 1,
        1, 0, 1, 1
    };
    
    GLfloat tex_coords[] = {
        0, 1,
        0, 0,
        1,0,
        1,1
    };
    
    
    camera = [[OrthographicCamera alloc] init:480 :800];
    [camera fixViewPorts:self.frame.size.width :self.frame.size.height:YES];
    Texture * texture = [[Texture alloc] initUsingFilePath:@"test.jpg"];
    
    VertexAttribute * attrib1 = [[VertexAttribute alloc] init: GL_FLOAT :2: (sizeof(verts_array)/ sizeof(verts_array[0])) : verts_array :@"a_pos"];
    VertexAttribute * attrib2 = [[VertexAttribute alloc] init : GL_FLOAT : 4: (sizeof(color_array)/sizeof(color_array[0])) : color_array : @"a_color"];
    VertexAttribute * attrib3 = [[VertexAttribute alloc] init : GL_FLOAT : 2: (sizeof(tex_coords)/sizeof(tex_coords[0])) : tex_coords : @"a_tex"];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:attrib1];
    [array addObject:attrib2];
    [array addObject:attrib3];
    
    Mesh *mesh = [[Mesh alloc]init:array];
    ShaderProgram *shader = [[ShaderProgram alloc] init:@"vsh" :@"fsh" :@"glsl"];
    
    [camera update];
    
    [shader begin];
        [texture bind];
        [shader setUniformMatrixWithName:"combined" withMatrix4:camera.combined transpose:GL_FALSE];
        [mesh render:shader :GL_TRIANGLE_FAN];
    [shader end];
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
//    [mesh dispose];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self];
    NSLog(@"%@", NSStringFromCGPoint(point));
    GLKVector3 touch = [camera unproject:GLKVector3Make(point.x, point.y, 0)];
    NSLog(@"touch-> %f x %f x %f", touch.x, touch.y, touch.z);
}

@end
