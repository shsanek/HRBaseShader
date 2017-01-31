//
//  HRNoiseShaderController.m
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 28/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRNoiseShaderController.h"

@implementation HRNoiseShaderController

- (NSString*) shaderName {
    return @"Noise";
}

- (void)didLoadContextWithSize:(HRGLVec2f)size{
    [super didLoadContextWithSize:size];
    self.shader = [HRNoiseShader shader];
    [self.shader.aPosition setRows:(void*)kHRBaseShaderQuad withCount:4];
    [self.shader.aTextureCoord setRows:(void*)kHRBaseTextureQuad withCount:4];
}

- (void)glkView:(GLKView *)view drawInRect:(HRGLVec4f)rect size:(HRGLVec2f) size{
    self.shader.uResolution = size;
    self.shader.uTime = self.time;
    [self.shader renderBeginMode:GL_TRIANGLE_STRIP
                           first:0
                           count:4];
    [super glkView:view drawInRect:rect size:size];
}

@end
