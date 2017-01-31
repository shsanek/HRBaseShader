//
//  HRColorShaderController.m
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 28/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRColorShaderController.h"

@implementation HRColorShaderController

- (NSString*) shaderName {
    return @"Color";
}


- (void)didLoadContextWithSize:(HRGLVec2f)size{
    [super didLoadContextWithSize:size];
    self.shader = [HRColorShader shader];
    [self.shader.aPosition setRows:(void*)kHRBaseShaderQuad withCount:4];
}

- (void)glkView:(GLKView *)view drawInRect:(HRGLVec4f)rect size:(HRGLVec2f) size{
    self.shader.uResolution = size;
    [self.shader renderBeginMode:GL_TRIANGLE_STRIP
                           first:0
                           count:4];
    [super glkView:view drawInRect:rect size:size];
}

@end
