//
//  HRFireworksShaderController.m
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 29/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRFireworksShaderController.h"
#import "HRFireworksRenderShader.h"
@interface HRFireworksShaderController ()

@property (nonatomic, strong) HRGLColorTexture* textureA;
@property (nonatomic, strong) HRGLColorTexture* textureB;

@property (nonatomic, weak, readonly) HRGLColorTexture* currentTexture;
@property (nonatomic, weak, readonly) HRGLColorTexture* bufferTexture;

@property (nonatomic, strong) HRFireworksRenderShader* renderShader;

@property (nonatomic, assign) NSInteger indexLastAddedFireworks;
@property (nonatomic, assign) NSInteger numberOfFireworks;
@property (nonatomic, assign) NSInteger numberOfParticals;


@end

@implementation HRFireworksShaderController

- (NSString *)shaderName {
    return @"Fireworks";
}

- (void)didUseShader {
    [super didUseShader];
    _renderShader = nil;
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
    self.shader = [HRFireworksModelShader shader];
    self.renderShader = [HRFireworksRenderShader shader];
    [self.shader.aPosition setRows:(void*)kHRBaseShaderQuad withCount:4];
    [self.shader.aTextureCoord setRows:(void*)kHRBaseTextureQuad withCount:4];

    self.textureA = [[HRGLValueTexture alloc] initWithSize:CGSizeMake(512, 512)];
    self.textureB = [[HRGLValueTexture alloc] initWithSize:CGSizeMake(512, 512)];
    
    NSInteger numberOfPatricals = ((int)(self.textureA.size.y / 4.)) * self.textureA.size.x;
    self.numberOfFireworks = 8;
    self.shader.uNumberOfPointInFirework = (int)(numberOfPatricals / self.numberOfFireworks);
    self.indexLastAddedFireworks = self.numberOfFireworks - 1;
    self.numberOfParticals = numberOfPatricals;
    self.shader.uNumberOfFireworks = (int)self.numberOfFireworks;
    HRGLFloat* att = malloc(sizeof(HRGLFloat) * self.numberOfParticals);
    for (int i = 0; i < self.numberOfParticals; i++){
        att[i] = i;
    }
    [self.renderShader.aIndexes setRows:att withCount:self.numberOfParticals];
    free(att);
    
}

- (void)glkView:(GLKView *)view
     drawInRect:(HRGLVec4f)rect
           size:(HRGLVec2f) size{
    [self nextState];
    [self.bufferTexture startRenderInTexture];
    self.shader.uTexture = self.currentTexture;
    self.shader.uResolution = self.bufferTexture.size;
    self.shader.uTime = self.time;
    self.shader.uDeltaTime = self.timeWithFrame;
    [self.shader renderBeginMode:GL_TRIANGLE_STRIP
                           first:0
                           count:4];
    [self.bufferTexture endRenderInTexture];
    self.shader.uIsPan = NO;
    self.shader.uIsTap = NO;
    self.renderShader.uTextureSize = self.bufferTexture.size;
    self.renderShader.uTime = self.time;
    self.renderShader.uTexture = self.bufferTexture;
    self.renderShader.uResalution = size;
    glClearColor(0.f, 0.f, 0.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT);
    [self.renderShader renderBeginMode:GL_POINTS
                                 first:0
                                 count:(GLsizei)self.numberOfParticals];
    [super glkView:view drawInRect:rect size:size];
}


- (void) actionTapGesture:(UITapGestureRecognizer*) pan position:(HRGLVec2f)position {
    self.shader.uIsTap = YES;
    position.y = self.workSize.y - position.y;
    self.shader.uCurrentPosition = position;
    self.indexLastAddedFireworks = (self.indexLastAddedFireworks + 1) % self.numberOfFireworks;
    self.shader.uIndexNewFirework = (HRGLInt)self.indexLastAddedFireworks;
}

- (void) actionPanGesture:(UIPanGestureRecognizer*) pan
                 position:(HRGLVec2f)position
             lastPosition:(HRGLVec2f)lastPosition{
    self.shader.uNumberOfPointInFirework = (int)self.indexLastAddedFireworks;
    self.shader.uIsPan = YES;
    self.shader.uCurrentPosition = position;
    self.shader.uStartPanPosition = lastPosition;
}


@end
