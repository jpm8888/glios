//
//  GLUtil.h
//  GLKViewExample
//
//  Created by Jitu JPM on 2/10/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface GLUtil : NSObject

+(void) checkGlError :(const char*) op;
+(void) printGLString :(const char *) name :(GLenum) s;
+(void) LOG :(NSString*) TAG :(NSString *) msg;

@end
