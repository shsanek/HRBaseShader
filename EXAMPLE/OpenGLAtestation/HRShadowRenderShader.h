//
//  PhysicalParticalSystem
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 29/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRFireworksModelShader.h"

@interface HRShadowRenderShader : HRTextureShader

@property HRGLFloat uNumberOfLight;
@property HRGLVec2f uTextureSize;
@property HRGLArrayVec3f* uLightParameters;

@end
