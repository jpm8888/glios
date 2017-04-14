//
//  GLUtil.m
//  GLKViewExample
//
//  Created by Jitu JPM on 2/10/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "GLUtil.h"

@implementation GLUtil
static BOOL debug = NO;

+(void) checkGlError :(const char*) op{
    if (!debug) return;
    for (GLint error = glGetError(); error; error= glGetError()) {
        NSLog(@"after %s() glError (0x%x)\n", op, error);
    }
}


+(void) printGLString :(const char *) name :(GLenum) s{
    if (!debug) return;
    const char *v = (const char *) glGetString(s);
    NSLog(@"GL %s = %s\n", name, v);
}


+(void) LOG :(NSString*) TAG :(NSString *) msg{
    if (!debug) return;
    NSLog(@"%@ :- %@",TAG , msg);
}

+(void)setDebug:(BOOL) val{
    debug = val;
}

@end
