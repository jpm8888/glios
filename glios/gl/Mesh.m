//
//  Mesh.m
//  glios
//
//  Created by Jitu JPM on 4/11/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "Mesh.h"
#import "VertexAttribute.h"

@implementation Mesh{
    NSMutableArray * attributes;
    int vertices_count;
}

-(instancetype) init : (NSMutableArray *) attribs{
    if (!self) self = [super init];
    attributes = attribs;
    VertexAttribute* pos = [attribs objectAtIndex:0];
    vertices_count = pos.length;
    return self;
}





-(void) render : (ShaderProgram*) program : (GLint) primitiveType{
    for (VertexAttribute* va in attributes) {
        [program setVertexAttributeWithName:va.name size:va.size type:va.type normalize:GL_FALSE stride:0 data:va.getVertices];
        [program enableVertexAttributeWithName:va.name];
    }
    glDrawArrays(primitiveType, 0, vertices_count);
}

-(void) dispose{
    for (VertexAttribute *va in attributes) {
        [va dispose];
    }
    [attributes removeAllObjects];
    attributes = nil;
}



@end
