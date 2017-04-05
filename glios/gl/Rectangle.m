//
//  Rectangle.m
//  GLKViewExample
//
//  Created by Psi Gem on 04/04/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle
    
    /** Constructs a new rectangle with the given corner point in the bottom left and dimensions.
     * @param x The corner point x-coordinate
     * @param y The corner point y-coordinate
     * @param width The width
     * @param height The height */
-(instancetype) init :(float) x :(float) y :(float) width :(float) height {
    if (!self) self = [super init];
    if (self) {
        self.tmp = [Rectangle new];
        self.tmp2 = [Rectangle new];
        self.x = x;
        self.y = y;
        self.width = width;
        self.height = height;
    }
    return self;
}
    
    /** Constructs a rectangle based on the given rectangle
     * @param rect The rectangle */
-(instancetype) init :(Rectangle*) rect {
    if (!self) self = [super init];
    return [self init:rect.x :rect.y :rect.width :rect.height];
}
    
    /** @param x bottom-left x coordinate
     * @param y bottom-left y coordinate
     * @param width width
     * @param height height
     * @return this rectangle for chaining */
-(Rectangle*) set :(float) x :(float) y :(float) width :(float) height {
        self.x = x;
        self.y = y;
        self.width = width;
        self.height = height;
        
    return self;
    }
    
    /** @return the x-coordinate of the bottom left corner */
    -(float) getX {
        return self.x;
    }
    
    /** Sets the x-coordinate of the bottom left corner
     * @param x The x-coordinate
     * @return this rectangle for chaining */
-(Rectangle*) setValueX :(float) x {
        self.x = x;
        
    return self;
}
    
    /** @return the y-coordinate of the bottom left corner */
    -(float) getY {
        return self.y;
    }
    
    /** Sets the y-coordinate of the bottom left corner
     * @param y The y-coordinate
     * @return this rectangle for chaining */
-(Rectangle*) setValueY :(float) y {
        self.y = y;
        
        return self;
    }
    
    /** @return the width */
-(float) getWidth {
        return self.width;
}
    
    /** Sets the width of this rectangle
     * @param width The width
     * @return this rectangle for chaining */
-(Rectangle*) setValueWidth :(float) width {
        self.width = width;
        
        return self;
}
    
    /** @return the height */
-(float) getHeight {
        return self.height;
}
    
    /** Sets the height of this rectangle
     * @param height The height
     * @return this rectangle for chaining */
-(Rectangle*) setValueHeight :(float) height {
        self.height = height;
        
        return self;
}
    
    /** return the Vector2 with coordinates of this rectangle
     * @param position The Vector2 */
-(GLKVector2) getPosition :(GLKVector2) position {
    return position = GLKVector2Make(self.x, self.y);
}
    
    /** Sets the x and y-coordinates of the bottom left corner from vector
     * @param position The position vector
     * @return this rectangle for chaining */
-(Rectangle*) setPosition :(GLKVector2) position {
        self.x = position.x;
        self.y = position.y;
        
        return self;
}
    
    /** Sets the x and y-coordinates of the bottom left corner
     * @param x The x-coordinate
     * @param y The y-coordinate
     * @return this rectangle for chaining */
-(Rectangle*) setPosition :(float) x :(float) y {
        self.x = x;
        self.y = y;
        
        return self;
}
    
    /** Sets the width and height of this rectangle
     * @param width The width
     * @param height The height
     * @return this rectangle for chaining */
-(Rectangle*) setSize :(float) width :(float) height {
        self.width = width;
        self.height = height;
        
        return self;
}
    
    /** Sets the squared size of this rectangle
     * @param sizeXY The size
     * @return this rectangle for chaining */
-(Rectangle*) setSize :(float) sizeXY {
        self.width = sizeXY;
        self.height = sizeXY;
        
        return self;
}
    
    /** @return the Vector2 with size of this rectangle
     * @param size The Vector2 */
-(GLKVector2) getSize :(GLKVector2) size {
    return size = GLKVector2Make(self.width, self.height);
}
    
    /** @param x point x coordinate
     * @param y point y coordinate
     * @return whether the point is contained in the rectangle */
-(BOOL) contains :(float) x :(float) y {
        return self.x <= x && self.x + self.width >= x && self.y <= y && self.y + self.height >= y;
    }
    
    /** @param point The coordinates vector
     * @return whether the point is contained in the rectangle */
-(BOOL) containsPoint :(GLKVector2) point {
    return [self contains :point.x :point.y];
    }
    
    /** @param circle the circle
     * @return whether the circle is contained in the rectangle */
-(BOOL) containsCircle :(Circle*) circle {
        return (circle.x - circle.radius >= self.x) && (circle.x + circle.radius <= self.x + self.width)
        && (circle.y - circle.radius >= self.y) && (circle.y + circle.radius <= self.y + self.height);
    }

    /** @param rectangle the other {@link Rectangle}.
     * @return whether the other rectangle is contained in this rectangle. */
-(BOOL) containsRectangle :(Rectangle*) rectangle {
        float xmin = rectangle.x;
        float xmax = xmin + rectangle.width;
        
        float ymin = rectangle.y;
        float ymax = ymin + rectangle.height;
        
        return ((xmin > self.x && xmin < self.x + self.width) && (xmax > self.x && xmax < self.x + self.width))
        && ((ymin > self.y && ymin < self.y + self.height) && (ymax > self.y && ymax < self.y + self.height));
    }
    
    /** @param r the other {@link Rectangle}
     * @return whether this rectangle overlaps the other rectangle. */
-(BOOL) overlaps :(Rectangle*) r {
        return self.x < r.x + r.width && self.x + self.width > r.x && self.y < r.y + r.height && self.y + self.height > r.y;
    }
    
    /** Sets the values of the given rectangle to this rectangle.
     * @param rect the other rectangle
     * @return this rectangle for chaining */
-(Rectangle*) set :(Rectangle*) rect {
        self.x = rect.x;
        self.y = rect.y;
        self.width = rect.width;
        self.height = rect.height;
        
        return self;
    }


    /** Calculates the aspect ratio ( width / height ) of this rectangle
     * @return the aspect ratio of this rectangle. Returns Float.NaN if height is 0 to avoid ArithmeticException */
    -(float) getAspectRatio {
        return (self.height == 0) ? NAN : self.width / self.height;
    }
    
    /** Calculates the center of the rectangle. Results are located in the given Vector2
     * @param vector the Vector2 to use
     * @return the given vector with results stored inside */
-(GLKVector2) getCenter :(GLKVector2) vector {
        vector.x = self.x + self.width / 2;
        vector.y = self.y + self.height / 2;
        return vector;
    }
    
    /** Moves this rectangle so that its center point is located at a given position
     * @param x the position's x
     * @param y the position's y
     * @return this for chaining */
-(Rectangle*) setCenter :(float) x :(float) y {
    [self setPosition :x - self.width / 2 :y - self.height / 2];
        return self;
    }
    
    /** Moves this rectangle so that its center point is located at a given position
     * @param position the position
     * @return this for chaining */
-(Rectangle*) setCenter :(GLKVector2) position {
    [self setPosition :position.x - self.width / 2 :position.y - self.height / 2];
        return self;
    }
    
    /** Fits this rectangle around another rectangle while maintaining aspect ratio. This scales and centers the rectangle to the
     * other rectangle (e.g. Having a camera translate and scale to show a given area)
     * @param rect the other rectangle to fit this rectangle around
     * @return this rectangle for chaining
     * @see Scaling */
-(Rectangle*) fitOutside :(Rectangle*) rect {
        float ratio = [self getAspectRatio];
        
        if (ratio > [rect getAspectRatio]) {
            // Wider than tall
            [self setSize :rect.height * ratio :rect.height];
        } else {
            // Taller than wide
            [self setSize :rect.width :rect.width / ratio];
        }
        
    [self setPosition: (rect.x + rect.width / 2) - self.width / 2 :(rect.y + rect.height / 2) - self.height / 2];
        return self;
    }
    
    /** Fits this rectangle into another rectangle while maintaining aspect ratio. This scales and centers the rectangle to the
     * other rectangle (e.g. Scaling a texture within a arbitrary cell without squeezing)
     * @param rect the other rectangle to fit this rectangle inside
     * @return this rectangle for chaining
     * @see Scaling */
-(Rectangle*) fitInside :(Rectangle*) rect {
        float ratio = [self getAspectRatio];
        
        if (ratio < [rect getAspectRatio]) {
            // Taller than wide
            [self setSize :rect.height * ratio :rect.height];
        } else {
            // Wider than tall
            [self setSize :rect.width :rect.width / ratio];
        }
        
    [self setPosition :(rect.x + rect.width / 2) - self.width / 2 :(rect.y + rect.height / 2) - self.height / 2];
        return self;
    }


-(float) area {
    return self.width * self.height;
}

-(float) perimeter {
    return 2 * (self.width + self.height);
}

@end
