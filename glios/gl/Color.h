//
//  Color.h
//  glios
//
//  Created by Jitu JPM on 4/17/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Color : NSObject
@property float r, g, b, a;

-(instancetype) init : (float) red : (float) green: (float) blue : (float) alpha;
-(instancetype) init : (GLKVector3) colors;
@end
