//
//  ViewController.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 15/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "HRShaderController.h"

@interface ViewController : GLKViewController

@property (nonatomic, strong) HRShaderController* controller;

@end

