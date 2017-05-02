//
//  BlendTexture.h
//  glios
//
//  Created by Jitendra P Maindola on 01/05/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrthographicCamera.h"
#import <UIKit/UIKit.h>

@interface BlendTexture : NSObject{
    
}
-(instancetype) init : (UIImage*) bImage : (UIImage*) oImage : (UIImage*) mImage;
-(void) render : (GLKMatrix4) combined;
-(void) updateTexture : (UIImage*) bImage : (UIImage*) oImage : (UIImage*) mImage;
-(void) dispose;
@end
