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
-(instancetype) init : (GLKVector3) colors{
    if (!self) self = [super init];
    return [self init : colors.r : colors.g : colors.b : 1];
}


@end
