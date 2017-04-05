//
//  Circle.h
//  GLKViewExample
//
//  Created by Psi Gem on 04/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Circle : NSObject

@property float x, y;
@property float radius;

-(instancetype) init :(float) x :(float) y :(float) radius;
-(instancetype) init:(GLKVector2) position :(float) radius;
-(instancetype) init:(Circle*) circle;
-(instancetype) initWithCentre :(GLKVector2) center edge:(GLKVector2) edge;
-(void) setUsingX :(float) x Y:(float) y Radius:(float) radius;
-(void) setUsingPosition :(GLKVector2) position radius:(float) radius;
-(void) setUsingCircle :(Circle*) circle;
-(void) setUsingCentre :(GLKVector2) center :(GLKVector2) edge;
-(void) setPosition :(GLKVector2) position;
-(void) setPositionWithX :(float) x Y:(float) y;
-(BOOL) containsPointX :(float) x :(float) y;
-(BOOL) containsPoint :(GLKVector2) point;
-(BOOL) containsCircle :(Circle*) c;
-(BOOL) overlaps :(Circle*) c;
-(float) circumference;
-(float) area;

@end
