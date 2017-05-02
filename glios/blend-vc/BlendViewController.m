//
//  BlendViewController.m
//  glios
//
//  Created by Jitendra P Maindola on 01/05/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "BlendViewController.h"
#import "Plane2D.h"
#import "OrthographicCamera.h"
#import "BlendTexture.h"

@interface BlendViewController ()

@end

@implementation BlendViewController{
    BOOL flag;
    
    OrthographicCamera *camera;
    Plane2D *background;
    Texture *backgroundTexture;
    
    BlendTexture *blendTexture;
    
}
@synthesize glkview;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    glkview.context = self.context;
    glkview.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    glkview.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    glkview.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    glkview.drawableMultisample = GLKViewDrawableMultisample4X;
    flag = true;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void) setup{
    NSLog(@"setup()");
    camera = [[OrthographicCamera alloc] init:200 :200];
    camera.position = GLKVector3Make(camera.viewportWidth/2, camera.viewportHeight/2, 0);
    [camera update];
    
    backgroundTexture = [[Texture alloc] initUsingFilePath:@"red-texture.jpg"];
    background = [[Plane2D alloc] init:0 :0 :200 :200 : backgroundTexture];
    [background translateTo:100 :100];
    
    
    NSArray *overlay = @[@"04image.png", @"19image.png"];
    NSArray *mask = @[@"04white.png", @"19white.png"];
    
    int index = 1;
    
    UIImage *bImage = [UIImage imageNamed:@"zooey.jpg"];
    UIImage *oImage = [UIImage imageNamed:[overlay objectAtIndex:index]];
    UIImage *mImage = [UIImage imageNamed:[mask objectAtIndex:index]];
    
    blendTexture = [[BlendTexture alloc] init:bImage :oImage :mImage];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    NSLog(@"rendering...");
    glClearColor(0.5, 0.5, 0.5, 0.5);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, (GLsizei) glkview.drawableWidth, (GLsizei) glkview.drawableHeight);
    
    if (flag){
        [self setup];
        flag = false;
    }
    
    [self render];
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:glkview];
    GLKVector3 points = GLKVector3Make(point.x, point.y, 0);
    points = [camera unproject:points :0 :0 :glkview.frame.size.width :glkview.frame.size.height];
    NSLog(@"%f x %f", points.x, camera.viewportHeight - points.y);
    [blendTexture move:points.x : camera.viewportHeight - points.y];
    
    [glkview setNeedsDisplay];
}

-(void) render{
    [camera update];
    [background enableBlending];
    [background render:camera.combined];
    
    [blendTexture render : camera.combined];
}



@end
