//
//  HRBaseShader.m
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 15/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRBaseShader.h"
#import <OpenGLES/ES3/gl.h>
#import "HRPivateBaseShader.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface HRBaseShader()

@property (nonatomic, assign) BOOL isLoad;

@end

@implementation HRBaseShader

+ (instancetype) loadPixelShaderWithName:(NSString*) name error:(NSError**) error{
    return [[self alloc] initPixelProgramm:name error:error];
}

+ (instancetype) loadVertexShaderWithName:(NSString*) name error:(NSError**) error{
    return [[self alloc] initVertexProgramm:name error:error];
}

- (void)dealloc {
    if (self.isLoad) {
        glDeleteShader(_programm);
    }
}

- (instancetype) initPixelProgramm:(NSString*) name error:(NSError**) error{
    self = [super init];
    if (self) {
        _programm = [self shaderWithName:name type:GL_FRAGMENT_SHADER error:error];
        if (error && *error != nil) {
            return nil;
        }
        _isLoad = YES;

    }
    return self;
}

- (instancetype) initVertexProgramm:(NSString*) name error:(NSError**) error{
    self = [super init];
    if (self) {
        _programm = [self shaderWithName:name type:GL_VERTEX_SHADER error:error];
        if (error && *error != nil) {
            return nil;
        }
        _isLoad = YES;
    }
    return self;
}

- (GLuint)shaderWithName:(NSString*)name type:(GLenum)type error:(NSError**) error {
    // Load the shader file
    NSString* file;
    if (type == GL_VERTEX_SHADER) {
        file = [[NSBundle mainBundle] pathForResource:name ofType:@"vsh"];
    } else if (type == GL_FRAGMENT_SHADER) {
        file = [[NSBundle mainBundle] pathForResource:name ofType:@"fsh"];
    }
    
    // Create the shader source
    const GLchar* source = (GLchar*)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    
    // Create the shader object
    GLuint shaderHandle = glCreateShader(type);
    
    // Load the shader source
    glShaderSource(shaderHandle, 1, &source, 0);
    
    // Compile the shader
    glCompileShader(shaderHandle);
    
    // Check for errors
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[1024];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        if (error) {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"OpenGL. Programm <file:%@> load error:\n%s",file,messages]
                                         code:0
                                     userInfo:nil];
        }
    }
    
    return shaderHandle;
}

@end



@implementation HRBaseShaderProgramm

- (void)dealloc {
    glDeleteProgram(self.programm);
}

+ (instancetype) programmVertexProgramm:(HRBaseShader*) vertexProgramm
                          pixelProgramm:(HRBaseShader*) pixelProgramm
                                  error:(NSError**) error{
    return [[self alloc] initWithVertexProgramm:vertexProgramm pixelProgramm:pixelProgramm error:error];
}

+ (instancetype) shaderWithName:(NSString*) name{
    NSError* error = nil;
    HRBaseShader* vertexShader = [HRBaseShader loadVertexShaderWithName:name error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    HRBaseShader* pixelShader = [HRBaseShader loadPixelShaderWithName:name error:&error];
    if (error){
        NSLog(@"%@",error);
    }
    id result = [self programmVertexProgramm:vertexShader pixelProgramm:pixelShader error:&error];
    if (error){
        NSLog(@"%@",error);
    }
    return result;
}

+ (instancetype)shader {
    return [self shaderWithName:NSStringFromClass([self class])];
}

- (instancetype)initWithVertexProgramm:(HRBaseShader *)vertexProgramm
                         pixelProgramm:(HRBaseShader *)pixelProgramm
                                 error:(NSError**) error{
    self = [super init];
    if (self) {
        _programm = [self programWithVertexProgramm:vertexProgramm pixelProgramm:pixelProgramm error:error];
        if (error && *error != nil) {
            return nil;
        }
        _isLoad = YES;
        [self addedAllDynamicProperty];
    }
    return self;
}

#pragma mark - Compile & Link
- (GLuint)programWithVertexProgramm:(HRBaseShader *)vertexProgramm
                      pixelProgramm:(HRBaseShader *)pixelProgramm
                              error:(NSError**) error{
    // Build shaders
    GLuint vertexShader = vertexProgramm.programm;
    GLuint fragmentShader = pixelProgramm.programm;
    
    // Create program
    GLuint programHandle = glCreateProgram();
    
    // Attach shaders
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    
    // Link program
    glLinkProgram(programHandle);
    
    // Check for errors
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[1024];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        *error = [NSError errorWithDomain:[NSString stringWithFormat:@"OpenGL. Programm  link error:\n%s",messages]
                                     code:0
                                 userInfo:nil];
    }
    return programHandle;
}

- (void) renderBeginMode:(uint) mode first:(GLint) index count:(GLsizei) count{
    [self configuration];
    glDrawArrays(mode, index, count);
    GLchar messages[1024];
    glGetProgramInfoLog(self.programm, sizeof(messages), 0, &messages[0]);
    if (messages[0] != 0) {
        NSLog(@"\n%s",messages);
    }
}

- (void) configuration {
    glUseProgram(_programm);
    for (HRShaderOption* opt in self.optionalsFromGet.allValues) {
        [opt updateIfNeed:_programm];
    }
}


#pragma mark - DYNAMIC PROPERY

+ (NSString*) setterName:(NSString*) name{
    NSString* setter = [NSString stringWithFormat:@"%@%@:",[[name substringToIndex:1] uppercaseString], [name substringFromIndex:1] ];
    return [@"set" stringByAppendingString:setter];
}

+ (NSString*) getterName:(NSString*) name{
    return name;
}

+ (void)initialize {
    [super initialize];
    [self addedSeterAndGetter];
}

+ (void) addedSeterAndGetter{
    NSArray<HRProperty*>* props = [self hrAllPropertys];
    NSArray<Class>* containers = [HRGLOptionalContainer hrSubclasses];
    
    for (HRProperty* property in props) {
        if (![[self allIgnoresPropertys] containsObject:property.name]) {
            BOOL added = NO;
            for (Class con in containers) {
                if ([((id)con) useCurrentContainerForString:property.type withOptions:property.parameters]) {
                    IMP setter = (IMP)[((id)con) setterImplementation];
                    IMP getter = (IMP)[((id)con) getterImplementation];
                    SEL set = NSSelectorFromString([self setterName:property.name]);
                    SEL get = NSSelectorFromString([self getterName:property.name]);
                    Method setMethod = class_getInstanceMethod([self class], set);
                    Method getMethod = class_getInstanceMethod([self class], get);

                    method_setImplementation(setMethod, setter);
                    method_setImplementation(getMethod, getter);
                    added = YES;
                    break;
                }
            }
            NSAssert(added, @"property not found type");
        }
    }
}

+ (NSArray<NSString*>*) ignorePropertys{
    return @[];
}

+ (NSArray<NSString*>*) defaultIgnorePropertys{
    return @[@"programm",@"isLoad",@"optionalsFromGet",@"optionalsFromSet",@"optionalsFromNames"];
}

+ (NSArray<NSString*>*) allIgnoresPropertys {
    return [[HRBaseShaderProgramm ignorePropertys] arrayByAddingObjectsFromArray:[HRBaseShaderProgramm defaultIgnorePropertys]];
}

- (void) addedAllDynamicProperty {
    NSArray<HRProperty*>* props = [[self class] hrAllPropertys];
    NSArray<Class>* containers = [HRGLOptionalContainer hrSubclasses];
    glUseProgram(_programm);
    NSMutableDictionary* setDic = [NSMutableDictionary new];
    NSMutableDictionary* getDic = [NSMutableDictionary new];
    unsigned int index = 0;
    for (HRProperty* property in props) {
        if (![[HRBaseShaderProgramm allIgnoresPropertys] containsObject:property.name]) {
            BOOL added = NO;
            for (Class con in containers) {
                if ([((id)con) useCurrentContainerForString:property.type withOptions:property.parameters]) {
                    NSString* set = [HRBaseShaderProgramm setterName:property.name];
                    NSString* get = [HRBaseShaderProgramm getterName:property.name];
                    HRShaderOption* opt = [((id)con) optionalWithName:property.name];
                    setDic[set] = opt;
                    getDic[get] = opt;
                    added = YES;
                    if ([opt isKindOfClass:[HRGLColorTextureShaderOption class]]) {
                        ((HRGLColorTextureShaderOption*)opt).textureNumber = index;
                        index++;
                    }
                    [opt linkFromProgramm:_programm];
                    break;
                }
            }
            NSAssert(added, @"property not found type");
        }
    }
    _optionalsFromGet = getDic;
    _optionalsFromSet = setDic;
    _optionalsFromNames = getDic;
}

@end
