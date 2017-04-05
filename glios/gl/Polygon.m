//
//  Polygon.m
//  GLKViewExample
//
//  Created by Psi Gem on 04/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "Polygon.h"

@implementation Polygon{
    
}

BOOL dirty = true;
Rectangle *bounds;

/** Constructs a new polygon with no vertices. */
//    public Polygon () {
//        this.localVertices = new float[0];
//    }

-(instancetype) init {
    self = [super init];
    if (self) {
        self.scaleX = 1.0;
        self.scaleY = 1.0;
    }
    return self;
}

/** Constructs a new polygon from a float array of parts of vertex points.
 *
 * @param vertices an array where every even element represents the horizontal part of a point, and the following element
 *           representing the vertical part
 *
 * @throws IllegalArgumentException if less than 6 elements, representing 3 points, are provided */
-(instancetype) init :(float[]) vertices :(int) size {
    if (!self) self = [super init];
    if (size < 6) NSLog(@"polygons must contain at least 3 points.");
    localVertices = vertices;
    self.size = size;
    return self;
}

/** Returns the polygon's local vertices without scaling or rotation and without being offset by the polygon position. */
-(float*) getVertices {
    return localVertices;
}

/** Calculates and returns the vertices of the polygon after scaling, rotation, and positional translations have been applied,
 * as they are position within the world.
 *
 * @return vertices scaled, rotated, and offset by the polygon position. */
-(float*) getTransformedVertices {
    if (!dirty) return worldVertices;
    dirty = false;
    
    const float* lv = localVertices;
    if (worldVertices == NULL ||) worldVertices = new float[self.size];
    
    const float* wv = worldVertices;
    const float positionX = self.x;
    const float positionY = self.y;
    const float originX = self.originX;
    const float originY = self.originY;
    const float scaleX = self.scaleX;
    const float scaleY = self.scaleY;
    const BOOL scale = scaleX != 1 || scaleY != 1;
    const float rotation = self.rotation;
    const float cos = MathUtils.cosDeg(rotation);
    const float sin = MathUtils.sinDeg(rotation);
    for (int i = 0, n = lv.length; i < n; i += 2) {
        float x = localVertices[i] - originX;
        float y = localVertices[i + 1] - originY;
        
        // scale if needed
        if (scale) {
            x *= scaleX;
            y *= scaleY;
        }
        
        // rotate if needed
        if (rotation != 0) {
            float oldX = x;
            x = cos * x - sin * y;
            y = sin * oldX + cos * y;
        }
        
        wv[i] = positionX + x + originX;
        wv[i + 1] = positionY + y + originY;
    }
    return wv;
}

/** Sets the origin point to which all of the polygon's local vertices are relative to. */
-(void) setOriginX :(float) originX Y:(float) originY {
    self.originX = originX;
    self.originY = originY;
    dirty = true;
}

/** Sets the polygon's position within the world. */
-(void) setPositionX :(float) x :(float) y {
    self.x = x;
    self.y = y;
    dirty = true;
}

/** Sets the polygon's local vertices relative to the origin point, without any scaling, rotating or translations being applied.
 *
 * @param vertices float array where every even element represents the x-coordinate of a vertex, and the proceeding element
 *           representing the y-coordinate.
 * @throws IllegalArgumentException if less than 6 elements, representing 3 points, are provided */
-(void) setVertices :(float[]) vertices: (int) size {
    if (size < 6)
        NSLog(@"polygons must contain at least 3 points.");
    localVertices = vertices;
    dirty = true;
}

/** Translates the polygon's position by the specified horizontal and vertical amounts. */
-(void) translate :(float) x :(float) y {
    self.x += x;
    self.y += y;
    dirty = true;
}

/** Sets the polygon to be rotated by the supplied degrees. */
-(void) setRotation :(float) degrees {
    self.rotation = degrees;
    dirty = true;
}

/** Applies additional rotation to the polygon by the supplied degrees. */
-(void) rotate :(float) degrees {
    self.rotation += degrees;
    dirty = true;
}

/** Sets the amount of scaling to be applied to the polygon. */
-(void) setScale :(float) scaleX :(float) scaleY {
    self.scaleX = scaleX;
    self.scaleY = scaleY;
    dirty = true;
}

/** Applies additional scaling to the polygon by the supplied amount. */
-(void) scale :(float) amount {
    self.scaleX += amount;
    self.scaleY += amount;
    dirty = true;
}

/** Sets the polygon's world vertices to be recalculated when calling {@link #getTransformedVertices() getTransformedVertices}. */
-(void) dirty {
    dirty = true;
}

/** Returns the area contained within the polygon. */
-(float) area {
    float *vertices = [self getTransformedVertices];
    return [self polygonArea:vertices :0 : self.size];
}

-(float) polygonArea :(float[]) polygon :(int) offset :(int) count {  // private
    float area = 0;
    for (int i = offset, n = offset + count; i < n; i += 2) {
        int x1 = i;
        int y1 = i + 1;
        int x2 = (i + 2) % n;
        if (x2 < offset) x2 += offset;
        int y2 = (i + 3) % n;
        if (y2 < offset) y2 += offset;
        area += polygon[x1] * polygon[y2];
        area -= polygon[x2] * polygon[y1];
    }
    area *= 0.5f;
    return area;
}

/** Returns an axis-aligned bounding box of this polygon.
 *
 * Note the returned Rectangle is cached in this polygon, and will be reused if this Polygon is changed.
 *
 * @return this polygon's bounding box {@link Rectangle} */
-(Rectangle*) getBoundingRectangle {
    float *vertices = [self getTransformedVertices];
    
    float minX = vertices[0];
    float minY = vertices[1];
    float maxX = vertices[0];
    float maxY = vertices[1];
    
    const int numFloats = vertices.length;
    for (int i = 2; i < numFloats; i += 2) {
        minX = minX > vertices[i] ? vertices[i] : minX;
        minY = minY > vertices[i + 1] ? vertices[i + 1] : minY;
        maxX = maxX < vertices[i] ? vertices[i] : maxX;
        maxY = maxY < vertices[i + 1] ? vertices[i + 1] : maxY;
    }
    
    if (bounds == null) bounds = new Rectangle();
    bounds.x = minX;
    bounds.y = minY;
    bounds.width = maxX - minX;
    bounds.height = maxY - minY;
    
    return bounds;
}

/** Returns whether an x, y pair is contained within the polygon. */
//    @Override
-(BOOL) containsX :(float) x Y:(float) y {
    const float[] vertices = getTransformedVertices();
    const int numFloats = vertices.length;
    int intersects = 0;
    
    for (int i = 0; i < numFloats; i += 2) {
        float x1 = vertices[i];
        float y1 = vertices[i + 1];
        float x2 = vertices[(i + 2) % numFloats];
        float y2 = vertices[(i + 3) % numFloats];
        if (((y1 <= self.y && self.y < y2) || (y2 <= self.y && self.y < y1)) && self.x < ((x2 - x1) / (y2 - y1) * (self.y - y1) + x1)) intersects++;
    }
    return (intersects & 1) == 1;
}

//    @Override
-(BOOL) containsPoint :(GLKVector2) point {
    return [self containsX:point.x Y:point.y];
}


@end
