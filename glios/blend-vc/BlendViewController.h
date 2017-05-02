//
//  BlendViewController.h
//  glios
//
//  Created by Jitendra P Maindola on 01/05/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>

@interface BlendViewController : UIViewController{
    
}

@property (strong, nonatomic) IBOutlet GLKView *glkview;
@property (strong,nonatomic) EAGLContext *context;
@end
