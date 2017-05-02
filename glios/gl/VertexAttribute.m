//
//  VertexAttribute.m
//  glios
//
//  Created by Jitu JPM on 4/13/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "VertexAttribute.h"

@implementation VertexAttribute

-(instancetype) init : (GLint) type : (GLint) size:(GLint) length : (GLfloat*) verts : (NSString*) nameInShader{
    if (!self) self = [super init];
    self.type = type;
    self.length = length / 2;
    self.size = size;
    vertices = verts;
    self.name = [nameInShader UTF8String];
    return self;
}

-(GLfloat*) getVertices{
    return vertices;
}

-(void) dispose{
    free(vertices);
    vertices = nil;
}


@end
