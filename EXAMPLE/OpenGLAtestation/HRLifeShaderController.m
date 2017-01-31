//
//  HRLifeShaderController.m
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 28/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRLifeShaderController.h"

@interface HRLifeShaderController ()

@property (nonatomic, strong) HRGLColorTexture* textureA;
@property (nonatomic, strong) HRGLColorTexture* textureB;

@property (nonatomic, weak, readonly) HRGLColorTexture* currentTexture;
@property (nonatomic, weak, readonly) HRGLColorTexture* bufferTexture;

@property (nonatomic, strong) HRTextureShader* textureShader;

@end

@implementation HRLifeShaderController

- (NSString *)shaderName {
    return @"Life";
}

- (void)didUseShader {
    [super didUseShader];
    _textureShader = nil;
    _textureA = nil;
    _textureB = nil;
}

- (void) nextState {
    if (self.currentTexture == self.textureA) {
        _currentTexture = self.textureB;
        _bufferTexture = self.textureA;
    } else {
        _currentTexture = self.textureA;
        _bufferTexture = self.textureB;
    }
}

- (void)didLoadContextWithSize:(HRGLVec2f)size{
    [super didLoadContextWithSize:size];
    self.shader = [HRLifeShader shader];
    self.textureShader = [HRTextureShader shader];
    [self.shader.aPosition setRows:(void*)kHRBaseShaderQuad withCount:4];
    [self.shader.aTextureCoord setRows:(void*)kHRBaseTextureQuad withCount:4];
    [self.textureShader.aPosition setRows:(void*)kHRBaseShaderQuad withCount:4];
    [self.textureShader.aTextureCoord setRows:(void*)kHRBaseTextureQuad withCount:4];
    self.textureA = [[HRGLColorTexture alloc] initWithSize:CGSizeMake(64, 64)];
    self.textureB = [[HRGLColorTexture alloc] initWithSize:CGSizeMake(64, 64)];
    self.textureB.repeat = YES;
    self.textureA.repeat = YES;
}

- (void)glkView:(GLKView *)view
     drawInRect:(HRGLVec4f)rect
           size:(HRGLVec2f) size{
    if (self.timeWithFrame > 0.25) {
        [self nextState];
        [self.bufferTexture startRenderInTexture];
        self.shader.uTexture = self.currentTexture;
        self.shader.uResolution = self.bufferTexture.size;
        self.shader.uTime = self.time;
        [self.shader renderBeginMode:GL_TRIANGLE_STRIP
                               first:0
                               count:4];
        [self.bufferTexture endRenderInTexture];
        self.shader.uIsPan = NO;
        self.shader.uIsTap = NO;
        
        self.textureShader.uResolution = size;
        self.textureShader.uTime = self.time;
        self.textureShader.uTexture = self.bufferTexture;
        [self.textureShader renderBeginMode:GL_TRIANGLE_STRIP
                                      first:0
                                      count:4];
        [super glkView:view drawInRect:rect size:size];
    }
}


- (void) actionTapGesture:(UITapGestureRecognizer*) pan position:(HRGLVec2f)position {
    self.shader.uIsPan = YES;
    self.shader.uCurrentPosition = (HRGLVec2f){
        .x = position.x  / self.workSize.x * self.textureA.size.x,
        .y = position.y  / self.workSize.y * self.textureA.size.y};
}

- (void) actionPanGesture:(UIPanGestureRecognizer*) pan
                 position:(HRGLVec2f)position
             lastPosition:(HRGLVec2f)lastPosition{
    self.shader.uIsPan = YES;
    self.shader.uCurrentPosition = (HRGLVec2f){
        .x = position.x / self.workSize.x * self.textureA.size.x,
        .y = position.y  / self.workSize.y * self.textureA.size.y};
    self.shader.uStartPanPosition = (HRGLVec2f){
        .x = lastPosition.x  / self.workSize.x * self.textureA.size.x,
        .y = lastPosition.y  / self.workSize.y * self.textureA.size.y};

}

@end
