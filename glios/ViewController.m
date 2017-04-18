//
//  ViewController.m
//  glios
//
//  Created by Jitu JPM on 4/5/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "ViewController.h"
#import "OrthographicCamera.h"
#import "ShaderProgram.h"
#import "Mesh.h"
#import "Texture.h"
#import "GLUtil.h"
#import "VertexAttribute.h"
#import "Color.h"

@interface ViewController ()

@end

@implementation ViewController{
    GLfloat verts_array[8];
    GLfloat color_array[16];
    GLfloat tex_coords[8];
    OrthographicCamera * camera;
    ShaderProgram *shader;
    Mesh *mesh;
    Texture *texture;
    Color *color;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    GLKView *view = (GLKView *)self.view;
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    view.drawableMultisample = GLKViewDrawableMultisample4X;
    self.preferredFramesPerSecond = 60;
    
    NSLog(@"viewDidLoad()");

}

-(void) setup{
    NSLog(@"setup()");
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [GLUtil setDebug:YES];
    camera = [[OrthographicCamera alloc] init:480 :800];
    [camera fixViewPorts:self.view.frame.size.width :self.view.frame.size.height:YES];
    [self updatePlaneVerts:verts_array :camera.viewportWidth/2 - 100 :camera.viewportHeight/2 - 100 :200 :200];
    color = [[Color alloc] initUsingUIColor:[UIColor redColor]];
    [self updateColor:color_array : 16: color];
    [self updateTexCoords:tex_coords];
    
    texture = [[Texture alloc] initUsingFilePath:@"test.jpg"];
    
    VertexAttribute * attrib1 = [[VertexAttribute alloc] init: GL_FLOAT :2: (sizeof(verts_array)/ sizeof(verts_array[0])) : verts_array :@"a_pos"];
    VertexAttribute * attrib2 = [[VertexAttribute alloc] init : GL_FLOAT : 4: (sizeof(color_array)/sizeof(color_array[0])) : color_array : @"a_color"];
    VertexAttribute * attrib3 = [[VertexAttribute alloc] init : GL_FLOAT : 2: (sizeof(tex_coords)/sizeof(tex_coords[0])) : tex_coords : @"a_tex"];
    
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:attrib1];
    [array addObject:attrib2];
    [array addObject:attrib3];
    
    shader = [[ShaderProgram alloc] init:@"vsh" :@"fsh" :@"glsl"];
    mesh = [[Mesh alloc]init:array : shader];
    
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    static bool flag = false;
    if (!flag){
        NSLog(@"drawInRect()");
        [self setup];
        flag = true;
    }
    
    [self render];
}

-(void) render{
    glClearColor(0.5f,0.5f,0.5f,0.5f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [camera update];
    
    [shader begin];
    [texture bind];
    [shader setUniformiWithName:"u_texture" value:1];
    [shader setUniformMatrixWithName:"combined" withMatrix4:camera.combined transpose:GL_FALSE];
    [mesh render:GL_TRIANGLE_FAN];
    
    [shader end];
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self.view];
//    NSLog(@"%@", NSStringFromCGPoint(point));
    GLKVector3 touch = [camera unproject:GLKVector3Make(point.x, point.y, 0)];
    NSLog(@"camera-viewport height--> %f --> %f", camera.viewportHeight, touch.y);
    NSLog(@"touch-> %f x %f x %f", touch.x, touch.y, touch.z);
}


-(void) updateTexCoords : (GLfloat*) t{
    int idx = 0;
    t[idx++] = 0;
    t[idx++] = 1;
    
    t[idx++] = 0;
    t[idx++] = 0;
    
    t[idx++] = 1;
    t[idx++] = 0;
    
    t[idx++] = 1;
    t[idx++] = 1;
}

-(void) updatePlaneVerts: (GLfloat*) v : (float) x : (float) y : (float) w : (float) h{
    v[0] = x;
    v[1] = y;
    
    v[2] = x;
    v[3] = y + h;
    
    v[4] = x + w;
    v[5] = y + h;
    
    v[6] = x + w;
    v[7] = y;
}

-(void) updateColor: (GLfloat*) v : (int) len : (Color*) c{
    if (len % 4 != 0) {
        NSLog(@"Invalid color size");
        return;
    }
    int idx = 0;
    while (idx < len){
        v[idx++] = c.r;
        v[idx++] = c.g;
        v[idx++] = c.b;
        v[idx++] = c.a;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
