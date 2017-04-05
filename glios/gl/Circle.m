//
//  Circle.m
//  GLKViewExample
//
//  Created by Psi Gem on 04/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "Circle.h"

@implementation Circle
    
/** Constructs a new circle with the given X and Y coordinates and the given radius.
 *
 * @param x X coordinate
 * @param y Y coordinate
 * @param radius The radius of the circle */
-(instancetype) init :(float) x :(float) y :(float) radius {
    if (!self) self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
        self.radius = radius;
    }
    return self;
}

/** Constructs a new circle using a given {@link Vector2} that contains the desired X and Y coordinates, and a given radius.
 *
 * @param position The position {@link Vector2}.
 * @param radius The radius */
-(instancetype) init:(GLKVector2) position :(float) radius {
    if (!self) self = [super init];
    return [self init:position.x :position.y :radius];
}

/** Copy constructor
 *
 * @param circle The circle to construct a copy of. */
-(instancetype) init :(Circle*) circle {
    if (!self) self = [super init];
    return [self init:circle.x :circle.y :circle.radius];
}

/** Creates a new {@link Circle} in terms of its center and a point on its edge.
 *
 * @param center The center of the new circle
 * @param edge Any point on the edge of the given circle */
-(instancetype) initWithCentre :(GLKVector2) center edge:(GLKVector2) edge {
   if (!self) self = [super init];
    return [self init:center.x :center.y :(float)sqrt(pow(center.x - edge.x, 2) + pow(center.y - edge.y, 2))];
    return self;
}

/** Sets a new location and radius for this circle.
 *
 * @param x X coordinate
 * @param y Y coordinate
 * @param radius Circle radius */
-(void) setUsingX :(float) x Y:(float) y Radius:(float) radius {
    self.x = x;
    self.y = y;
    self.radius = radius;
}

/** Sets a new location and radius for this circle.
 *
 * @param position Position {@link Vector2} for this circle.
 * @param radius Circle radius */
-(void) setUsingPosition :(GLKVector2) position radius:(float) radius {
    self.x = position.x;
    self.y = position.y;
    self.radius = radius;
}

/** Sets a new location and radius for this circle, based upon another circle.
 *
 * @param circle The circle to copy the position and radius of. */
-(void) setUsingCircle :(Circle*) circle {
    self.x = circle.x;
    self.y = circle.y;
    self.radius = circle.radius;
}

/** Sets this {@link Circle}'s values in terms of its center and a point on its edge.
 *
 * @param center The new center of the circle
 * @param edge Any point on the edge of the given circle */
-(void) setUsingCentre :(GLKVector2) center :(GLKVector2) edge {
    self.x = center.x;
    self.y = center.y;
    self.radius = (float)sqrt(pow(center.x - edge.x, 2) + pow(center.y - edge.y, 2));
}

/** Sets the x and y-coordinates of circle center from vector
 * @param position The position vector */
-(void) setPosition :(GLKVector2) position {
    self.x = position.x;
    self.y = position.y;
}

/** Sets the x and y-coordinates of circle center
 * @param x The x-coordinate
 * @param y The y-coordinate */
-(void) setPositionWithX :(float) x Y:(float) y {
    self.x = x;
    self.y = y;
}

/** Checks whether or not this circle contains a given point.
 *
 * @param x X coordinate
 * @param y Y coordinate
 *
 * @return true if this circle contains the given point. */
-(BOOL) containsPointX :(float) x :(float) y {
    x = self.x - x;
    y = self.y - y;
    return x * x + y * y <= self.radius * self.radius;
}

/** Checks whether or not this circle contains a given point.
 *
 * @param point The {@link Vector2} that contains the point coordinates.
 *
 * @return true if this circle contains this point; false otherwise. */
-(BOOL) containsPoint :(GLKVector2) point {
    float dx = self.x - point.x;
    float dy = self.y - point.y;
    return dx * dx + dy * dy <= self.radius * self.radius;
}

/** @param c the other {@link Circle}
 * @return whether this circle contains the other circle. */
-(BOOL) containsCircle :(Circle*) c {
    const float radiusDiff = self.radius - c.radius;
    if (radiusDiff < 0.0f) return false; // Can't contain bigger circle
    const float dx = self.x - c.x;
    const float dy = self.y - c.y;
    const float dst = dx * dx + dy * dy;
    const float radiusSum = self.radius + c.radius;
    return (!(radiusDiff * radiusDiff < dst) && (dst < radiusSum * radiusSum));
}

/** @param c the other {@link Circle}
 * @return whether this circle overlaps the other circle. */
-(BOOL) overlaps :(Circle*) c {
    float dx = self.x - c.x;
    float dy = self.y - c.y;
    float distance = dx * dx + dy * dy;
    float radiusSum = self.radius + c.radius;
    return distance < radiusSum * radiusSum;
}

/** @return The circumference of this circle (as 2 * {@link MathUtils#PI2}) * {@code radius} */
-(float) circumference {
    return self.radius * M_PI;
}

/** @return The area of this circle (as {@link MathUtils#PI} * radius * radius). */
-(float) area {
    return self.radius * self.radius * M_PI;
}


@end
