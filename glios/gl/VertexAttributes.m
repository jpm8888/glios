//
//  VertexAttributes.m
//  GLKViewExample
//
//  Created by Jitu JPM on 4/1/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "VertexAttributes.h"
#import "GLUtil.h"

@implementation VertexAttributes{
    GLint vertexSize;
}

-(instancetype) init : (NSMutableArray*) attrs{
    self = [super init];
    if ([attrs count] == 0){
        [GLUtil LOG:@"VertexAttributes" : @"attributes must be >= 1"];
        return self;
    }
    
    self.attributes = attrs;
    vertexSize = [self calcualteOffsets];
    return self;
}

-(GLint) getOffset : (Usage) usage : (GLint) defaultIfNotFound{
    VertexAttribute* vertexAttribute = [self findByUsage: usage];
    if (vertexAttribute) return vertexAttribute.offset / 4;
    return  defaultIfNotFound;
}

-(GLint) getOffset : (Usage) usage{
    return [self getOffset:usage :0];
}


-(VertexAttribute*) findByUsage : (Usage) usage{
    NSUInteger len = [self size];
    for (int i = 0; i < len; i++){
        if ([[self get:i] usage] == usage) return [self get:i];
    }
    return nil;
}

-(GLint) calcualteOffsets{ //private method
    GLint count = 0;
    for (int i = 0; [self.attributes count]; i++) {
        VertexAttribute * attribute = [self.attributes objectAtIndex:i];
        attribute.offset = count;
        count += [attribute getSizeInBytes];
    }
    return count;
}

-(NSUInteger) size{
    return [self.attributes count];
}

-(VertexAttribute*) get : (int) index{
    return [self.attributes objectAtIndex:index];
}

@end
