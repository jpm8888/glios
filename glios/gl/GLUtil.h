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
#import <UIKit/UIKit.h>

@interface GLUtil : NSObject{
    
    
}
@property (class, nonatomic, assign) BOOL debug;
+(void) checkGlError :(const char*) op;
+(void) printGLString :(const char *) name :(GLenum) s;
+(void) LOG :(NSString*) TAG :(NSString *) msg;
+(UIImage*) getUIImage : (int) width : (int) height;
@end
