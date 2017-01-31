//
//  HRGLColorTexture.m
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 28/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "HRGLColorTexture.h"
#import "HRShaderArrayTypes.h"
#import <math.h>

#define STEP(DEG,X) ((X < DEG) ? 0.f : 1.f)

HRGLVec4B hrglEncode32(Float32 f) {
    //Float32 e =5.0f;
    Float32 F = fabs(f);
    Float32 Sign = STEP(0,-f);
    Float32 Exponent = floor(log2(F));
    Float32 Mantissa = (exp2(- Exponent) * F);
    Exponent = floor(log2(F) + 127.0) + floor(log2(Mantissa));
    HRGLVec4B rgba;
    rgba.x = 128.0 * Sign  + floor(Exponent*exp2(-1.0));
    rgba.y = 128.0 * fmod(Exponent,2.0) + fmod(floor(Mantissa*128.0),128.0);
    rgba.z = floor(fmod(floor(Mantissa*exp2(23.0 -8.0)),exp2(8.0)));
    rgba.w = floor(exp2(23.0)*fmod(Mantissa,exp2(-15.0)));
    return rgba;
}

Float32 hrglDecode32(HRGLVec4B rgb) {
    HRGLVec4f rgba = {.x = rgb.x,.y = rgb.y,.z = rgb.z,.w = rgb.w};
    Float32 Sign = 1.0 - STEP(128.0,rgba.x)*2.0;
    Float32 Exponent = 2.0 * fmod(rgba.x,128.0) + STEP(128.0,rgba.y) - 127.0;
    Float32 Mantissa = fmod(rgba.y,128.0)*65536.0 + rgba.z*256.0 +rgba.w + (float)0x800000;
    Float32 Result =  Sign * exp2(Exponent) * (Mantissa * exp2(-23.0 ));
    return Result;
}



@interface HRGLColorTexture ()

@property (nonatomic, assign) GLubyte* textureData;
@property (nonatomic, assign) GLuint buffer;
@property (nonatomic, assign) GLuint lastBuffer;
@property (nonatomic, assign) BOOL isRender;
@property (nonatomic, assign) GLuint depthrenderbuffer;
@property (nonatomic, assign) HRGLVec4i lastViewPort;

@property (nonatomic, assign, readwrite) GLuint identifier;
@property (nonatomic, assign, readwrite) HRGLVec2f size;
@property (nonatomic, assign, readwrite) UIImage* image;
@property (nonatomic, assign, readwrite) const char* rowData;
@property (nonatomic, assign, readwrite) Float32* array;
@property (nonatomic, assign, readwrite) Float32* floatResult;


@end

@implementation HRGLColorTexture

- (void) dealloc {
    if (_textureData) {
        free(_textureData);
    }
    if (_floatResult) {
        free(_floatResult);
    }
    if (_buffer) {
        glDeleteFramebuffers(1, &_buffer);
    }
    if (_depthrenderbuffer) {
        glDeleteRenderbuffers(1, &_depthrenderbuffer);
    }
    glDeleteTextures(1, &_identifier);
}

- (void) loadData:(GLubyte*) data size:(CGSize) size {
    _size = hrglVec2fFromCGSize(size);
    GLuint textureID;
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glGenTextures(1, &textureID);
    
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA8,
                 (GLsizei)size.width,
                 (GLsizei)size.height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 data);
    glGenerateMipmap(GL_TEXTURE_2D);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    // glBindTexture(GL_TEXTURE_2D, 0);
    
    _identifier = textureID;
    _textureData = data;
}


- (void)setRepeat:(BOOL)repeat {
    if (repeat == _repeat){
        return;
    }
    _repeat = repeat;
    GLint tex = 0;
    glGetIntegerv(GL_TEXTURE_BINDING_2D, &tex);
    glBindTexture(GL_TEXTURE_2D, self.identifier);
    if (!repeat) {
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    } else {
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    }
    glBindTexture(GL_TEXTURE_2D,tex);
}

- (void) loadFromImage:(UIImage*) image {
    _image = image;
    CGImageRef imageRef = [image CGImage];
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    GLubyte* textureData = (GLubyte *)malloc(width * height * 4); // if 4 components per pixel (RGBA)
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(textureData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    [self loadData:textureData size:CGSizeMake(width, height)];
}

- (instancetype) init{
    self = [super init];
    if (self) {
        _image = nil;
        _floatResult = NULL;
        _textureData = NULL;
    }
    return self;
}

- (instancetype) initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        [self loadFromImage:image];
    }
    return self;
}

- (instancetype) initWithSize:(CGSize) size{
    self = [super init];
    if (self) {
        GLubyte * data = malloc(size.width * size.height * 4);
        for (int i = 0; i < size.width * size.height * 4; i++) {
            data[i] = 0;
        }
        [self loadData:(GLubyte *)data size:size];
    }
    return self;
}

- (instancetype) initWithRowData:(GLubyte *)rowData withSize:(CGSize)size {
    self = [super init];
    if (self) {
        GLubyte * data = malloc(size.width * size.height * 4);
        memcpy(data, rowData, size.width * size.height * 4);
        [self loadData:(GLubyte *)data size:size];
    }
    return self;
}

- (instancetype) initWithArray:(Float32 *)array withSize:(CGSize)size {
    self = [super init];
    if (self) {
        char * data = malloc(size.width * size.height * 4);
        for (int i = 0; i < size.width * size.height; i++) {
            HRGLVec4B vec = hrglEncode32(array[i]);
            memcpy(data + (i * 4), &vec, 4);
        }
        [self loadData:(GLubyte *)data size:size];
    }
    return self;
}




- (void) loadTextureData{
    if (_textureData){
        return;
    }
    GLint drawFboId = 0;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &drawFboId);
    [self loadBuff];
    glBindFramebuffer(GL_FRAMEBUFFER, self.buffer);
    NSInteger myDataLength = self.size.x * self.size.y * 4;
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, self.size.x, self.size.y, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    
    for(int y = 0; y < self.size.y; y++){
        for(int x = 0; x < self.size.x * 4; x++){
            buffer2[((int)self.size.y - y - 1) * (int)self.size.x * 4 + x] =
            buffer[y * 4 * (int)self.size.x + x];
        }
    }
    free(buffer);
    _textureData = buffer2;
    glBindFramebuffer(GL_FRAMEBUFFER, drawFboId);
}

#pragma mark - render
- (void)endRenderInTexture {
    NSAssert(self.isRender, @"not start render");
    self.isRender = NO;
    glBindFramebuffer(GL_FRAMEBUFFER,self.lastBuffer);
    glViewport(self.lastViewPort.x,
               self.lastViewPort.y,
               self.lastViewPort.z,
               self.lastViewPort.w);
}

- (void) loadBuff{
    if (self.buffer == 0) {
        GLuint FramebufferName = 0;
        
        glGenFramebuffers(1, &FramebufferName);
        
        glBindFramebuffer(GL_FRAMEBUFFER, FramebufferName);
        
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _identifier, 0);
        
        self.buffer = FramebufferName;
    }
}

- (void) loadDepthBuffer {
    if (self.depthrenderbuffer == 0) {
        GLuint depthrenderbuffer;
        glGenRenderbuffers(1, &depthrenderbuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, self.buffer);
        glBindRenderbuffer(GL_RENDERBUFFER, depthrenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, self.size.x, self.size.y);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthrenderbuffer);
        self.depthrenderbuffer = depthrenderbuffer;
    }
}

- (void)startRenderInTexture {
    [self startRenderInTextureWithDepth:NO];
}

- (void)startRenderInTextureWithDepth:(BOOL)depth {
    GLint drawFboId = 0;
    
    glGetIntegerv(GL_VIEWPORT, (GLint*)&_lastViewPort );
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &drawFboId);
    self.lastBuffer = drawFboId;
    if (_textureData) {
        free(_textureData);
    }
    if (_floatResult) {
        free(_floatResult);
    }
    _floatResult = NULL;
    _textureData = NULL;
    _image = nil;
    
    [self loadBuff];
    if (depth) {
        [self loadDepthBuffer];
    }
    glBindFramebuffer(GL_FRAMEBUFFER, self.buffer);
    glViewport(0,0,_size.x,_size.y);
    self.isRender = YES;
}


#pragma mark - GET
- (UIImage *)image {
    if (_image) {
        return _image;
    }
    [self loadTextureData];
    NSInteger myDataLength = self.size.x * self.size.y * 4;
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, _textureData, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * self.size.x;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(self.size.x, self.size.y, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    _image = [UIImage imageWithCGImage:imageRef];
    return _image;
}

- (Float32 *)array {
    [self loadTextureData];
    if (!_floatResult) {
        _floatResult = malloc(sizeof(Float32) * self.size.x * self.size.y);
        for (int i = 0; i < self.size.x * self.size.y; i++) {
            _floatResult[(int)(self.size.x * self.size.y) - i - 1] = hrglDecode32((HRGLVec4B)(*((HRGLVec4B*)(&(_textureData[i * 4])))));
        }
    }
    return _floatResult;
}

- (const char *)rowData {
    [self loadTextureData];
    return (const char *)_textureData;
}

@end

@interface HRGLValueTexture ()

@property (nonatomic, assign) BOOL isDepthLastValue;

@end

@implementation HRGLValueTexture

- (void) loadData:(GLubyte*) data size:(CGSize) size {
    self.size = hrglVec2fFromCGSize(size);
    GLuint textureID;
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glGenTextures(1, &textureID);
    
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_DEPTH_COMPONENT32F,
                 (GLsizei)size.width,
                 (GLsizei)size.height,
                 0,
                 GL_DEPTH_COMPONENT,
                 GL_FLOAT,
                 data);
    glGenerateMipmap(GL_TEXTURE_2D);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    // glBindTexture(GL_TEXTURE_2D, 0);
    
    self.identifier = textureID;
    self.textureData = data;
}

- (void) loadBuff{
    if (self.buffer == 0) {
        GLuint FramebufferName = 0;
        
        glGenFramebuffers(1, &FramebufferName);
        
        glBindFramebuffer(GL_FRAMEBUFFER, FramebufferName);
        
        GLuint colorBuffer;
        glGenRenderbuffers(1, &colorBuffer);
        
        glBindRenderbuffer(GL_RENDERBUFFER, colorBuffer);
        
        glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8, self.size.x, self.size.y);
        
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorBuffer);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, self.identifier, 0);
        
        self.buffer = FramebufferName;
        self.depthrenderbuffer = colorBuffer;
    }
}

- (void) loadDepthBuffer {
    if (self.depthrenderbuffer == 0) {
//        GLuint depthrenderbuffer;
//        glGenRenderbuffers(1, &depthrenderbuffer);
//        glBindFramebuffer(GL_FRAMEBUFFER, self.buffer);
//        glBindRenderbuffer(GL_RENDERBUFFER, depthrenderbuffer);
//        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, self.size.x, self.size.y);
//        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthrenderbuffer);
//    
//        self.depthrenderbuffer = depthrenderbuffer;
    }
}

- (void) loadTextureData{
    if (self.textureData){
        return;
    }
    
    glBindTexture(GL_TEXTURE_2D,self.identifier);
    glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_R32F, 0, 0, self.size.x, self.size.y, 0);
}

- (void)startRenderInTextureWithDepth:(BOOL)depth {
    
    self.isDepthLastValue =  glIsEnabled(GL_DEPTH_TEST);
    [super startRenderInTextureWithDepth:depth];
    glClearDepthf(1.);
    glEnable(GL_DEPTH_TEST);
    glClear(GL_DEPTH_BUFFER_BIT);
}

- (void) endRenderInTexture {
    [super endRenderInTexture];
    if (!self.isDepthLastValue){
        glDisable(GL_DEPTH_TEST);
    }
    
}

@end
