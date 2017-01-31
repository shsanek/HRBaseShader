//
//  HRFireworksModelShader.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 29/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRLifeShader.h"

@interface HRFireworksModelShader : HRLifeShader

@property (nonatomic, assign) HRGLInt uNumberOfPointInFirework;
@property (nonatomic, assign) HRGLInt uIndexNewFirework;
@property (nonatomic, assign) HRGLFloat uDeltaTime;
@property (nonatomic, assign) HRGLInt uNumberOfFireworks;

@end
