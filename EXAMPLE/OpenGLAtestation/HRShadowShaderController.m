//
//  HRShadowShaderController.m
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 31/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRShadowShaderController.h"
#import "HRShadowRenderShader.h"
#import "HRShadowModelShader.h"

@interface HRShadowShaderController ()

@property (nonatomic, strong) HRShadowModelShader* shader;
@property (nonatomic, strong) HRShadowRenderShader* renderShadow;
@property (nonatomic, strong) HRTextureShader* backgroundShader;
@property (nonatomic, assign) NSInteger numberOfLight;
@property (nonatomic, assign) NSInteger currentIndexLight;
@property (nonatomic, assign) NSInteger maxNumberOfLights;
@end

@implementation HRShadowShaderController

- (void)didUseShader {
    _shader = nil;
    _backgroundShader = nil;
    _renderShadow = nil;
}

- (NSString*) shaderName {
    return @"Shadow";
}


- (void)didLoadContextWithSize:(HRGLVec2f)size{
    NSInteger maxLight = 16.;
    self.maxNumberOfLights = maxLight;
    [super didLoadContextWithSize:size];
    self.shader = [HRShadowModelShader shader];
    self.renderShadow = [HRShadowRenderShader shader];
    self.backgroundShader = [HRTextureShader shader];
    [self.shader.aPosition setRows:(void*)kHRBaseShaderQuad withCount:4];
    [self.renderShadow.aPosition setRows:(void*)kHRBaseShaderQuad withCount:4];
    [self.backgroundShader.aPosition setRows:(void*)kHRBaseShaderQuad withCount:4];
    self.currentIndexLight = maxLight - 1.;
    
    HRGLColorTexture* texture = [[HRGLColorTexture alloc] initWithImage:[UIImage imageNamed:@"template"]];
//    self.backgroundShader.uTexture = texture;
    [self.backgroundShader.aTextureCoord setRows:(void*)kHRBaseTextureQuad withCount:4];
    
    self.shader.uTexture = texture;;
    self.shader.uTextureSize = texture.size;
    
    self.renderShadow.uTexture = [[HRGLValueTexture alloc] initWithSize:CGSizeMake(512., maxLight)];
    self.renderShadow.uTextureSize = texture.size;
    
    HRGLVec3f * vec = malloc(sizeof(HRGLVec3f) * maxLight);
    for (int i = 0; i < maxLight; i++) {
        vec[i].x = 0;
        vec[i].y = 0;
        vec[i].z = 0;
    }
    [self.shader.uLightParameters setRows:vec withCount:maxLight];
    [self.renderShadow.uLightParameters setRows:vec withCount:maxLight];
}

- (void)glkView:(GLKView *)view drawInRect:(HRGLVec4f)rect size:(HRGLVec2f) size{
    self.shader.uNumberOfLight = self.numberOfLight;
    self.renderShadow.uNumberOfLight = self.numberOfLight;
    
    [self.renderShadow.uTexture startRenderInTexture];
    glClearColor(1.f, 1.f, 1.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT);

    self.shader.uResolution = self.renderShadow.uTexture.size;
    [self.shader renderBeginMode:GL_TRIANGLE_STRIP
                           first:0
                           count:4];
    
    [self.renderShadow.uTexture endRenderInTexture];
    
    self.renderShadow.uResolution = size;
    glClearColor(1.f, 1.f, 1.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT);
    self.backgroundShader.uTexture = self.shader.uTexture;
    [self.backgroundShader renderBeginMode:GL_TRIANGLE_STRIP
                                     first:0
                                     count:4];

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [self.renderShadow renderBeginMode:GL_TRIANGLE_STRIP
                                 first:0
                                 count:4];
    glDisable(GL_BLEND);
    [super glkView:view drawInRect:rect size:size];
}


- (void)actionPanGesture:(UIPanGestureRecognizer *)pan
                position:(HRGLVec2f)position
            lastPosition:(HRGLVec2f)lastPosition{
    HRGLVec3f par =  {.x = position.x / self.workSize.x * self.renderShadow.uTextureSize.x,
                      .y = (1. - position.y / self.workSize.y) * self.renderShadow.uTextureSize.y,
                      .z = 200.};
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        par.z = 200.;
        self.currentIndexLight = (self.currentIndexLight + 1) % self.maxNumberOfLights;
        self.numberOfLight = MAX(self.numberOfLight,self.currentIndexLight + 1);
    }
    [self.renderShadow.uLightParameters setRow:par atIndex:self.currentIndexLight];
    [self.shader.uLightParameters setRow:par atIndex:self.currentIndexLight];
}

@end
