//
//  HRTextureShader.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 28/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRNoiseShader.h"

@interface HRTextureShader : HRNoiseShader

@property (nonatomic,strong) HRGLColorTexture* uTexture;

@end
