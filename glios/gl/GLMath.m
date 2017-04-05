//
//  GLMath.m
//  GLKViewExample
//
//  Created by Jitu JPM on 2/10/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "GLMath.h"

@implementation GLMath{
    
}

+(int) nextPowerOfTwo :(int) value{
    if (value == 0) return 1;
    value--;
    value |= value >> 1;
    value |= value >> 2;
    value |= value >> 4;
    value |= value >> 8;
    value |= value >> 16;
    return value + 1;
}
+(bool) isPowerOfTwo :(int) value{
    return value != 0 && (value & value - 1) == 0;
}

+(int) clampInteger :(int) value :(int) min :(int) max{
    if (value < min) return min;
    if (value > max) return max;
    return value;
}

+(short) clampShort :(short) value :(short) min :(short) max{
    if (value < min) return min;
    if (value > max) return max;
    return value;
}

+(float) clampFloat :(float) value :(float) min :(float) max{
    if (value < min) return min;
    if (value > max) return max;
    return value;
}


/** Linearly interpolates between fromValue to toValue on progress position. */
+(float) lerp  :(float) fromValue :(float) toValue :(float) progress{
    return fromValue + (toValue - fromValue) * progress;
}

/** Returns the largest integer less than or equal to the specified float. This method will only properly floor floats from
 * -(2^14) to (Float.MAX_VALUE - 2^14). */
+(int) floor :(float)  x{
    return (int)(x + BIG_ENOUGH_FLOOR) - BIG_ENOUGH_INT;
}

/** Returns the largest integer less than or equal to the specified float. This method will only properly floor floats that are
 * positive. Note this method simply casts the float to int. */
+(int) floorPositive :(float) x{
    return (int)x;
    
}

/** Returns the smallest integer greater than or equal to the specified float. This method will only properly ceil floats from
 * -(2^14) to (Float.MAX_VALUE - 2^14). */
+(int) ceil :(float) x{
    return (int)(x + BIG_ENOUGH_CEIL) - BIG_ENOUGH_INT;
}

/** Returns the smallest integer greater than or equal to the specified float. This method will only properly ceil floats that
 * are positive. */
+(int) ceilPositive :(float) x{
    return (int)(x + CEIL);
}

/** Returns the closest integer to the specified float. This method will only properly round floats from -(2^14) to
 * (Float.MAX_VALUE - 2^14). */
+(int) round :(float) x{
    return (int)(x + BIG_ENOUGH_ROUND) - BIG_ENOUGH_INT;
}

/** Returns the closest integer to the specified float. This method will only properly round floats that are positive. */
+(int) roundPositive :(float) x{
    return (int)(x + 0.5f);
}

/** Returns true if the value is zero (using the default tolerance as upper bound) */
+(bool) isZero :(float) value{
    return fabsf(value) <= FLOAT_ROUNDING_ERROR;
}

/** Returns true if the value is zero.
 * @param tolerance represent an upper bound below which the value is considered zero. */
+(bool) isZero :(float) value :(float) tolerance{
    return fabsf(value) <= tolerance;
}

/** Returns true if a is nearly equal to b. The function uses the default floating error tolerance.
 * @param a the first value.
 * @param b the second value. */
+(bool) isEqual :(float) a : (float) b{
    return fabsf(a - b) <= FLOAT_ROUNDING_ERROR;
}

/** Returns true if a is nearly equal to b.
 * @param a the first value.
 * @param b the second value.
 * @param tolerance represent an upper bound below which the two values are considered equal. */
+(bool) isEqual :(float) a : (float) b :(float) tolerance{
    return fabsf(a - b) <= tolerance;
}

/**@return the logarithm of x with base a */
+(float) logToBase :(float) a : (float) x{
    return (float)(log(x) / log(a));
}

@end
