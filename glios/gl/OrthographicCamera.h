//
//  OrthographicCamera.h
//  GLKViewExample
//
//  Created by Psi Gem on 04/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "Camera.h"

@interface OrthographicCamera : Camera

-(instancetype) init;
-(instancetype) init :(float) viewportWidth :(float) viewportHeight;
-(void) update;
-(void) update :(BOOL) updateFrustum;
-(void) setToOrtho :(BOOL) yDown;
-(void) setToOrtho :(BOOL) yDown :(float) viewportWidth :(float) viewportHeight;
-(void) rotate :(float) angle;
-(void) translate :(float) x :(float) y;
-(void) translate :(GLKVector2) vec;
@property float zoom;

@end
