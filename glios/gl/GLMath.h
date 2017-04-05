//
//  GLMath.h
//  GLKViewExample
//
//  Created by Jitu JPM on 2/10/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define nanoToSec 1 / 1000000000f

#define FLOAT_ROUNDING_ERROR  0.000001f // 32 bits
#define PI  3.1415927f
#define PI2  PI * 2
#define E  2.7182818f

#define SIN_BITS = 14 // 16KB. Adjust for accuracy.
#define SIN_MASK  ~(-1 << SIN_BITS)
#define SIN_COUNT  SIN_MASK + 1

#define radFull  PI * 2
#define degFull  360
#define radToIndex SIN_COUNT / radFull
#define degToIndex SIN_COUNT / degFull

/** multiply by this to convert from radians to degrees */
#define radiansToDegrees 180.0 / PI
#define radDeg radiansToDegrees
/** multiply by this to convert from degrees to radians */
#define degreesToRadians PI / 180.0

#define BIG_ENOUGH_INT 16 * 1024
#define BIG_ENOUGH_FLOOR BIG_ENOUGH_INT
#define CEIL 0.9999999
#define BIG_ENOUGH_CEIL  16384.999999999996
#define BIG_ENOUGH_ROUND  BIG_ENOUGH_INT + 0.5f


@interface GLMath : NSObject

+(int) nextPowerOfTwo :(int) value;
+(bool) isPowerOfTwo  :(int) value;
+(int) clampInteger :(int) value :(int) min :(int) max;
+(short) clampShort :(short) value :(short) min :(short) max;
+(float) clampFloat :(float) value :(float) min :(float) max;
+(float) lerp :(float) fromValue :(float) toValue :(float) progress;
+(int) floor :(float)  x;
+(int) floorPositive :(float) x;
+(int) ceil :(float) x;
+(int) ceilPositive :(float) x;
+(int) round :(float) x;
+(int) roundPositive :(float) x;
+(bool) isZero :(float) value;
+(bool) isZero :(float) value : (float) tolerance;
+(bool) isEqual :(float) a :(float) b;
+(bool) isEqual :(float) a :(float) b :(float) tolerance;
+(float) logToBase :(float) a :(float) x ;

@end
