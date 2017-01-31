//
//  HRNoiseShader.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 28/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRColorShader.h"

@interface HRNoiseShader : HRColorShader

@property (nonatomic,strong) HRGLAttributeVec2f* aTextureCoord;
@property (nonatomic,assign) HRGLFloat uTime;

@end
