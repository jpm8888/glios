//
//  Color.m
//  glios
//
//  Created by Jitu JPM on 4/17/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "Color.h"


@implementation Color

/**
 Initialize color [0 - 1] with rgba component

 @param red color value in [0 - 1]
 @param green color value in [0 - 1]
 @param blue color value in [0 - 1]
 @param alpha color value in [0 - 1]
 @return new instance
 */
-(instancetype) init : (float) red : (float) green: (float) blue : (float) alpha{
    if (!self) self = [super init];
    self.r = red;
    self.g = green;
    self.b = blue;
    self.a = alpha;
    return self;
}

/**
 Constructs Colors using GLKVector3

 @param colors color vector3
 @return new instance
 */
-(instancetype) initUsingVector3 : (GLKVector3) colors{
    if (!self) self = [super init];
    return [self init : colors.r : colors.g : colors.b : 1];
}

-(instancetype) initUsingUIColor : (UIColor*) color{
    if (!self) self = [super init];
    const CGFloat *c = CGColorGetComponents(color.CGColor);
    return [self init : c[0] : c[1] : c[2] : c[3]];
}

/**
 Construct color with hex string eg. #FFFFFF

 @param color hex string
 @return new instance
 */
-(instancetype) initUsingHexString : (NSString*) color{
    const char *cStr = [color cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    unsigned char r, g, b;
    b = x & 0xFF;
    g = (x >> 8) & 0xFF;
    r = (x >> 16) & 0xFF;
    return [self init : r / 255.0f : g / 255.0f : b / 255.0f : 1];
}

@end
