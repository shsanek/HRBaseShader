//
//  HRGLColorTexture.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 28/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "HRShaderType.h"
#import <UIKit/UIKit.h>

//only color
@interface HRGLColorTexture : NSObject

@property (nonatomic, assign, readonly) GLuint identifier;
@property (nonatomic, assign, readonly) HRGLVec2f size;
@property (nonatomic, assign, readonly) UIImage* image;
@property (nonatomic, assign, readonly) const char* rowData;
@property (nonatomic, assign, readonly) Float32* array;

@property (nonatomic, assign) BOOL repeat;//default NO


- (instancetype) initWithImage:(UIImage*) image;

- (instancetype) initWithSize:(CGSize) size;
- (instancetype) initWithRowData:(GLubyte*) rowData
                        withSize:(CGSize) size;

- (instancetype) initWithArray:(Float32*) array
                      withSize:(CGSize) size;

- (void) startRenderInTexture;
- (void) startRenderInTextureWithDepth:(BOOL) depth;
- (void) endRenderInTexture;

@end

@interface HRGLValueTexture : HRGLColorTexture


@end
