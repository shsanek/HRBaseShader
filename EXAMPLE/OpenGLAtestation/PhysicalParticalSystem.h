//
//  PhysicalParticalSystem
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 29/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRFireworksModelShader.h"

@interface PhysicalParticalSystem : HRLifeShader

@property (nonatomic, assign) HRGLVec2f uGravitaion;
@property (nonatomic, assign) HRGLFloat uDeltaTime;
@property (nonatomic, assign) HRGLVec2f uNewIndexRange;
@property (nonatomic, assign) HRGLInt uNumberOfItems;

@end
