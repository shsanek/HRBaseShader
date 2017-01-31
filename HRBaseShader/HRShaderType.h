//
//  HRShaderType.h
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 21/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#ifndef HRShaderType_h
#define HRShaderType_h

#import <OpenGLES/ES3/gl.h>

#pragma pack(push,1)

typedef GLint HRGLInt;
typedef GLfloat HRGLFloat;
typedef GLint HRGLBool;
typedef GLubyte HRGLByte;

typedef struct  {
    HRGLFloat x;
    HRGLFloat y;
}HRGLVec2f;

typedef struct  {
    HRGLFloat x;
    HRGLFloat y;
    HRGLFloat z;
}HRGLVec3f;

typedef struct  {
    HRGLFloat x;
    HRGLFloat y;
    HRGLFloat z;
    HRGLFloat w;
}HRGLVec4f;

typedef struct  {
    HRGLByte x;
    HRGLByte y;
    HRGLByte z;
    HRGLByte w;
}HRGLVec4B;

typedef struct  {
    HRGLInt x;
    HRGLInt y;
}HRGLVec2i;

typedef struct  {
    HRGLInt x;
    HRGLInt y;
    HRGLInt z;
}HRGLVec3i;

typedef struct  {
    HRGLInt x;
    HRGLInt y;
    HRGLInt z;
    HRGLInt w;
}HRGLVec4i;

typedef struct  {
    HRGLBool x;
    HRGLBool y;
}HRGLVec2b;

typedef struct  {
    HRGLBool x;
    HRGLBool y;
    HRGLBool z;
}HRGLVec3b;

typedef struct  {
    HRGLBool x;
    HRGLBool y;
    HRGLBool z;
    HRGLBool w;
}HRGLVec4b;

//typedef HRGLVec2i HRGLVec2b;
//typedef HRGLVec3i HRGLVec3b;
//typedef HRGLVec4i HRGLVec4b;

typedef struct  {
    HRGLVec2f a;
    HRGLVec2f b;
}HRGLMat2;

typedef struct  {
    HRGLVec2f a;
    HRGLVec2f b;
    HRGLVec2f c;
}HRGLMat3;

typedef struct  {
    HRGLVec2f a;
    HRGLVec2f b;
    HRGLVec2f c;
    HRGLVec2f d;
}HRGLMat4;

#pragma pack(pop)


#endif /* HRShaderType_h */
