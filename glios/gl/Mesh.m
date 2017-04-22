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
    ShaderProgram *program;
}

-(instancetype) init : (NSMutableArray *) attribs : (ShaderProgram *) shader{
    if (!self) self = [super init];
    attributes = attribs;
    VertexAttribute* pos = [attribs objectAtIndex:0];
    vertices_count = pos.length;
    program = shader;
    
    for (VertexAttribute * va in attribs) {
        va.shaderLocation = [program fetchAttributeLocation:va.name];
    }
    
    return self;
}

-(void) render: (GLint) primitiveType{
    for (VertexAttribute* va in attributes) {
        [program setVertexAttributeWithLocation:va.shaderLocation size:va.size type:va.type normalize:GL_FALSE stride:0 data:[va getVertices]];
        [program enableVertexAttributeWithLocation:va.shaderLocation];
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
