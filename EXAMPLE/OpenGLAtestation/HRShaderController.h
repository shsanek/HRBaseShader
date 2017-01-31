//
//  HRShaderController.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 28/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <HRBaseShader/HRBaseShader.h>

extern HRGLVec2f const kHRBaseShaderQuad[4];
extern HRGLVec2f const kHRBaseTextureQuad[4];




@protocol HRShaderControllerProtocol <NSObject>

- (void)setShader:(HRBaseShader *)shader;

@end

@interface HRShaderController : NSObject<HRShaderControllerProtocol>

@property (nonatomic, assign, readonly) float time;
@property (nonatomic, assign, readonly) float timeWithFrame;
@property (nonatomic, assign) HRGLVec2f workSize;

- (void) didLoadContextWithSize:(HRGLVec2f) size;
- (void) didUseShader;
- (NSString*) shaderName;

- (void) actionTapGesture:(UITapGestureRecognizer*) pan
                 position:(HRGLVec2f) position;

- (void) actionPanGesture:(UIPanGestureRecognizer*) pan
                 position:(HRGLVec2f) position
             lastPosition:(HRGLVec2f) lastPosition;

- (void)glkView:(GLKView *)view drawInRect:(HRGLVec4f)rect size:(HRGLVec2f) size;

@end
