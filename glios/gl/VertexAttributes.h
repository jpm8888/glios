//
//  VertexAttributes.h
//  GLKViewExample
//
//  Created by Jitu JPM on 4/1/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VertexAttribute.h"

@interface VertexAttributes : NSObject

@property NSMutableArray *attributes;
-(instancetype) init : (NSMutableArray*) attrs;
-(GLint) getOffset : (Usage) usage : (GLint) defaultIfNotFound;
-(GLint) getOffset : (Usage) usage;
-(VertexAttribute*) findByUsage : (Usage) usage;
-(NSUInteger) size;
-(VertexAttribute*) get : (int) index;

@end
