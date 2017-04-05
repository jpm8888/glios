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
    
-(instancetype) initOrthographicCamera {
    self = [super init];
    if (self) {
        self.near = 0;
        self.zoom = 1;
        tmp = GLKVector3Make(0, 0, 0);
    }
    return self;
}

/** Constructs a new OrthographicCamera, using the given viewport width and height. For pixel perfect 2D rendering just supply
 * the screen size, for other unit scales (e.g. meters for box2d) proceed accordingly. The camera will show the region
 * [-viewportWidth/2, -(viewportHeight/2-1)] - [(viewportWidth/2-1), viewportHeight/2]
 * @param viewportWidth the viewport width
 * @param viewportHeight the viewport height */
-(instancetype) initOrthographicCamera :(float) viewportWidth :(float) viewportHeight {
    self = [super init];
    if (self) {
        self.viewportWidth = viewportWidth;
        self.viewportHeight = viewportHeight;
        self.near = 0;
        [self update];
    }
    return self;
}

//    private final Vector3 tmp = new Vector3();

//    @Override
-(void) update {
    [self update :true];
}

//    @Override
-(void) update :(BOOL) updateFrustum {
    
    self.projection = GLKMatrix4MakeOrtho(self.zoom * -self.viewportWidth / 2, self.zoom * (self.viewportWidth / 2),  self.zoom * -(self.viewportHeight / 2), self.zoom * self.viewportHeight / 2, self.near, self.far);
    
//    
//        view.setToLookAt(position, tmp.set(position).add(direction), up);
//    
//        self.combined = self.projection;
//    
//        Matrix4.mul(combined.val, view.val);
//    
//            if (updateFrustum) {
//                invProjectionView.set(combined);
//                Matrix4.inv(invProjectionView.val);
//                frustum.update(invProjectionView);
//            }
}

/** Sets this camera to an orthographic projection using a viewport fitting the screen resolution, centered at
 * (Gdx.graphics.getWidth()/2, Gdx.graphics.getHeight()/2), with the y-axis pointing up or down.
 * @param yDown whether y should be pointing down */
-(void) setToOrtho :(BOOL) yDown {
    [self setToOrtho:yDown :[[UIScreen mainScreen] bounds].size.width :[[UIScreen mainScreen] bounds].size.height];
}

/** Sets this camera to an orthographic projection, centered at (viewportWidth/2, viewportHeight/2), with the y-axis pointing up
 * or down.
 * @param yDown whether y should be pointing down.
 * @param viewportWidth
 * @param viewportHeight */
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

/** Rotates the camera by the given angle around the direction vector. The direction and up vector will not be orthogonalized.
 * @param angle */
-(void) rotate :(float) angle {
    [self rotate :self.direction :angle];
}

/** Moves the camera by the given amount on each axis.
 * @param x the displacement on the x-axis
 * @param y the displacement on the y-axis */
-(void) translate :(float) x :(float) y {
    [self translate :x :y :0];
}

/** Moves the camera by the given vector.
 * @param vec the displacement vector */
-(void) translate :(GLKVector2) vec {
    [self translate :vec.x :vec.y :0];
}


@end
