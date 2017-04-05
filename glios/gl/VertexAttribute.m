//
//  VertexAttribute.m
//  GLKViewExample
//
//  Created by Jitu JPM on 3/31/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "VertexAttribute.h"
#import "ShaderProgram.h"

@implementation VertexAttribute{
    
}

-(instancetype) init : (Usage) usage components : (GLint) numComponents ofType : (GLint) type isNormalized : (GLboolean) normalized ofAlias : (NSString*) alias ofUnit : (GLint) unit{
    if (!self) self = [super init];
    self.usage = usage;
    self.numComponents = numComponents;
    self.type = type;
    self.normalized = normalized;
    self.alias = alias;
    self.unit = unit;
    return self;
}


-(instancetype) init : (Usage) usage components:(GLint)numComponents ofType:(GLint)type isNormalized:(GLboolean)normalized ofAlias:(NSString *)alias{
    if (!self) self = [super init];
    return [self init:usage components:numComponents ofType:type isNormalized:normalized ofAlias:alias ofUnit:0];
}

-(instancetype) init : (Usage) usage components : (GLint) numComponents ofAlias : (NSString*) alias ofUnit : (GLint) unit{
    if (!self) self = [super init];
    GLint type = (usage == ColorPacked) ? GL_UNSIGNED_BYTE : GL_FLOAT;
    GLboolean normalized = (usage == ColorPacked);
    return [self init:usage components:numComponents ofType:type isNormalized:normalized ofAlias:alias ofUnit:unit];
    
}

-(instancetype) init : (Usage) usage components:(GLint)numComponents ofAlias:(NSString *)alias{
    if (!self) self = [super init];
    return [self init : usage components: numComponents ofAlias:alias ofUnit:0];
}


-(VertexAttribute*) copy{
    return [[VertexAttribute alloc] init:_usage components:_numComponents ofType:_type isNormalized:_normalized ofAlias:_alias ofUnit:_unit];
}

+(VertexAttribute*) Position{
    return [[VertexAttribute alloc] init:Position components:3 ofAlias:POSITION_ATTRIBUTE];
}

+(VertexAttribute*) TexCoords : (GLint) unit{
    NSString* t_alias = [NSString stringWithFormat:@"%@%i", TEXCOORD_ATTRIBUTE, unit];
    return [[VertexAttribute alloc] init:TextureCoordinates components:2 ofAlias:t_alias];
}

+(VertexAttribute*) Normal{
    return [[VertexAttribute alloc] init:Normal components:3 ofAlias:NORMAL_ATTRIBUTE];
}

+(VertexAttribute*) ColorPacked{
    return [[VertexAttribute alloc] init:ColorPacked components:4 ofType:GL_UNSIGNED_BYTE isNormalized:true ofAlias:COLOR_ATTRIBUTE];
}

+(VertexAttribute*) ColorUnpacked{
    return [[VertexAttribute alloc] init:ColorUnpacked components:4 ofType:GL_FLOAT isNormalized:false ofAlias:COLOR_ATTRIBUTE];
}

+(VertexAttribute*) Tangent{
  return [[VertexAttribute alloc] init:Tangent components:3 ofAlias:TANGENT_ATTRIBUTE];
}

+(VertexAttribute*) Binormal{
    return [[VertexAttribute alloc] init:BiNormal components:3 ofAlias:BINORMAL_ATTRIBUTE];
}

+(VertexAttribute*) BoneWeight : (GLint) unit{
    NSString* t_alias = [NSString stringWithFormat:@"%@%i", BONEWEIGHT_ATTRIBUTE, unit];
    return [[VertexAttribute alloc] init:BoneWeight components:2 ofAlias:t_alias ofUnit:unit];
}

-(int) getSizeInBytes{
    switch (_type) {
        case GL_FLOAT:
        case GL_FIXED:
            return 4 * _numComponents;
        case GL_UNSIGNED_BYTE:
        case GL_BYTE:
            return _numComponents;
        case GL_UNSIGNED_SHORT:
        case GL_SHORT:
            return 2 * _numComponents;
    }
    return 0;
}

@end
