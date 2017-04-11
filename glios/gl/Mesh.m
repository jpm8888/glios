//
//  Mesh.m
//  glios
//
//  Created by Jitu JPM on 4/11/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "Mesh.h"
#import "VertexAttributes.h"
#import "VertexAttribute.h"
#import "ShaderProgram.h"

@implementation Mesh{
    int vertices_length;
    VertexAttributes* attributes;
    float *vertices;
}

-(instancetype) init : (float*) verts : (int) verts_length : (VertexAttributes *) attribs{
    if (!self) self = [super init];
    vertices = verts;
    vertices_length = verts_length;
    attributes = attribs;
    return self;
}


-(void) render : (ShaderProgram*) program : (GLint) primitiveType{
    for (VertexAttribute* va in [attributes attributes]) {
        [program setVertexAttributeWithName:[[va alias] UTF8String] size:[va getSizeInBytes] type:[va type] normalize:[va normalized] stride:0 data:vertices];
        [program enableVertexAttributeWithName:[[va alias] UTF8String]];
    }
    glDrawArrays(primitiveType, 0, vertices_length);
}

-(void) dispose{
    
}

@end
