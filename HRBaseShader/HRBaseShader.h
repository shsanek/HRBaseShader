//
//  HRBaseShader.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 15/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import <UIKit/UIKit.h>
#import "HRShaderArrayTypes.h"

@interface HRBaseShader: NSObject

+ (instancetype) loadPixelShaderWithName:(NSString*) name
                                   error:(NSError**) error;

+ (instancetype) loadVertexShaderWithName:(NSString*) name
                                    error:(NSError**) error;

@property (nonatomic, assign, readonly) GLuint programm;

@end

@interface HRBaseShaderProgramm : NSObject

+ (instancetype) programmVertexProgramm:(HRBaseShader*) vertexProgramm
                          pixelProgramm:(HRBaseShader*) pixelProgramm
                                  error:(NSError**) error;

+ (instancetype) shaderWithName:(NSString*) name;

+ (instancetype) shader;

+ (NSArray<NSString*>*) ignorePropertys;

@property (nonatomic, assign, readonly) GLuint programm;

- (void) renderBeginMode:(uint) mode first:(GLint) index count:(GLsizei) count;

- (void) configuration;

@end
