//
//  Mesh.h
//  glios
//
//  Created by Jitu JPM on 4/11/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShaderProgram.h"

@interface Mesh : NSObject



-(instancetype) init : (NSMutableArray *) attribs;
-(void) render : (ShaderProgram*) program : (GLint) primitiveType;
-(void) dispose;
@end
