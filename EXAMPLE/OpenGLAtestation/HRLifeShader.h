//
//  HRLifeShader.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 28/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRTextureShader.h"

@interface HRLifeShader : HRTextureShader

@property (nonatomic, assign) HRGLBool uIsTap;
@property (nonatomic, assign) HRGLBool uIsPan;

@property (nonatomic, assign) HRGLVec2f uStartPanPosition;
@property (nonatomic, assign) HRGLVec2f uCurrentPosition;

@end
