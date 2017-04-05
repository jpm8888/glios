//
//  VertexAttribute.h
//  GLKViewExample
//
//  Created by Jitu JPM on 3/31/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLUtil.h"

@interface VertexAttribute : NSObject{
    
}

typedef enum {
    Position = 1,
    ColorUnpacked = 2,
    ColorPacked = 4,
    Normal = 8,
    TextureCoordinates = 16,
    Generic = 32,
    BoneWeight = 64,
    Tangent = 128,
    BiNormal = 256,
    
} Usage;

@property const Usage usage;
@property const GLint numComponents;
@property const GLboolean normalized;
@property const GLint type;
@property const GLint offset;
@property NSString* alias;
@property GLint unit;

-(instancetype) init : (Usage) usage components : (GLint) numComponents ofType : (GLint) type isNormalized : (GLboolean) normalized ofAlias : (NSString*) alias ofUnit : (GLint) unit;
-(instancetype) init : (Usage) usage components:(GLint)numComponents ofType:(GLint)type isNormalized:(GLboolean)normalized ofAlias:(NSString *)alias;
-(instancetype) init : (Usage) usage components : (GLint) numComponents ofAlias : (NSString*) alias ofUnit : (GLint) unit;
-(instancetype) init : (Usage) usage components:(GLint)numComponents ofAlias:(NSString *)alias;
-(VertexAttribute*) copy;
+(VertexAttribute*) Position;
+(VertexAttribute*) TexCoords : (GLint) unit;
+(VertexAttribute*) Normal;
+(VertexAttribute*) ColorPacked;
+(VertexAttribute*) ColorUnpacked;
+(VertexAttribute*) Tangent;
+(VertexAttribute*) Binormal;
+(VertexAttribute*) BoneWeight : (GLint) unit;
-(int) getSizeInBytes;

@end
