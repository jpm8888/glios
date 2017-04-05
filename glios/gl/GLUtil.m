//
//  GLUtil.m
//  GLKViewExample
//
//  Created by Jitu JPM on 2/10/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "GLUtil.h"

@implementation GLUtil{
    
}

+(void) checkGlError :(const char*) op{
    for (GLint error = glGetError(); error; error= glGetError()) {
        NSLog(@"after %s() glError (0x%x)\n", op, error);
    }
}


+(void) printGLString :(const char *) name :(GLenum) s{
    const char *v = (const char *) glGetString(s);
    NSLog(@"GL %s = %s\n", name, v);
}


+(void) LOG :(NSString*) TAG :(NSString *) msg{
    NSLog(@"%@ :- %@",TAG , msg);
}

@end
