//
//  HRFireworksRenderShader.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 29/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import <HRBaseShader/HRBaseShader.h>

@interface HRFireworksRenderShader : HRBaseShaderProgramm

@property (nonatomic, assign) HRGLFloat uTime;
@property (nonatomic, strong) HRGLAttributeF* aIndexes;
@property (nonatomic, assign) HRGLVec2f uTextureSize;
@property (nonatomic, assign) HRGLVec2f uResalution;
@property (nonatomic, strong) HRGLColorTexture* uTexture;

@end
