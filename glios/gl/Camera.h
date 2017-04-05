//
//  Camera.h
//  GLKViewExample
//
//  Created by Psi Gem on 03/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ray.h"
#import <GLKit/GLKit.h>

@interface Camera : NSObject

/** the position of the camera **/
@property GLKVector3 position;
/** the unit length direction vector of the camera **/
@property GLKVector3 direction;
/** the unit length up vector of the camera **/
@property  GLKVector3 up;

/** the projection matrix **/
@property  GLKMatrix4 projection;
/** the view matrix **/
@property  GLKMatrix4 view;
/** the combined projection and view matrix **/
@property  GLKMatrix4 combined;
/** the inverse combined projection and view matrix **/
@property  GLKMatrix4 invProjectionView;

/** the near clipping plane distance, has to be positive **/
@property  float near;
/** the far clipping plane distance, has to be positive **/
@property float far;
/** the viewport width **/
@property float viewportWidth;
/** the viewport height **/
@property float viewportHeight;
/** the frustum **/
//@property  Frustum frustum;

-(instancetype) init;
-(void) lookAt :(float) x :(float) y :(float) z;
-(void) lookAt :(GLKVector3) target;
-(void) normalizeUp;
-(void) rotate :(float) angle :(float) axisX :(float) axisY :(float) axisZ;
-(void) rotate :(GLKVector3) axis :(float) angle;
-(void) rotate :(const GLKMatrix4) transform;
-(void) rotateQuat :(GLKQuaternion) quat;
-(GLKVector3) transform :(GLKVector3) v;
-(void) rotateAround :(GLKVector3) point :(GLKVector3) axis :(float) angle;
//-(void) transform :(const GLKMatrix4) transform;
-(void) translate :(float) x :(float) y :(float) z;
-(void) translate :(GLKVector3) vec;
-(GLKVector3) unproject :(GLKVector3) screenCoords :(float) viewportX :(float) viewportY :(float) viewportWidth :(float) viewportHeight;
-(GLKVector3) unproject :(GLKVector3) screenCoords;
-(GLKVector3) project :(GLKVector3) worldCoords;
-(GLKVector3) project :(GLKVector3) worldCoords :(float) viewportX :(float) viewportY :(float) viewportWidth :(float) viewportHeight;
-(Ray*) getPickRay :(float) screenX :(float) screenY :(float) viewportX :(float) viewportY :(float) viewportWidth :(float) viewportHeight;
-(Ray*) getPickRay :(float) screenX :(float) screenY;


@end
