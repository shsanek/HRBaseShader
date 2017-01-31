//
//  HRPivateBaseShader.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 21/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//
//NOT INCLUDE THIS FILE 
#import "HRBaseShader.h"
#import "HRShaderOption.h"
#import <HRSubclasses/NSObject+HRGetSubclass.h>

@interface HRBaseShaderProgramm ()

@property (nonatomic, assign) BOOL isLoad;
@property (nonatomic, strong, readonly) NSDictionary<NSString*,HRShaderOption*>* optionalsFromNames;
@property (nonatomic, strong, readonly) NSDictionary<NSString*,HRShaderOption*>* optionalsFromGet;
@property (nonatomic, strong, readonly) NSDictionary<NSString*,HRShaderOption*>* optionalsFromSet;

@end

#define GET_NAME_FUNCTION(TYPE) hrglshader_papref##TYPE##Getter
#define SET_NAME_FUNCTION(TYPE) hrglshader_papref##TYPE##Setter

#define HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(TYPE)\
\
TYPE GET_NAME_FUNCTION(TYPE) (HRBaseShaderProgramm* obj, SEL _cmd) {\
NSString *selectorString = NSStringFromSelector(_cmd);\
id optional = obj.optionalsFromGet[selectorString];\
SEL selector = NSSelectorFromString(@"value");\
IMP implementation = [optional methodForSelector:selector];\
TYPE (*function)(id obj,SEL sel) = (void*)implementation;\
return function(optional,selector);\
}\
void SET_NAME_FUNCTION(TYPE)(HRBaseShaderProgramm* obj, SEL _cmd, TYPE value) {\
NSString *selectorString = NSStringFromSelector(_cmd);\
id optional = obj.optionalsFromSet[selectorString];\
SEL selector = NSSelectorFromString(@"setValue:");\
IMP implementation = [optional methodForSelector:selector];\
void (*function)(id obj,SEL sel,TYPE value) = (void*)implementation;\
function(optional,selector,value);\
}

HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLInt)
HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLFloat)
HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLBool)

HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLVec2f)
HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLVec3f)
HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLVec4f)

HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLVec2i)
HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLVec3i)
HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLVec4i)

HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLVec2b)
HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLVec3b)
HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLVec4b)

HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLMat2)
HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLMat3)
HRGL_FUNCTIONS_FOR_SETTING_BASE_TYPE(HRGLMat4)

#define HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(TYPE)\
\
TYPE* GET_NAME_FUNCTION(TYPE) (HRBaseShaderProgramm* obj, SEL _cmd) {\
NSString *selectorString = NSStringFromSelector(_cmd);\
id optional = obj.optionalsFromGet[selectorString];\
SEL selector = NSSelectorFromString(@"value");\
IMP implementation = [optional methodForSelector:selector];\
TYPE* (*function)(id obj,SEL sel) = (void*)implementation;\
return function(optional,selector);\
}\
void SET_NAME_FUNCTION(TYPE)(HRBaseShaderProgramm* obj, SEL _cmd, TYPE* value) {\
NSString *selectorString = NSStringFromSelector(_cmd);\
id optional = obj.optionalsFromSet[selectorString];\
SEL selector = NSSelectorFromString(@"setValue:");\
IMP implementation = [optional methodForSelector:selector];\
void (*function)(id obj,SEL sel,TYPE* value) = (void*)implementation;\
function(optional,selector,value);\
}


HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayI)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayF)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayB)

HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayVec2f)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayVec3f)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayVec4f)

HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayVec2b)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayVec3b)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayVec4b)

HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayVec2i)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayVec3i)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayVec4i)

HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayMat2)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayMat3)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLArrayMat4)

HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLAttributeI)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLAttributeF)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLAttributeB)

HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLAttributeVec2f)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLAttributeVec3f)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLAttributeVec4f)

HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLAttributeVec2i)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLAttributeVec3i)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLAttributeVec4i)

HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLAttributeVec2b)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLAttributeVec3b)
HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLAttributeVec4b)

HRGL_FUNCTIONS_FOR_SETTING_OBJECT_TYPE(HRGLColorTexture)

@interface HRGLOptionalContainer : NSObject

+ (BOOL) useCurrentContainerForString:(NSString*) string withOptions:(NSArray<NSString*>*) options;
+ (void*) setterImplementation;
+ (void*) getterImplementation;
+ (HRShaderOption*) optionalWithName:(NSString*) name;

@end

#define HRGL_OPTIONAL_CONTAINER_BASE(TYPE,REALTYPE)\
@interface TYPE##OptionalContainer : HRGLOptionalContainer\
@end\
\
@implementation TYPE##OptionalContainer \
+ (BOOL) useCurrentContainerForString:(NSString*) string withOptions:(NSArray<NSString*>*) options{\
return [string isEqualToString:@#REALTYPE];\
}\
\
+ (void*) setterImplementation{\
return (void*)SET_NAME_FUNCTION(TYPE);\
}\
+ (void*) getterImplementation{\
return (void*)GET_NAME_FUNCTION(TYPE);\
}\
\
+ (HRShaderOption*) optionalWithName:(NSString*) name{\
return [[TYPE##ShaderOption alloc] initWithName:name];\
}\
\
@end

#define HRGL_OPTIONAL_CONTAINER(TYPE) HRGL_OPTIONAL_CONTAINER_BASE(TYPE,TYPE)

@implementation HRGLOptionalContainer
+ (BOOL) useCurrentContainerForString:(NSString*) string withOptions:(NSString*) options{
    return NO;
}

+ (void*) setterImplementation{
    return NULL;
}

+ (void*) getterImplementation{
    return NULL;
}

+ (HRShaderOption*) optional{
    return nil;
}

@end

HRGL_OPTIONAL_CONTAINER_BASE(HRGLInt,int)
HRGL_OPTIONAL_CONTAINER_BASE(HRGLFloat,float)
HRGL_OPTIONAL_CONTAINER_BASE(HRGLBool,int)

HRGL_OPTIONAL_CONTAINER_BASE(HRGLVec2f,?=ff);

HRGL_OPTIONAL_CONTAINER(HRGLVec3f)
HRGL_OPTIONAL_CONTAINER(HRGLVec4f)

HRGL_OPTIONAL_CONTAINER(HRGLVec2i)
HRGL_OPTIONAL_CONTAINER(HRGLVec3i)
HRGL_OPTIONAL_CONTAINER(HRGLVec4i)

HRGL_OPTIONAL_CONTAINER(HRGLVec2b)
HRGL_OPTIONAL_CONTAINER(HRGLVec3b)
HRGL_OPTIONAL_CONTAINER(HRGLVec4b)

HRGL_OPTIONAL_CONTAINER(HRGLMat2)
HRGL_OPTIONAL_CONTAINER(HRGLMat3)
HRGL_OPTIONAL_CONTAINER(HRGLMat4)

HRGL_OPTIONAL_CONTAINER(HRGLArrayI)
HRGL_OPTIONAL_CONTAINER(HRGLArrayF)
HRGL_OPTIONAL_CONTAINER(HRGLArrayB)

HRGL_OPTIONAL_CONTAINER(HRGLArrayVec2f)
HRGL_OPTIONAL_CONTAINER(HRGLArrayVec3f)
HRGL_OPTIONAL_CONTAINER(HRGLArrayVec4f)

HRGL_OPTIONAL_CONTAINER(HRGLArrayVec2b)
HRGL_OPTIONAL_CONTAINER(HRGLArrayVec3b)
HRGL_OPTIONAL_CONTAINER(HRGLArrayVec4b)

HRGL_OPTIONAL_CONTAINER(HRGLArrayVec2i)
HRGL_OPTIONAL_CONTAINER(HRGLArrayVec3i)
HRGL_OPTIONAL_CONTAINER(HRGLArrayVec4i)

HRGL_OPTIONAL_CONTAINER(HRGLArrayMat2)
HRGL_OPTIONAL_CONTAINER(HRGLArrayMat3)
HRGL_OPTIONAL_CONTAINER(HRGLArrayMat4)

HRGL_OPTIONAL_CONTAINER(HRGLAttributeI)
HRGL_OPTIONAL_CONTAINER(HRGLAttributeF)
HRGL_OPTIONAL_CONTAINER(HRGLAttributeB)

HRGL_OPTIONAL_CONTAINER(HRGLAttributeVec2f)
HRGL_OPTIONAL_CONTAINER(HRGLAttributeVec3f)
HRGL_OPTIONAL_CONTAINER(HRGLAttributeVec4f)

HRGL_OPTIONAL_CONTAINER(HRGLAttributeVec2i)
HRGL_OPTIONAL_CONTAINER(HRGLAttributeVec3i)
HRGL_OPTIONAL_CONTAINER(HRGLAttributeVec4i)

HRGL_OPTIONAL_CONTAINER(HRGLAttributeVec2b)
HRGL_OPTIONAL_CONTAINER(HRGLAttributeVec3b)
HRGL_OPTIONAL_CONTAINER(HRGLAttributeVec4b)

HRGL_OPTIONAL_CONTAINER(HRGLColorTexture)

