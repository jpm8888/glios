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

-(void) lookAt :(GLKVector3) target {
    [self lookAt :target.x :target.y :target.z];
}

-(void) normalizeUp  {
    tmpVec = _direction;
    tmpVec = GLKVector3CrossProduct(tmpVec, _up);
    tmpVec = GLKVector3Normalize(tmpVec);
    _up = tmpVec;
    _up = GLKVector3CrossProduct(_up, _direction);
    _up = GLKVector3Normalize(_up);
}

-(void) rotate :(float) angle :(float) axisX :(float) axisY :(float) axisZ {
    tmpMat = GLKMatrix4Identity;
    tmpMat = GLKMatrix4Rotate(tmpMat, angle, axisX, axisY, axisZ);
    self.direction = GLKMatrix4MultiplyVector3(tmpMat, self.direction);
    self.up = GLKMatrix4MultiplyVector3(tmpMat, self.direction);
}

-(void) rotate :(GLKVector3) axis :(float) angle {
    tmpMat = GLKMatrix4Identity;
    tmpMat = GLKMatrix4RotateWithVector3(tmpMat, angle, axis);
    self.direction = GLKMatrix4MultiplyVector3(tmpMat, self.direction);
    self.up = GLKMatrix4MultiplyVector3(tmpMat, self.up);
}

-(void) rotate :(const GLKMatrix4) transform {
    _direction = GLKVector3Make(
    _direction.x * transform.m00 + _direction.y * transform.m01 + _direction.z * transform.m02,
    _direction.x * transform.m10 + _direction.y * transform.m11 + _direction.z * transform.m12,
    _direction.x * transform.m20 + _direction.y * transform.m21 + _direction.z * transform.m22);
    
    
    _up = GLKVector3Make(
    _up.x * transform.m00 + _up.y * transform.m01 + _up.z * transform.m02,
    _up.x * transform.m10 + _up.y * transform.m11 + _up.z * transform.m12,
    _up.x * transform.m20 + _up.y * transform.m21 + _up.z * transform.m22);
}


-(void) rotateAround :(GLKVector3) point :(GLKVector3) axis :(float) angle {
    tmpVec = point;
    tmpVec = GLKVector3Subtract(tmpVec, _position);
    [self translate :tmpVec];
    [self rotate :axis :angle];
    tmpVec = GLKMatrix4MultiplyVector3(GLKMatrix4RotateWithVector3(GLKMatrix4Identity, angle, axis), tmpVec);
    [self translate :-tmpVec.x :-tmpVec.y :-tmpVec.z];
}

-(void) translate :(float) x :(float) y :(float) z {
    _position = GLKVector3Add(_position, GLKVector3Make(x, y, z));
}

-(void) translate :(GLKVector3) vec {
    _position = GLKVector3Add(_position, vec);
}

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

-(GLKVector3) unproject :(GLKVector3) screenCoords {
    screenCoords = [self project :screenCoords :0 :0 :[[UIScreen mainScreen] bounds].size.width:[[UIScreen mainScreen] bounds].size.height];
    return screenCoords;
}

-(GLKVector3) project :(GLKVector3) worldCoords {
    worldCoords = [self project:worldCoords :0 :0 :[[UIScreen mainScreen] bounds].size.width:[[UIScreen mainScreen] bounds].size.height];
    return worldCoords;
}

-(GLKVector3) project :(GLKVector3) worldCoords :(float) viewportX :(float) viewportY :(float) viewportWidth :(float) viewportHeight {
    worldCoords = GLKMatrix4MultiplyAndProjectVector3(_combined, worldCoords);
//    worldCoords = [self prj:self.combined :worldCoords];
    worldCoords.x = viewportWidth * (worldCoords.x + 1) / 2 + viewportX;
    worldCoords.y = viewportHeight * (worldCoords.y + 1) / 2 + viewportY;
    worldCoords.z = (worldCoords.z + 1) / 2;
    return worldCoords;
}

-(GLKVector3) prj : (GLKMatrix4) l_mat : (GLKVector3) r_vec{
    float l_w = 1.0 / (r_vec.x * l_mat.m30 + r_vec.y * l_mat.m31 + r_vec.z * l_mat.m32 + l_mat.m33);
    float l_x = (r_vec.x * l_mat.m00 + r_vec.y * l_mat.m01 + r_vec.z * l_mat.m02 + l_mat.m03) * l_w;
    float l_y =(r_vec.x * l_mat.m10 + r_vec.y * l_mat.m11 + r_vec.z * l_mat.m12 + l_mat.m13) * l_w;
    float l_z = (r_vec.x * l_mat.m20 + r_vec.y * l_mat.m21 + r_vec.z * l_mat.m22 + l_mat.m23) * l_w;
    return GLKVector3Make(l_x, l_y, l_z);
}

-(Ray*) getPickRay :(float) screenX :(float) screenY :(float) viewportX :(float) viewportY :(float) viewportWidth :(float) viewportHeight {
    ray.origin = GLKVector3Make(screenX, screenY, 0);
    [self unproject:ray.origin :viewportX :viewportY :viewportWidth :viewportHeight];
    ray.direction = GLKVector3Make(screenX, screenY, 1);
    [self unproject:ray.direction :viewportX :viewportY :viewportWidth :viewportHeight];
    ray.direction = GLKVector3Subtract(ray.direction, ray.origin);
    ray.direction = GLKVector3Normalize(ray.direction);
    return ray;
}

-(Ray*) getPickRay :(float) screenX :(float) screenY {
    return [self getPickRay :screenX :screenY :0 :0 :[[UIScreen mainScreen] bounds].size.width :[[UIScreen mainScreen] bounds].size.height];
}


@end
