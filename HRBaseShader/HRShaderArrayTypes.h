//
//  HRShaderArrayTypes.hpp
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 21/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "HRShaderType.h"
#import <UIKit/UIKit.h>

HRGLVec2f hrglVec2fFromCGPoint(CGPoint point);
HRGLVec2f hrglVec2fFromCGSize(CGSize size);
HRGLVec4f hrglVec4fFromCGRect(CGRect rect);

HRGLVec2f hrglVec2fFromCGPointWithScaleFactor(CGPoint point,CGFloat scaleFactor);
HRGLVec2f hrglVec2fFromCGSizeWithScaleFactor(CGSize size,CGFloat scaleFactor);
HRGLVec4f hrglVec4fFromCGRectWithScaleFactor(CGRect rect,CGFloat scaleFactor);

@interface HRGLBaseObject : NSObject

+ (size_t) size;
- (size_t) size;
@property (nonatomic, assign, readonly) const void* rowData;

@end

#define INTERFACE_FOR_GL_OBJECT(TYPE) \
@interface TYPE##Object : HRGLBaseObject \
\
+ (instancetype) objValue:(TYPE) value;\
\
@property (nonatomic, assign , readonly) TYPE value;\
\
- (instancetype) initWithValue:(TYPE) value;\
@end\
@protocol TYPE##Object<NSObject> @end


INTERFACE_FOR_GL_OBJECT(HRGLInt);
INTERFACE_FOR_GL_OBJECT(HRGLFloat);
INTERFACE_FOR_GL_OBJECT(HRGLBool);

INTERFACE_FOR_GL_OBJECT(HRGLVec2f);
INTERFACE_FOR_GL_OBJECT(HRGLVec3f);
INTERFACE_FOR_GL_OBJECT(HRGLVec4f);

INTERFACE_FOR_GL_OBJECT(HRGLVec2i);
INTERFACE_FOR_GL_OBJECT(HRGLVec3i);
INTERFACE_FOR_GL_OBJECT(HRGLVec4i);

INTERFACE_FOR_GL_OBJECT(HRGLVec2b);
INTERFACE_FOR_GL_OBJECT(HRGLVec3b);
INTERFACE_FOR_GL_OBJECT(HRGLVec4b);

INTERFACE_FOR_GL_OBJECT(HRGLMat2);
INTERFACE_FOR_GL_OBJECT(HRGLMat3);
INTERFACE_FOR_GL_OBJECT(HRGLMat4);

@interface HRGLArray<__covariant ObjectType>  : NSObject

@property (nonatomic, assign) BOOL isNeedUpdate;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign,readonly) size_t itemSize;

- (instancetype) initWithItemSize:(size_t) itemSize;

- (instancetype) arrayWithRowObjects:(void*) rowObjects count:(NSInteger) count;
- (instancetype) arrayWithArray:(NSArray<ObjectType>*) objects;

- (void)  setRowObjects:(void*) objects
                atIndex:(NSInteger) index
              withCount:(NSInteger) count;

- (void)  setRowObject:(void*) object
               atIndex:(NSInteger) index;

- (void) setRowObjects:(void*) objects withCount:(NSInteger) count;
- (void) replaseObject:(ObjectType) object atIndex:(NSInteger) index;
- (void) replaseObjects:(NSArray<ObjectType>*)objects forIndex:(NSInteger)index;

- (void) addInPopObjects:(NSArray<ObjectType>*)objects;
- (void) addInPopObject:(ObjectType) object;

- (void) addInPopRowObjects:(void*)objects count:(NSInteger) count;
- (void) addInPopRowObject:(void*) object;

- (void*) rowObjectAtIndex:(NSUInteger) index;
- (ObjectType)objectAtIndex:(NSUInteger)index;

@end

#define INTERFACE_FOR_GL_ARRAY_OBJECTS(TYPE,NAME)\
@interface NAME : HRGLArray \
@property (nonatomic, assign, readonly) const TYPE* rowData;\
- (void) setRows:(TYPE*) objects atIndex:(NSInteger) index withCount:(NSInteger) count;\
- (void) setRow:(TYPE) object atIndex:(NSInteger) index;\
- (void) setRows:(TYPE*) objects withCount:(NSInteger) count;\
- (void) addInPopRows:(TYPE*)objects count:(NSInteger) count;\
- (void) addInPopRow:(TYPE) object;


INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLInt,HRGLArrayI); @end
INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLFloat,HRGLArrayF);@end
INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLBool,HRGLArrayB);@end

INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLVec2f,HRGLArrayVec2f);@end
INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLVec3f,HRGLArrayVec3f);@end
INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLVec4f,HRGLArrayVec4f);@end

INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLVec2b,HRGLArrayVec2b);@end
INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLVec3b,HRGLArrayVec3b);@end
INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLVec4b,HRGLArrayVec4b);@end

INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLVec2i,HRGLArrayVec2i);@end
INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLVec3i,HRGLArrayVec3i);@end
INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLVec4i,HRGLArrayVec4i);@end

INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLMat2,HRGLArrayMat2);
@property (nonatomic, assign) BOOL transposition;
@end

INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLMat3,HRGLArrayMat3);
@property (nonatomic, assign) BOOL transposition;
@end

INTERFACE_FOR_GL_ARRAY_OBJECTS(HRGLMat4,HRGLArrayMat4);
@property (nonatomic, assign) BOOL transposition;
@end

#define INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(TYPE,NAME) \
INTERFACE_FOR_GL_ARRAY_OBJECTS(TYPE,NAME)\
@property (nonatomic, assign, readonly) GLuint glType;

INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(HRGLInt,HRGLAttributeI)@end
INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(HRGLFloat,HRGLAttributeF)@end
INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(HRGLBool,HRGLAttributeB)@end

INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec2f,HRGLAttributeVec2f)@end
INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec3f,HRGLAttributeVec3f)@end
INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec4f,HRGLAttributeVec4f)@end

INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec2b,HRGLAttributeVec2b)@end
INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec3b,HRGLAttributeVec3b)@end
INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec4b,HRGLAttributeVec4b)@end

INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec2i,HRGLAttributeVec2i)@end
INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec3i,HRGLAttributeVec3i)@end
INTERFACE_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec4i,HRGLAttributeVec4i)@end


#import "HRGLColorTexture.h"

