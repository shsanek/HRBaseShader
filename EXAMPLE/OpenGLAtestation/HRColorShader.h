//
//  HRColorShader.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 21/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import <HRBaseShader/HRBaseShader.h>

@interface HRColorShader : HRBaseShaderProgramm

@property (nonatomic, assign) HRGLVec2f uResolution;
@property (nonatomic, strong) HRGLAttributeVec2f* aPosition;

@end
