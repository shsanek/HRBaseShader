//
//  HRShaderController.m
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 28/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRShaderController.h"

HRGLVec2f const kHRBaseShaderQuad[4] = {
    {-1.f, -1.f},
    {-1.f, +1.f},
    {+1.f, -1.f},
    {+1.f, +1.f}
};

HRGLVec2f const kHRBaseTextureQuad[4] = {
    {0, 0.f},
    {0.f, 1.f},
    {1.f, 0.f},
    {1.f, 1.f}
};

@implementation HRShaderController{
    float _startTime;
    float _lastFrameTime;
}

- (float)time {
    return CACurrentMediaTime() - _startTime;
}

- (float)timeWithFrame {
    return CACurrentMediaTime() - _lastFrameTime;
}

- (void)setShader:(HRBaseShader *)shader {
    
}

- (void) didLoadContextWithSize:(HRGLVec2f)size{
    _startTime = CACurrentMediaTime();
    _lastFrameTime = _startTime;
    _workSize = size;
}

- (void) didUseShader{
    [self setShader:nil];
}

- (NSString*) shaderName{
    return nil;
}

- (void) actionTapGesture:(UITapGestureRecognizer*) pan
                 position:(HRGLVec2f)position{}
- (void) actionPanGesture:(UIPanGestureRecognizer*) pan
                 position:(HRGLVec2f)position
             lastPosition:(HRGLVec2f)lastPosition{}
- (void)glkView:(GLKView *)view drawInRect:(HRGLVec4f)rect size:(HRGLVec2f) size{
    _lastFrameTime = CACurrentMediaTime();
}


@end
