//
//  Plane.h
//  glios
//
//  Created by Jitendra P Maindola on 01/05/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plane : NSObject
+(float*) getVertices : (float) x : (float) y : (float) w : (float) h;
+(float*) getTextureCoordinates;
+(float*) updateVertices : (float*) vertices : (float) x : (float) y : (float) w : (float) h;

@end
