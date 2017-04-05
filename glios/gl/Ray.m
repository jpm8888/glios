//
//  Ray.m
//  GLKViewExample
//
//  Created by Psi Gem on 03/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "Ray.h"

@implementation Ray {
    GLKVector3 tmp;
}

-(instancetype) init {
    if (!self)  self = [super init];
    self.origin = GLKVector3Make(0, 0, 0);
    self.direction = GLKVector3Make(0, 0, 0);
    return self;
}

/** Constructor, sets the starting position of the ray and the direction.
 *
 * @param origin The starting position
 * @param direction The direction */
-(instancetype) initRay :(GLKVector3) origin :(GLKVector3) direction {
    if(!self) self = [self init];
    self.origin = origin;
    self.direction = direction;
    self.direction = GLKVector3Normalize(self.direction);
    return self;
}

/** @return a copy of this ray. */
-(Ray*) cpy {
    return [self initRay :self.origin :self.direction];
}

/** Returns the endpoint given the distance. This is calculated as startpoint + distance * direction.
 * @param out The vector to set to the result
 * @param distance The distance from the end point to the start point.
 * @return The out param */
-(GLKVector3) getEndPoint :(GLKVector3) outVector :(const float) distance {
    outVector = self.direction;
    outVector = GLKVector3MultiplyScalar(outVector, distance);
    outVector = GLKVector3Add(outVector, self.origin);
    return outVector;
}


/** Multiplies the ray by the given matrix. Use this to transform a ray into another coordinate system.
 *
 * @param matrix The matrix
 * @return This ray for chaining. */
-(Ray*) mul :(GLKMatrix4) matrix {
    tmp = self.origin;
    tmp = GLKVector3Add(tmp, self.direction);
    tmp = GLKMatrix4MultiplyVector3(matrix, tmp);
    self.origin = GLKMatrix4MultiplyVector3(matrix, self.origin);
    tmp = GLKVector3Subtract(tmp, self.origin);
    self.direction = tmp;
    return self;
}


/** Sets the starting position and the direction of this ray.
 *
 * @param origin The starting position
 * @param direction The direction
 * @return this ray for chaining */
-(Ray*) set :(GLKVector3) origin :(GLKVector3) direction {
    self.origin = origin;
    self.direction = direction;
    return self;
}

/** Sets this ray from the given starting position and direction.
 *
 * @param x The x-component of the starting position
 * @param y The y-component of the starting position
 * @param z The z-component of the starting position
 * @param dx The x-component of the direction
 * @param dy The y-component of the direction
 * @param dz The z-component of the direction
 * @return this ray for chaining */
-(Ray*) set :(float) x :(float )y :(float) z :(float) dx :(float) dy :(float) dz {
    self.origin = GLKVector3Make(x, y, z) ;
    self.direction = GLKVector3Make(dx, dy, dz);
    return self;
}

/** Sets the starting position and direction from the given ray
 *
 * @param ray The ray
 * @return This ray for chaining */
-(Ray*) set :(Ray*) ray {
    self.origin = ray.origin;
    self.direction = ray.direction;
    return self;
}

@end
