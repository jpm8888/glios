//
//  ViewController.m
//  glios
//
//  Created by Jitu JPM on 4/5/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "ViewController.h"
#import "Texture.h"
#import "Plane2D.h"
#import "OrthographicCamera.h"

@interface ViewController ()

@end

@implementation ViewController{
    OrthographicCamera * camera;
    Plane2D *plane;
    Plane2D *plane2;
    Texture *texture;
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
    
    Texture *tex = [[Texture alloc] initUsingFilePath:@"test.jpg"];
    plane = [[Plane2D alloc] init:0 :0 :100 :100 : tex];
    Color *red = [[Color alloc] init:1 :0 :0 :1];
    Color *green = [[Color alloc] init:0 :1 :0 :1];
    Color *white = [[Color alloc] init:1 :1 :1 :1];
    Color *blue = [[Color alloc] init:0 :0 :1 :1];
    
    [plane setColor: red : green : blue : white];
    
    plane2 = [[Plane2D alloc] init:100 :100 :100 :100 : tex];
   
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
    [plane render:camera.combined];
    [plane2 render:camera.combined];
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self.view];
    GLKVector3 touch = [camera unproject:GLKVector3Make(point.x, point.y, 0)];
    
    [plane setPosition:touch.x : camera.viewportHeight - touch.y];
//
//    modalMatrix = GLKMatrix4Identity;
//    modalMatrix = GLKMatrix4Translate(modalMatrix, touch.x, camera.viewportHeight - touch.y, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
