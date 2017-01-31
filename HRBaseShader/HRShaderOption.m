//
//  HRShaderOption.m
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 15/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRShaderOption.h"

@interface HRShaderOption ()

- (void) update:(GLuint) programm;

@end

@implementation HRShaderOption

- (instancetype) initWithName:(NSString*) name {
    NSAssert(NO, @"incorect type");
    return nil;
}

- (instancetype) initWithName:(NSString*) name
                         type:(HRShaderOptionParametr) type{
    self = [super init];
    if (self) {
        _name = name;
        _type = type;
    }
    return self;
}

- (void) setNeedUpdate{
    _isNeedUpdate = YES;
}

- (void) linkFromProgramm:(GLuint) programm{
    const GLchar* name = [self.name UTF8String];
    if (self.type == HRShaderOptionParametrUniform) {
        _position = glGetUniformLocation (programm, name);
    } else {
        _position = glGetAttribLocation (programm, name);
    }
}

- (void) updateIfNeed:(GLuint) programm{
    if (self.isNeedUpdate) {
        [self update:programm];
        _isNeedUpdate = NO;
    }
}

- (void) update:(GLuint) programm{
    NSAssert(NO, @"not implementation incorrect type");
}

@end

#define IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(TYPE,FUNCTION) \
@implementation TYPE##ShaderOption\
- (instancetype) initWithName:(NSString*) name { \
    self = [super initWithName:name type:HRShaderOptionParametrUniform];\
    if (self) {\
    }\
    return self;\
}\
- (void) setValue:(TYPE) value{\
    _value = value;\
    [self setNeedUpdate];\
}\
\
- (void) update:(GLuint) programm{\
FUNCTION;\
}\


IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLInt,glUniform1i(self.position, _value));
@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLFloat,glUniform1f(self.position, _value));
@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLBool,glUniform1i(self.position, _value));
@end

IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLVec2i,glUniform2i(self.position, _value.x,_value.y));
@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLVec3i,glUniform3i(self.position, _value.x,_value.y,_value.z));
@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLVec4i,glUniform4i(self.position, _value.x,_value.y,_value.z,_value.w));
@end


IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLVec2b,glUniform2i(self.position, _value.x,_value.y));
@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLVec3b,glUniform3i(self.position, _value.x,_value.y,_value.z));
@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLVec4b,glUniform4i(self.position, _value.x,_value.y,_value.z,_value.w));
@end


IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLVec2f,glUniform2f(self.position, _value.x,_value.y));
@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLVec3f,glUniform3f(self.position, _value.x,_value.y,_value.z));
@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLVec4f,glUniform4f(self.position, _value.x,_value.y,_value.z,_value.w));
@end

IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLMat2,
                                              glUniformMatrix2fv(self.position,
                                                                 1,
                                                                 false,
                                                                 (HRGLFloat*)(& _value.a)));
@end

IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLMat3,
                                              glUniformMatrix2fv(self.position,
                                                                 1,
                                                                 false,
                                                                 (HRGLFloat*)(& _value.a)));
@end

IMPLEMENTATION_SHADER_OPTION_SUBCLASS_UNIFORM(HRGLMat4,
                                              glUniformMatrix2fv(self.position,
                                                                 1,
                                                                 false,
                                                                 (HRGLFloat*)(& _value.a)));
@end

//ARRAYS

#define IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(TYPE,FUNCTION,ITEM_TYPE) \
@implementation TYPE##ShaderOption\
- (instancetype) initWithName:(NSString*) name { \
self = [super initWithName:name type:HRShaderOptionParametrUniform];\
if (self) {\
_value = [TYPE new];\
}\
return self;\
}\
- (void) setValue:(TYPE*) value{\
_value = value;\
[self setNeedUpdate];\
}\
\
- (void) update:(GLuint) programm{\
FUNCTION(self.position,\
(GLsizei)_value.count,\
(const ITEM_TYPE*)_value.rowData);\
self.value.isNeedUpdate = NO;\
}\
\
- (BOOL)isNeedUpdate {\
return [super isNeedUpdate] || self.value.isNeedUpdate;\
}\


IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(HRGLArrayI,glUniform1iv,HRGLInt)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(HRGLArrayF,glUniform1fv,HRGLFloat)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(HRGLArrayB,glUniform1iv,HRGLBool)@end

//FLOAT VECTOR
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(HRGLArrayVec2f,glUniform2fv,HRGLFloat)@end
//IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(HRGLArrayVec3f,glUniform3fv,HRGLFloat)@end

@implementation HRGLArrayVec3fShaderOption
- (instancetype) initWithName:(NSString*) name {
    self = [super initWithName:name type:HRShaderOptionParametrUniform];
    if (self) {
        _value = [HRGLArrayVec3f new];
    }
    return self;
}

- (void) setValue:(HRGLArrayVec3f*) value{
    _value = value;
    [self setNeedUpdate];
}

- (void) update:(GLuint) programm{
    glUniform3fv(self.position,(GLsizei)_value.count,(const HRGLFloat*)_value.rowData);
    self.value.isNeedUpdate = NO;
}
- (BOOL)isNeedUpdate {
    return [super isNeedUpdate] || self.value.isNeedUpdate;
}
@end

IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(HRGLArrayVec4f,glUniform4fv,HRGLFloat)@end

//INT VECTOR
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(HRGLArrayVec2i,glUniform2iv,HRGLInt)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(HRGLArrayVec3i,glUniform3iv,HRGLInt)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(HRGLArrayVec4i,glUniform4iv,HRGLInt)@end

//BOOL VECTOR
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(HRGLArrayVec2b,glUniform2iv,HRGLBool)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(HRGLArrayVec3b,glUniform3iv,HRGLBool)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ARRAY_UNIFORM(HRGLArrayVec4b,glUniform4iv,HRGLBool)@end


//MATRIX
#define IMPLEMENTATION_SHADER_OPTION_SUBCLASS_MAT_ARRAY_UNIFORM(TYPE,FUNCTION,ITEM_TYPE) \
@implementation TYPE##ShaderOption\
- (instancetype) initWithName:(NSString*) name { \
self = [super initWithName:name type:HRShaderOptionParametrUniform];\
if (self) {\
_value = [TYPE new];\
}\
return self;\
}\
- (void) setValue:(TYPE*) value{\
_value = value;\
[self setNeedUpdate];\
}\
\
- (void) update:(GLuint) programm{\
FUNCTION(self.position,\
(GLboolean)_value.transposition,\
(GLsizei)_value.count,\
(const ITEM_TYPE*)_value.rowData);\
self.value.isNeedUpdate = NO;\
}\
\
- (BOOL)isNeedUpdate {\
    return [super isNeedUpdate] || self.value.isNeedUpdate;\
}\

IMPLEMENTATION_SHADER_OPTION_SUBCLASS_MAT_ARRAY_UNIFORM(HRGLArrayMat2,glUniformMatrix2fv,HRGLFloat)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_MAT_ARRAY_UNIFORM(HRGLArrayMat3,glUniformMatrix3fv,HRGLFloat)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_MAT_ARRAY_UNIFORM(HRGLArrayMat4,glUniformMatrix4fv,HRGLFloat)@end


#define IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(TYPE,NUMBERS) \
@implementation TYPE##ShaderOption\
- (instancetype) initWithName:(NSString*) name { \
self = [super initWithName:name type:HRShaderOptionParametrAttrib];\
if (self) {\
_value = [TYPE new];\
}\
return self;\
}\
- (void) setValue:(TYPE*) value{\
_value = value;\
[self setNeedUpdate];\
}\
\
- (void) update:(GLuint) programm{\
    glEnableVertexAttribArray(self.position);\
  glVertexAttribPointer(self.position, NUMBERS, self.value.glType, GL_FALSE, 0, (const GLvoid*)self.value.rowData);\
}\
\
- (BOOL)isNeedUpdate {\
return [super isNeedUpdate] || self.value.isNeedUpdate || YES;\
}\


IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(HRGLAttributeI,1)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(HRGLAttributeF,1)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(HRGLAttributeB,1)@end

IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(HRGLAttributeVec2f,2)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(HRGLAttributeVec3f,3)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(HRGLAttributeVec4f,4)@end

IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(HRGLAttributeVec2i,2)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(HRGLAttributeVec3i,3)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(HRGLAttributeVec4i,4)@end

IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(HRGLAttributeVec2b,2)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(HRGLAttributeVec3b,3)@end
IMPLEMENTATION_SHADER_OPTION_SUBCLASS_ATTRIBUTE(HRGLAttributeVec4b,4)@end


@implementation HRGLColorTextureShaderOption

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name type:(HRShaderOptionParametrUniform)];
    if (self) {

    }
    return self;
}

- (void)setValue:(HRGLColorTexture *)value {
    _value = value;
    [self setNeedUpdate];
}

- (void)update:(GLuint)programm {
    GLuint identifierTextureBlock = GL_TEXTURE0 + self.textureNumber;
    
    glActiveTexture(identifierTextureBlock);
    
    glBindTexture(GL_TEXTURE_2D,self.value.identifier);
    
    glUniform1i(self.position , self.textureNumber);
}

- (BOOL)isNeedUpdate {
    return YES;
}

@end

