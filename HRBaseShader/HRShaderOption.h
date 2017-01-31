//
//  HRShaderOption.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 15/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import "HRShaderType.h"
#import "HRShaderArrayTypes.h"



#define INTERFACE_SHADER_OPTION_SUBCLASS(TYPE) \
@interface TYPE##ShaderOption : HRShaderOption   @property (nonatomic, assign) TYPE value; \
- (instancetype) initWithName:(NSString*) name;

#define INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(TYPE) \
@interface TYPE##ShaderOption : HRShaderOption   @property (nonatomic, strong) TYPE* value; \
- (instancetype) initWithName:(NSString*) name;

#define INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(TYPE) \
@interface TYPE##ShaderOption : HRShaderOption   @property (nonatomic, strong) TYPE* value; \
- (instancetype) initWithName:(NSString*) name;

typedef enum {
    HRShaderOptionParametrUniform,
    HRShaderOptionParametrAttrib
}HRShaderOptionParametr;

@interface HRShaderOption : NSObject

@property (nonatomic, assign, readonly) GLuint position;
@property (nonatomic, assign, readonly) NSString* name;
@property (nonatomic, assign, readonly) BOOL isNeedUpdate;
@property (nonatomic, assign, readonly) HRShaderOptionParametr type;

- (instancetype) initWithName:(NSString*) name;

- (instancetype) initWithName:(NSString*) name
                         type:(HRShaderOptionParametr) type;

- (void) setNeedUpdate;
- (void) linkFromProgramm:(GLuint) programm;
- (void) updateIfNeed:(GLuint) programm;

@end

INTERFACE_SHADER_OPTION_SUBCLASS(HRGLInt)@end
INTERFACE_SHADER_OPTION_SUBCLASS(HRGLFloat)@end
INTERFACE_SHADER_OPTION_SUBCLASS(HRGLBool)@end

INTERFACE_SHADER_OPTION_SUBCLASS(HRGLVec2f)@end
INTERFACE_SHADER_OPTION_SUBCLASS(HRGLVec3f)@end
INTERFACE_SHADER_OPTION_SUBCLASS(HRGLVec4f)@end

INTERFACE_SHADER_OPTION_SUBCLASS(HRGLVec2i)@end
INTERFACE_SHADER_OPTION_SUBCLASS(HRGLVec3i)@end
INTERFACE_SHADER_OPTION_SUBCLASS(HRGLVec4i)@end

INTERFACE_SHADER_OPTION_SUBCLASS(HRGLVec2b)@end
INTERFACE_SHADER_OPTION_SUBCLASS(HRGLVec3b)@end
INTERFACE_SHADER_OPTION_SUBCLASS(HRGLVec4b)@end

INTERFACE_SHADER_OPTION_SUBCLASS(HRGLMat2)@end
INTERFACE_SHADER_OPTION_SUBCLASS(HRGLMat3)@end
INTERFACE_SHADER_OPTION_SUBCLASS(HRGLMat4)@end

//UNIFORM ARRAYS
INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayI)@end
INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayF)@end
INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayB)@end

INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayVec2f)@end
INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayVec3f)@end
INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayVec4f)@end

INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayVec2b)@end
INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayVec3b)@end
INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayVec4b)@end

INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayVec2i)@end
INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayVec3i)@end
INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayVec4i)@end

INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayMat2)@end
INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayMat3)@end
INTERFACE_SHADER_ARRAY_OPTION_SUBCLASS(HRGLArrayMat4)@end


//ATRIBUTES
INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(HRGLAttributeI)@end
INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(HRGLAttributeF)@end
INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(HRGLAttributeB)@end

INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(HRGLAttributeVec2f)@end
INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(HRGLAttributeVec3f)@end
INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(HRGLAttributeVec4f)@end

INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(HRGLAttributeVec2i)@end
INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(HRGLAttributeVec3i)@end
INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(HRGLAttributeVec4i)@end

INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(HRGLAttributeVec2b)@end
INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(HRGLAttributeVec3b)@end
INTERFACE_SHADER_ATTRIBUTE_OPTION_SUBCLASS(HRGLAttributeVec4b)@end

@interface HRGLColorTextureShaderOption : HRShaderOption

@property (nonatomic, assign) GLuint textureNumber;
@property (nonatomic, strong) HRGLColorTexture* value;

@end

