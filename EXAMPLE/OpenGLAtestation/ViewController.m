//
//  ViewController.m
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 15/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "ViewController.h"
#import "HRGLTypes.h"
#import <HRSubclasses/NSObject+HRGetSubclass.h>
#import "HRColorShader.h"

#import <objc/runtime.h>
#import "HRNoiseShaderController.h"


@interface ViewController ()

@property (nonatomic, assign) CGPoint lastPanLocation;

@end

@implementation ViewController

- (HRShaderController *)controller {
    if (!_controller){
        _controller  = [HRNoiseShaderController new];
    }
    return _controller;
}

- (void)dealloc {
    [self.controller didUseShader];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up context
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:context];
    
    // Set up view
    GLKView *glkView = (GLKView *)self.view;
    glkView.context = context;

    // OpenGL ES settings
    glClearColor(1.f, 0.f, 1.f, 1.f);
    
    
    
    //glDisable (GL_DITHER);

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.controller didLoadContextWithSize:
     hrglVec2fFromCGSizeWithScaleFactor(self.view.bounds.size,
                                        self.view.contentScaleFactor)];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.controller glkView:view
                  drawInRect:hrglVec4fFromCGRectWithScaleFactor(rect, view.contentScaleFactor)
                        size:hrglVec2fFromCGSizeWithScaleFactor(rect.size,view.contentScaleFactor)];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - action

- (IBAction) actionTapGesure:(UITapGestureRecognizer*) sender {
    [self.controller actionTapGesture:sender
                             position:hrglVec2fFromCGPointWithScaleFactor([sender locationInView:self.view],
                                                                          self.view.contentScaleFactor)];
}

- (IBAction) actionPanGesure:(UIPanGestureRecognizer*) sender {
    CGPoint currentPoint = [sender locationInView:self.view];
    CGPoint lastPoint = self.lastPanLocation;
    if (sender.state == UIGestureRecognizerStateBegan) {
        lastPoint = [sender translationInView:self.view];
        lastPoint = CGPointMake(currentPoint.x - lastPoint.x, currentPoint.y - lastPoint.y);
    }
    [self.controller actionPanGesture:sender
                             position:hrglVec2fFromCGPointWithScaleFactor(currentPoint,self.view.contentScaleFactor)
                         lastPosition:hrglVec2fFromCGPointWithScaleFactor(lastPoint,self.view.contentScaleFactor)];
    self.lastPanLocation = currentPoint;
}

@end
