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
-(GLKVector2) getPosition;
-(float) getPositionX;
-(float) getPositionY;
-(void) setPositionX : (float) x;
-(void) setPositionY : (float) y;
-(void) setPosition : (float) x : (float) y;
-(void) setPosition : (GLKVector2) vec;
-(GLKVector2) getSize;
-(float) getWidth;
-(float) getHeight;
-(void) setWidth : (float) w;
-(void) setHeight : (float) h;
-(void) setSize : (float) w : (float) h;
-(void) setSize : (GLKVector2) vec;
-(void) setColor : (Color*) lb : (Color*) lt : (Color*) rb : (Color*) rt;
-(void) setTexture : (Texture*) tex;
-(BOOL) contains : (float) x : (float) y;
-(void) dispose;

@end
