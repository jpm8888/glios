//
//  MyGLView.h
//  glios
//
//  Created by Jitu JPM on 4/13/17.
//  Copyright © 2017 jpm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenGLView : UIView{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
}

@end
