//
//  ViewController.h
//  glios
//
//  Created by Jitu JPM on 4/5/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController<GLKViewDelegate>{
    
}

- (IBAction)flipY:(id)sender;
- (IBAction)flipX:(id)sender;
- (IBAction)flipXY:(id)sender;

@end

