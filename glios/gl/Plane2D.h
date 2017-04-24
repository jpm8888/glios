//
//  Plane2D.h
//  glios
//
//  Created by Jitu JPM on 4/22/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "Mesh.h"
#import "Texture.h"
#import "Color.h"

@interface Plane2D : NSObject

-(instancetype) init : (float) x : (float) y : (float) w : (float) h : (Texture*) tex;
-(void) render : (GLKMatrix4) matrix;
-(void) flipX;
-(void) flipY;
-(void) translateTo : (float) tx : (float) ty;
-(void) scaleTo : (float) scl;
-(void) rotateTo : (float) rot;
-(GLKVector2) getSize;
-(float) getWidth;
-(float) getHeight;
-(void) setColor : (Color*) lb : (Color*) lt : (Color*) rb : (Color*) rt;
-(void) setTexture : (Texture*) tex;
-(BOOL) contains : (float) x : (float) y;
-(void) dispose;

@end
