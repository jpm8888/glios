//
//  FakeScreen.h
//  glios
//
//  Created by Jitu JPM on 4/20/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture.h"

@interface FakeScreen : NSObject

-(void) render : (float) viewX : (float) viewY;
-(Texture*) getTexture;
@end
