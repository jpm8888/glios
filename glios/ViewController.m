//
//  ViewController.m
//  glios
//
//  Created by Jitu JPM on 4/5/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize glView;

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.glView = [[MyGLView alloc] initWithFrame:screenBounds];
    [self.view addSubview:glView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




@end
