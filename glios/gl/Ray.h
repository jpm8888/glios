//
//  Ray.h
//  GLKViewExample
//
//  Created by Psi Gem on 03/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Ray : NSObject

@property GLKVector3 origin;
@property GLKVector3 direction;

-(instancetype) initRay :(GLKVector3) origin :(GLKVector3) direction;
-(Ray*) cpy;
-(GLKVector3) getEndPoint :(GLKVector3) outVector :(const float) distance;
-(Ray*) mul :(GLKMatrix4) matrix;
-(Ray*) set :(GLKVector3) origin :(GLKVector3) direction;
-(Ray*) set :(float) x :(float )y :(float) z :(float) dx :(float) dy :(float) dz;
-(Ray*) set :(Ray*) ray;


@end
