//
//  Plane.m
//  glios
//
//  Created by Jitendra P Maindola on 01/05/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "Plane.h"

@implementation Plane{
    
}

+(float*) getVertices : (float) x : (float) y : (float) w : (float) h{
    float *vertices = (float *) calloc(2 * 4, sizeof(float));
    return [self updateVertices:vertices :x :y :w :h];
}

+(float*) getTextureCoordinates{
    float *texCoords = (float *) calloc(2 * 4, sizeof(float));
    int idx = 0;
    texCoords[idx++] = 0;
    texCoords[idx++] = 1;
    
    texCoords[idx++] = 0;
    texCoords[idx++] = 0;
    
    texCoords[idx++] = 1;
    texCoords[idx++] = 0;
    
    texCoords[idx++] = 1;
    texCoords[idx++] = 1;
    return texCoords;
}

+(float*) updateVertices : (float*) vertices : (float) x : (float) y : (float) w : (float) h{
    int idx = 0;
    vertices[idx++] = x;
    vertices[idx++] = y;
    vertices[idx++] = x;
    vertices[idx++] = y + h;
    vertices[idx++] = x + w;
    vertices[idx++] = y + h;
    vertices[idx++] = x + w;
    vertices[idx++] = y;
    return vertices;
}

@end
