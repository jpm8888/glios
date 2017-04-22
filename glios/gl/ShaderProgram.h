//
//  ShaderProgram.h
//  GLKViewExample
//
//  Created by Jitu JPM on 2/20/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "GLUtil.h"

@interface ShaderProgram : NSObject

extern NSString *const POSITION_ATTRIBUTE;
extern NSString *const NORMAL_ATTRIBUTE;
extern NSString *const COLOR_ATTRIBUTE;
extern NSString *const TEXCOORD_ATTRIBUTE;
extern NSString *const TANGENT_ATTRIBUTE;
extern NSString *const BINORMAL_ATTRIBUTE;
extern NSString *const BONEWEIGHT_ATTRIBUTE;

-(instancetype) init : (NSString*) vShaderFileName : (NSString*) fShaderFileName : (NSString*) type;
-(instancetype) init : (NSString*) vshader : (NSString*) fshader;

-(void) begin;
-(void) end;
-(void) dispose;
-(void) enableBlending;
-(void) disableBlending;

-(GLint) fetchAttributeLocation : (const char*) name;
-(GLint) fetchUniformLocation : (const char*) name;
-(void) setUniformiWithName :(const char*) name value:(GLint) value;
-(void) setUniformiWithLocation :(GLint) location value:(GLint) value;
-(void) setUniformiWithName :(const char*) name value1:(GLint) value1 value2:(GLint) value2;
-(void) setUniformiWithLocation :(GLint) location value1:(GLint) value1 value2:(GLint) value2;
-(void) setUniformiWithName :(const char*) name value1:(GLint) value1 value2:(GLint) value2 value3:(GLint) value3;
-(void) setUniformiWithLocation :(GLint) location value1:(GLint) value1 value2:(GLint) value2 value3:(GLint) value3;
-(void) setUniformiWithName :(const char*) name value1:(GLint) value1 value2:(GLint) value2 value3:(GLint) value3 value4:(GLint) value4;
-(void) setUniformiWithLocation :(GLint) location value1:(GLint) value1 value2:(GLint) value2 value3:(GLint) value3 value4:(GLint) value4;
-(void) setUniformfWithName :(const char*) name value:(GLfloat) value;
-(void) setUniformfWithLocation :(GLint) location value:(GLfloat) value;
-(void) setUniformfWithName:(const char*) name value1:(GLfloat) value1 value2:(GLfloat) value2;
-(void) setUniformfWithLocation :(GLint) location value1:(GLfloat) value1 value2:(GLfloat) value2;
-(void) setUniformfWithName :(const char*) name value1:(GLfloat) value1 value2:(GLfloat) value2 value3:(GLfloat) value3;
-(void) setUniformfWithLocation :(GLint) location value1:(GLfloat) value1 value2:(GLfloat) value2 value3:(GLfloat) value3;
-(void) setUniformfWithName :(const char*) name value1:(GLfloat) value1 value2:(GLfloat) value2 value3:(GLfloat) value3 value4:(GLfloat) value4;
-(void) setUniformfWithLocation :(GLint) location value1:(GLfloat) value1 value2:(GLfloat) value2 value3:(GLfloat) value3 value4:(GLfloat) value4;
-(void) setUniform1fvWithName :(const char*) name values:(GLfloat*) values length:(GLint) length;
-(void) setUniform1fvWithLocation :(GLint) location values:(GLfloat*) values length:(GLint) length;
-(void) setUniform2fvWithName :(const char*) name values:(GLfloat*) values length:(GLint) length;
-(void) setUniform2fvWithLocation :(GLint) location values:(GLfloat*) values length:(GLint) length;
-(void) setUniform3fvWithName :(const char*) name values:(GLfloat*) values length:(GLint) length;
-(void) setUniform3fvWithLocation :(GLint) location values:(GLfloat*) values length:(GLint) length;
-(void) setUniform4fvWithName :(const char*) name values:(GLfloat*) values length:(GLint) length;
-(void) setUniform4fvWithLocation :(GLint) location values:(GLfloat*) values length:(GLint) length;


// GLmatrix
-(void) setUniformMatrixWithName :(const char*) name withMatrix4:(GLKMatrix4) value transpose:(GLboolean) transpose;
-(void) setUniformMatrixWithLocation :(GLint) location withMatrix4:(GLKMatrix4) value;
-(void) setUniformfWithName :(const char*) name withVector2:(GLKVector2) value;
-(void) setUniformfWithLocation :(GLint) location withVector2:(GLKVector2) value;
-(void) setUniformfWithName :(const char*) name withVector3:(GLKVector3) value;
-(void) setUniformfWithLocation :(GLint) location withVector3:(GLKVector3) value;
-(void) setVertexAttributeWithName :(const char*) name size:(GLint) size type:(GLint) type normalize:(GLboolean) normalize stride:(GLint) stride data:(GLvoid*) data;

-(void) setVertexAttributeWithLocation :(GLint) location size:(GLint) size type:(GLint) type normalize:(GLboolean) normalize stride:(GLint) stride data:(GLvoid*) data;
-(void) disableVertexAttributeWithName :(const char*) name;
-(void) disableVertexAttributeWithLocation :(GLint) location;
-(void) enableVertexAttributeWithName :(const char*) name;
-(void) enableVertexAttributeWithLocation :(GLint) location;
-(void) setAttributefWithName :(const char*) name value1:(GLfloat) value1 value2:(GLfloat) value2 value3:(GLfloat) value3 value4:(GLfloat) value4;

@end
