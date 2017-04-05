//
//  Polygon.h
//  GLKViewExample
//
//  Created by Psi Gem on 04/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rectangle.h"
#import "math.h"

@interface Polygon : NSObject {
    NSArray* localVertices;
    NSArray* worldVertices;
}

@property int size;
@property float x, y;
@property float originX, originY;
@property float rotation;
@property float scaleX, scaleY;

-(instancetype) initPolygon;
//public Polygon (float[] vertices);
//public float[] getVertices ();
//public float[] getTransformedVertices;
-(void) setOriginX :(float) originX Y:(float) originY;
-(void) setPositionX :(float) x :(float) y;
-(void) setVertices :(float[]) vertices;
-(void) translate :(float) x :(float) y;
-(void) setRotation :(float) degrees;
-(void) rotate :(float) degrees;
-(void) setScale :(float) scaleX :(float) scaleY;
-(void) scale :(float) amount;
-(void) dirty;
-(float) area;
-(Rectangle*) getBoundingRectangle;
-(BOOL) containsX :(float) x Y:(float) y;

-(BOOL) containsPoint :(GLKVector2) point;

@end
