//
//  VertexAttribute.h
//  glios
//
//  Created by Jitu JPM on 4/13/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLUtil.h"

@interface VertexAttribute : NSObject{
    GLfloat *vertices; //vertex array    
}

@property GLint type; //GL_FLOAT, GL_UNSIGNED_BYTE
@property GLint size; // 2 in case of position, 4 in color etc.
@property GLint length; // number of vertex
@property const char *name; // alias
@property GLint shaderLocation;


-(instancetype) init : (GLint) type : (GLint) size : (GLint) length : (GLfloat*) verts : (NSString*) nameInShader;
-(GLfloat*) getVertices;
-(void) dispose;
@end
