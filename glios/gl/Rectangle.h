//
//  Rectangle.h
//  GLKViewExample
//
//  Created by Psi Gem on 04/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Circle.h"

@interface Rectangle : NSObject

/** Static temporary rectangle. Use with care! Use only when sure other code will not also use this. */
@property const Rectangle *tmp;

/** Static temporary rectangle. Use with care! Use only when sure other code will not also use this. */
@property const Rectangle *tmp2;

@property (nonatomic) float x, y;
@property (nonatomic) float width, height;


-(instancetype) init :(float) x :(float) y :(float) width :(float) height;
-(instancetype) init :(Rectangle*) rect;
-(Rectangle*) set :(float) x :(float) y :(float) width :(float) height;
-(float) getX;
-(Rectangle*) setValueX :(float) x;
-(float) getY;
-(Rectangle*) setValueY :(float) y;
-(float) getWidth;
-(Rectangle*) setValueWidth :(float) width;
-(float) getHeight;
-(Rectangle*) setValueHeight :(float) height;
-(GLKVector2) getPosition :(GLKVector2) position;
-(Rectangle*) setPosition :(GLKVector2) position;
-(Rectangle*) setPosition :(float) x :(float) y;
-(Rectangle*) setSize :(float) width :(float) height;
-(Rectangle*) setSize :(float) sizeXY;
-(GLKVector2) getSize :(GLKVector2) size;
-(BOOL) contains :(float) x :(float) y;
-(BOOL) containsPoint :(GLKVector2) point;
-(BOOL) containsCircle :(Circle*) circle;
-(BOOL) containsRectangle :(Rectangle*) rectangle;
-(BOOL) overlaps :(Rectangle*) r;
-(Rectangle*) set :(Rectangle*) rect;
-(float) getAspectRatio;
-(GLKVector2) getCenter :(GLKVector2) vector;
-(Rectangle*) setCenter :(float) x :(float) y;
-(Rectangle*) setCenter :(GLKVector2) position;
-(Rectangle*) fitOutside :(Rectangle*) rect;
-(Rectangle*) fitInside :(Rectangle*) rect;
-(float) area;
-(float) perimeter;


@end
