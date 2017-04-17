//
//  OrthographicCamera.m
//  GLKViewExample
//
//  Created by Psi Gem on 04/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "OrthographicCamera.h"

@implementation OrthographicCamera {
    GLKVector3 tmp;
}
    
-(instancetype) init {
    if (!self) self = [super init];
    self.near = 0;
    self.zoom = 1;
    self.far = 100;
    tmp = GLKVector3Make(0, 0, 0);
    self.direction = GLKVector3Make(0, 0, -1);
    self.up = GLKVector3Make(0, 1, 0);
    [self update];
    return self;
}


-(instancetype) init :(float) viewportWidth :(float) viewportHeight {
    if (!self) self = [super init];
    self.viewportWidth = viewportWidth;
    self.viewportHeight = viewportHeight;
    return [self init];
}

-(void) fixViewPorts : (float) scrWidth : (float) scrHeight : (BOOL) setDefaultPos{
    self.viewportHeight = self.viewportWidth * scrHeight / scrWidth;
    if (setDefaultPos){
        self.position = GLKVector3Make(self.viewportWidth/2.0, self.viewportHeight/2.0, 0);
    }
}

-(void) update {
    [self update :true];
}

-(void) update :(BOOL) updateFrustum {

    float left = self.zoom * (-self.viewportWidth / 2);
    float right = self.zoom * self.viewportWidth / 2;
    float bottom = self.zoom * -(self.viewportHeight / 2);
    float top = self.zoom * self.viewportHeight / 2;
    float nearZ = self.near;
    float farZ = self.far;

    self.projection = GLKMatrix4MakeOrtho(left, right, bottom, top, nearZ, farZ);
    GLKVector3 center = GLKVector3Add(self.position, self.direction);
                                      
    self.view = GLKMatrix4MakeLookAt(self.position.x, self.position.y, self.position.z,
                                      center.x, center.y, center.z,
                                      self.up.x, self.up.y, self.up.z);
    self.combined = GLKMatrix4Multiply(self.projection, self.view);
    if (updateFrustum){
        self.invProjectionView = self.combined;
        GLKMatrix4Invert(self.invProjectionView, nil);
    }
}

-(void) setToOrtho :(BOOL) yDown {
    [self setToOrtho:yDown :[[UIScreen mainScreen] bounds].size.width :[[UIScreen mainScreen] bounds].size.height];
}

-(void) setToOrtho :(BOOL) yDown :(float) viewportWidth :(float) viewportHeight {
    if (yDown) {
        self.up = GLKVector3Make(0, -1, 0);
        self.direction = GLKVector3Make(0, 0, 1);
    } else {
        self.up = GLKVector3Make(0, 1, 0);
        self.direction = GLKVector3Make(0, 0, -1);
    }
    
    self.position = GLKVector3Make(self.zoom * self.viewportWidth / 2.0f, self.zoom * self.viewportHeight / 2.0f, 0);
    self.viewportWidth = viewportWidth;
    self.viewportHeight = viewportHeight;
    [self update];
}

-(void) rotate :(float) angle {
    [self rotate :self.direction :angle];
}

-(void) translate :(float) x :(float) y {
    [self translate :x :y :0];
}

-(void) translate :(GLKVector2) vec {
    [self translate :vec.x :vec.y :0];
}

-(void) printMatrix : (GLKMatrix4) mat : (NSString*) name{
    NSLog(@"matrix-print with name %@", name);
    NSLog(@"%f %f %f %f", mat.m00, mat.m10, mat.m20, mat.m30);
    NSLog(@"%f %f %f %f", mat.m01, mat.m11, mat.m21, mat.m31);
    NSLog(@"%f %f %f %f", mat.m02, mat.m12, mat.m22, mat.m32);
    NSLog(@"%f %f %f %f", mat.m03, mat.m13, mat.m23, mat.m33);
}


@end
