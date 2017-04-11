//
//  Camera.m
//  GLKViewExample
//
//  Created by Psi Gem on 03/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "Camera.h"

@implementation Camera {
    GLKVector3 tmpVec;
    Ray *ray;
    GLKMatrix4 tmpMat;
    GLKQuaternion tmp1;
    GLKQuaternion tmp2;
}

//private final Ray ray = new Ray(new Vector3(), new Vector3());


/** Recalculates the projection and view matrix of this camera and the {@link Frustum} planes. Use this after you've manipulated
 * any of the attributes of the camera. */
//public abstract void update ();  ////*************////***********////

/** Recalculates the projection and view matrix of this camera and the {@link Frustum} planes if <code>updateFrustum</code> is
 * true. Use this after you've manipulated any of the attributes of the camera. */
//public abstract void update (boolean updateFrustum); ////*************////***********////

-(instancetype) init {
    self = [super init];
    if (self) {
        self.direction = GLKVector3Make(0, 0, -1);
        self.up = GLKVector3Make(0, 1, 0);
        tmpVec = GLKVector3Make(0, 0, 0);
        tmp1 = GLKQuaternionMake(0, 0, 0, 0);
        tmp2 = GLKQuaternionMake(0, 0, 0, 0);
        self.near = 1;
        self.far = 100;
        self.viewportWidth = 0;
        self.viewportHeight = 0;
    }
    return self;
}

/** Recalculates the direction of the camera to look at the point (x, y, z). This function assumes the up vector is normalized.
 * @param x the x-coordinate of the point to look at
 * @param y the y-coordinate of the point to look at
 * @param z the z-coordinate of the point to look at */
-(void) lookAt :(float) x :(float) y :(float) z {
    tmpVec = GLKVector3Make(0, 0, 0);
    tmpVec = GLKVector3Subtract(tmpVec, _position);
    tmpVec = GLKVector3Normalize(tmpVec);
    if (GLKVector3AllEqualToScalar(tmpVec, 0)){
        float dot = GLKVector3DotProduct(tmpVec, _up);
        if (fabs(dot - 1) < 0.000000001f){
            _up = _direction;
            _up = GLKVector3MultiplyScalar(_up, -1);
        }else if (fabs(dot + 1) < 0.000000001f) {
            _up = _direction;
        }
        _direction = tmpVec;
        [self normalizeUp];
    }
}


/** Recalculates the direction of the camera to look at the point (x, y, z).
 * @param target the point to look at */
-(void) lookAt :(GLKVector3) target {
    [self lookAt :target.x :target.y :target.z];
}

/** Normalizes the up vector by first calculating the right vector via a cross product between direction and up, and then
 * recalculating the up vector via a cross product between right and direction. */
-(void) normalizeUp  {
    tmpVec = _direction;
    tmpVec = GLKVector3CrossProduct(tmpVec, _up);
    tmpVec = GLKVector3Normalize(tmpVec);
    _up = tmpVec;
    _up = GLKVector3CrossProduct(_up, _direction);
    _up = GLKVector3Normalize(_up);
}

/** Rotates the direction and up vector of this camera by the given angle around the given axis. The direction and up vector
 * will not be orthogonalized.
 *
 * @param angle the angle
 * @param axisX the x-component of the axis
 * @param axisY the y-component of the axis
 * @param axisZ the z-component of the axis */
-(void) rotate :(float) angle :(float) axisX :(float) axisY :(float) axisZ {
    tmpMat = GLKMatrix4Identity;
    tmpMat = GLKMatrix4Rotate(tmpMat, angle, axisX, axisY, axisZ);
    self.direction = GLKMatrix4MultiplyVector3(tmpMat, self.direction);
    self.up = GLKMatrix4MultiplyVector3(tmpMat, self.direction);
}

/** Rotates the direction and up vector of this camera by the given angle around the given axis. The direction and up vector
 * will not be orthogonalized.
 *
 * @param axis the axis to rotate around
 * @param angle the angle */
-(void) rotate :(GLKVector3) axis :(float) angle {
    tmpMat = GLKMatrix4Identity;
    tmpMat = GLKMatrix4RotateWithVector3(tmpMat, angle, axis);
    self.direction = GLKMatrix4MultiplyVector3(tmpMat, self.direction);
    self.up = GLKMatrix4MultiplyVector3(tmpMat, self.up);
}

/** Rotates the direction and up vector of this camera by the given rotation matrix. The direction and up vector will not be
 * orthogonalized.
 *
 * @param transform The rotation matrix */
-(void) rotate :(const GLKMatrix4) transform {
    
    direction.rot(transform);
    up.rot(transform);
}

/** Rotates the direction and up vector of this camera by the given {@link Quaternion}. The direction and up vector will not be
 * orthogonalized.
 *
 * @param quat The quaternion */
-(void) rotateQuat :(GLKQuaternion) quat {
//    quat.transform(direction);
    quat = [self transform:self.direction];
    quat.transform(up);
    quat = [self transform:self.up];
}

//-(GLKVector3) transform :(GLKVector3) v {
//    tmp2 = self;
//    tmp2 = GLKQuaternionConjugate(tmp2);
//    tmp1 = GLKQuaternionMake(v.x, v.y, v.z, 0);
//    tmp2 = GLKQuaternionMultiply(tmp1, self);
//    
//    v.x = tmp2.x;
//    v.y = tmp2.y;
//    v.z = tmp2.z;
//    return v;
//}

/** Rotates the direction and up vector of this camera by the given angle around the given axis, with the axis attached to given
 * point. The direction and up vector will not be orthogonalized.
 *
 * @param point the point to attach the axis to
 * @param axis the axis to rotate around
 * @param angle the angle */
-(void) rotateAround :(GLKVector3) point :(GLKVector3) axis :(float) angle {
    tmpVec = point;
    tmpVec = GLKVector3Subtract(tmpVec, _position);
    [self translate :tmpVec];
    [self rotate :axis :angle];
    tmpVec.rotate(axis, angle);
    [self translate :-tmpVec.x :-tmpVec.y :-tmpVec.z];
}

/** Transform the position, direction and up vector by the given matrix
 *
 * @param transform The transform matrix */
//-(void) transform :(const GLKMatrix4) transform {
//    _position = GLKMatrix4MultiplyVector3(transform, _position);
//    [self rotate :transform];
//}

/** Moves the camera by the given amount on each axis.
 * @param x the displacement on the x-axis
 * @param y the displacement on the y-axis
 * @param z the displacement on the z-axis */
-(void) translate :(float) x :(float) y :(float) z {
    _position = GLKVector3Add(_position, GLKVector3Make(x, y, z));
}

/** Moves the camera by the given vector.
 * @param vec the displacement vector */
-(void) translate :(GLKVector3) vec {
    _position = GLKVector3Add(_position, vec);
}

/** Function to translate a point given in screen coordinates to world space. It's the same as GLU gluUnProject, but does not
 * rely on OpenGL. The x- and y-coordinate of vec are assumed to be in screen coordinates (origin is the top left corner, y
 * pointing down, x pointing to the right) as reported by the touch methods in {@link Input}. A z-coordinate of 0 will return a
 * point on the near plane, a z-coordinate of 1 will return a point on the far plane. This method allows you to specify the
 * viewport position and dimensions in the coordinate system expected by {@link GL20#glViewport(int, int, int, int)}, with the
 * origin in the bottom left corner of the screen.
 * @param screenCoords the point in screen coordinates (origin top left)
 * @param viewportX the coordinate of the bottom left corner of the viewport in glViewport coordinates.
 * @param viewportY the coordinate of the bottom left corner of the viewport in glViewport coordinates.
 * @param viewportWidth the width of the viewport in pixels
 * @param viewportHeight the height of the viewport in pixels
 * @return the mutated and unprojected screenCoords {@link Vector3} */
-(GLKVector3) unproject :(GLKVector3) screenCoords :(float) viewportX :(float) viewportY :(float) viewportWidth :(float) viewportHeight {
    float x = screenCoords.x, y = screenCoords.y;
    x = x - viewportX;
    y = [[UIScreen mainScreen] bounds].size.height - y - 1;
    y = y - viewportY;
    screenCoords.x = (2 * x) / viewportWidth - 1;
    screenCoords.y = (2 * y) / viewportHeight - 1;
    screenCoords.z = 2 * screenCoords.z - 1;
    screenCoords = GLKMatrix4MultiplyAndProjectVector3(_invProjectionView, screenCoords);
    return screenCoords;
}

/** Function to translate a point given in screen coordinates to world space. It's the same as GLU gluUnProject but does not
 * rely on OpenGL. The viewport is assumed to span the whole screen and is fetched from {@link Graphics#getWidth()} and
 * {@link Graphics#getHeight()}. The x- and y-coordinate of vec are assumed to be in screen coordinates (origin is the top left
 * corner, y pointing down, x pointing to the right) as reported by the touch methods in {@link Input}. A z-coordinate of 0
 * will return a point on the near plane, a z-coordinate of 1 will return a point on the far plane.
 * @param screenCoords the point in screen coordinates
 * @return the mutated and unprojected screenCoords {@link Vector3} */
-(GLKVector3) unproject :(GLKVector3) screenCoords {
    screenCoords = [self project :screenCoords :0 :0 :[[UIScreen mainScreen] bounds].size.width:[[UIScreen mainScreen] bounds].size.height];
    return screenCoords;
}


/** Projects the {@link Vector3} given in world space to screen coordinates. It's the same as GLU gluProject with one small
 * deviation: The viewport is assumed to span the whole screen. The screen coordinate system has its origin in the
 * <b>bottom</b> left, with the y-axis pointing <b>upwards</b> and the x-axis pointing to the right. This makes it easily
 * useable in conjunction with {@link Batch} and similar classes.
 * @return the mutated and projected worldCoords {@link Vector3} */
-(GLKVector3) project :(GLKVector3) worldCoords {
    worldCoords = [self project:worldCoords :0 :0 :[[UIScreen mainScreen] bounds].size.width:[[UIScreen mainScreen] bounds].size.height];
    return worldCoords;
}

/** Projects the {@link Vector3} given in world space to screen coordinates. It's the same as GLU gluProject with one small
 * deviation: The viewport is assumed to span the whole screen. The screen coordinate system has its origin in the
 * <b>bottom</b> left, with the y-axis pointing <b>upwards</b> and the x-axis pointing to the right. This makes it easily
 * useable in conjunction with {@link Batch} and similar classes. This method allows you to specify the viewport position and
 * dimensions in the coordinate system expected by {@link GL20#glViewport(int, int, int, int)}, with the origin in the bottom
 * left corner of the screen.
 * @param viewportX the coordinate of the bottom left corner of the viewport in glViewport coordinates.
 * @param viewportY the coordinate of the bottom left corner of the viewport in glViewport coordinates.
 * @param viewportWidth the width of the viewport in pixels
 * @param viewportHeight the height of the viewport in pixels
 * @return the mutated and projected worldCoords {@link Vector3} */
-(GLKVector3) project :(GLKVector3) worldCoords :(float) viewportX :(float) viewportY :(float) viewportWidth :(float) viewportHeight {
    worldCoords = GLKMatrix4MultiplyAndProjectVector3(_combined, worldCoords);
    worldCoords.x = viewportWidth * (worldCoords.x + 1) / 2 + viewportX;
    worldCoords.y = viewportHeight * (worldCoords.y + 1) / 2 + viewportY;
    worldCoords.z = (worldCoords.z + 1) / 2;
    return worldCoords;
}

/** Creates a picking {@link Ray} from the coordinates given in screen coordinates. It is assumed that the viewport spans the
 * whole screen. The screen coordinates origin is assumed to be in the top left corner, its y-axis pointing down, the x-axis
 * pointing to the right. The returned instance is not a new instance but an internal member only accessible via this function.
 * @param viewportX the coordinate of the bottom left corner of the viewport in glViewport coordinates.
 * @param viewportY the coordinate of the bottom left corner of the viewport in glViewport coordinates.
 * @param viewportWidth the width of the viewport in pixels
 * @param viewportHeight the height of the viewport in pixels
 * @return the picking Ray. */
-(Ray*) getPickRay :(float) screenX :(float) screenY :(float) viewportX :(float) viewportY :(float) viewportWidth :(float) viewportHeight {
    ray.origin = GLKVector3Make(screenX, screenY, 0);
    [self unproject:ray.origin :viewportX :viewportY :viewportWidth :viewportHeight];
    ray.direction = GLKVector3Make(screenX, screenY, 1);
    [self unproject:ray.direction :viewportX :viewportY :viewportWidth :viewportHeight];
    ray.direction = GLKVector3Subtract(ray.direction, ray.origin);
    ray.direction = GLKVector3Normalize(ray.direction);
    return ray;
}

/** Creates a picking {@link Ray} from the coordinates given in screen coordinates. It is assumed that the viewport spans the
 * whole screen. The screen coordinates origin is assumed to be in the top left corner, its y-axis pointing down, the x-axis
 * pointing to the right. The returned instance is not a new instance but an internal member only accessible via this function.
 * @return the picking Ray. */
-(Ray*) getPickRay :(float) screenX :(float) screenY {
    return [self getPickRay :screenX :screenY :0 :0 :[[UIScreen mainScreen] bounds].size.width :[[UIScreen mainScreen] bounds].size.height];
}


@end
