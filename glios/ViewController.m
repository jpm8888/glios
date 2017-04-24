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
#import "FrameBuffer.h"

@interface ViewController ()

@end

@implementation ViewController{
    OrthographicCamera * camera;
    Plane2D *plane, *fboPlane;
    Texture *texture;
    FrameBuffer * fbo;
    NSMutableArray * planes;
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
//    [plane translateTo:150 :150];
//    [plane translateTo:100 :100];
//    [plane rotateTo:GLKMathDegreesToRadians(45)];
//    [plane flipY];
    
    fbo = [[FrameBuffer alloc] init:RGBA :200 :200 : NO :self.view.frame.size.width : self.view.frame.size.height];
    
    [fbo begin];
    OrthographicCamera *fbocam = [[OrthographicCamera alloc] init:200 :200];
//    [fbocam setToOrtho:NO : 200 : 200];
    [fbocam fixViewPorts:200 :200 :YES];
    
    NSLog(@"fbocam %f x %f", fbocam.viewportWidth, fbocam.viewportHeight);
    [fbocam update];
        glClearColor(1,0, 0, 1);
        glClear(GL_COLOR_BUFFER_BIT);
        Texture *tx = [[Texture alloc] initUsingFilePath:@"test.jpg"];
        Plane2D *pl = [[Plane2D alloc] init:0 :0 :200 :200 : tx];
    
        [pl render:fbocam.combined];
    [fbo end];
    
    fboPlane = [[Plane2D alloc] init: 0 : 0 : 200 : 200 : [fbo getColorBufferTexture]];
    
    
}

-(int) getrand:(int)lowerBound : (int) upperBound{
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    return rndValue;
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
    
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self.view];
    GLKVector3 touch = [camera unproject:GLKVector3Make(point.x, point.y, 0)];
    
    [plane translateTo:touch.x : camera.viewportHeight - touch.y];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)rotate{
    static int angle = 5;
    [plane rotateTo:GLKMathDegreesToRadians(angle+=5)];
}

- (IBAction)flipY:(id)sender {
    [plane flipY];
}

- (IBAction)flipX:(id)sender {
    [plane flipX];
}

- (IBAction)flipXY:(id)sender {
    [self rotate];
}
@end
