//
//  HRShaderArrayTypes.cpp
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 21/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#include "HRShaderArrayTypes.h"

HRGLVec2f hrglVec2fFromCGPoint(CGPoint point){
    return hrglVec2fFromCGPointWithScaleFactor(point, 1);
}
HRGLVec2f hrglVec2fFromCGSize(CGSize size){
    return hrglVec2fFromCGSizeWithScaleFactor(size, 1);
    
}
HRGLVec4f hrglVec4fFromCGRect(CGRect rect){
    return hrglVec4fFromCGRectWithScaleFactor(rect, 1);
}

HRGLVec2f hrglVec2fFromCGPointWithScaleFactor(CGPoint point,CGFloat scaleFactor){
    return (HRGLVec2f){.x = point.x * scaleFactor,.y = point.y * scaleFactor};
}
HRGLVec2f hrglVec2fFromCGSizeWithScaleFactor(CGSize size,CGFloat scaleFactor){
    return (HRGLVec2f){.x = size.width * scaleFactor,.y = size.height * scaleFactor};
}
HRGLVec4f hrglVec4fFromCGRectWithScaleFactor(CGRect rect,CGFloat scaleFactor){
    return (HRGLVec4f){
        .x = rect.origin.x * scaleFactor,
        .y = rect.origin.y * scaleFactor,
        .z = rect.size.width * scaleFactor,
        .w = rect.size.height * scaleFactor};
}


@implementation HRGLBaseObject

+ (size_t)size {
    NSAssert(NO, @"not implementation");
    return 0;
}

- (size_t)size {
    return [[self class] size];
}

- (const void *)rowData {
    NSAssert(NO, @"not implementation");
    return NULL;
}

@end

#define IMPLEMENTATION_FOR_GL_OBJECT(TYPE) \
@implementation TYPE##Object \
+ (instancetype) objValue:(TYPE) value{\
    return [[TYPE##Object alloc] initWithValue:value];\
}\
+ (size_t) size {\
    return sizeof(TYPE);\
}\
- (instancetype) initWithValue:(TYPE) value { \
    self = [super init];\
    if (self) {\
        _value = value;\
    }\
    return self;\
}\
- ( const void *)rowData {\
    return (const void *)&_value;\
}\
@end\

IMPLEMENTATION_FOR_GL_OBJECT(HRGLInt);
IMPLEMENTATION_FOR_GL_OBJECT(HRGLFloat);
IMPLEMENTATION_FOR_GL_OBJECT(HRGLBool);

IMPLEMENTATION_FOR_GL_OBJECT(HRGLVec2f);
IMPLEMENTATION_FOR_GL_OBJECT(HRGLVec3f);
IMPLEMENTATION_FOR_GL_OBJECT(HRGLVec4f);

IMPLEMENTATION_FOR_GL_OBJECT(HRGLVec2i);
IMPLEMENTATION_FOR_GL_OBJECT(HRGLVec3i);
IMPLEMENTATION_FOR_GL_OBJECT(HRGLVec4i);

IMPLEMENTATION_FOR_GL_OBJECT(HRGLVec2b);
IMPLEMENTATION_FOR_GL_OBJECT(HRGLVec3b);
IMPLEMENTATION_FOR_GL_OBJECT(HRGLVec4b);

IMPLEMENTATION_FOR_GL_OBJECT(HRGLMat2);
IMPLEMENTATION_FOR_GL_OBJECT(HRGLMat3);
IMPLEMENTATION_FOR_GL_OBJECT(HRGLMat4);

@implementation HRGLArray{
    void* _data;
    NSInteger _maxItemCount;
}

#pragma mark - memory managment
- (void) addedMaxItem:(NSInteger) maxItem {
    if (_maxItemCount > maxItem) {
        return;
    } else {
        maxItem += 10;
        if (maxItem - _maxItemCount < _maxItemCount / 2.) {
            maxItem = _maxItemCount + _maxItemCount / 2. + 10;
        }
        void* newMem = malloc(maxItem * _itemSize);
        if (_data) {
            memcpy(newMem, _data, self.count * _itemSize);
            free(_data);
        }
        _data = newMem;
        _maxItemCount = maxItem;
    }
}

- (void)dealloc {
    if (_data) {
        free(_data);
    }
}

#pragma mark - update object
- (instancetype)initWithItemSize:(size_t)sizeType {
    self = [super init];
    if (self) {
        _data = NULL;
        _itemSize = sizeType;
    }
    return self;
}

- (instancetype) initWithRowObjects:(void*) rowObjects
                           itemSize:(size_t) itemSize
                              count:(NSInteger) count{
    self = [self initWithItemSize:itemSize];
    if (self) {
        [self addedMaxItem:count];
        memcpy(_data, rowObjects, count * itemSize);
    }
    return self;
}

- (instancetype) initWithArray:(NSArray<HRGLBaseObject*>*) objects{
    size_t size = objects.firstObject.size;
    self = [self initWithItemSize:size];
    if (self) {
        [self replaseObjects:objects forIndex:0];
    }
    return self;
}

#pragma mark - new object

- (instancetype) arrayWithRowObjects:(void*) rowObjects count:(NSInteger) count{
    return [[[self class] alloc] initWithRowObjects:rowObjects
                                              itemSize:self.itemSize
                                                 count:count];
}

- (instancetype) arrayWithArray:(NSArray<HRGLBaseObject*>*) objects{
    NSAssert(objects.firstObject.size == self.itemSize, @"incorect size item");
    return [[[self class] alloc] initWithArray:objects];
}



#pragma mark - sets
- (void) setRowObjects:(void*) objects withCount:(NSInteger) count{
    _isNeedUpdate = YES;
    [self setRowObjects:objects atIndex:0 withCount:count];
}

- (void)  setRowObjects:(void*) objects
                atIndex:(NSInteger) index
              withCount:(NSInteger) count{
    _isNeedUpdate = YES;
    NSInteger maxCount = index + count;
    [self addedMaxItem:maxCount];
    if (_count < maxCount) {
        _count = maxCount;
    }
    memcpy(_data + (index * self.itemSize), objects, count * self.itemSize);
}

- (void)  setRowObject:(void*) object
               atIndex:(NSInteger) index{
    _isNeedUpdate = YES;
    [self setRowObjects:object atIndex:index withCount:1];
}

- (void) replaseObject:(HRGLBaseObject*) object atIndex:(NSInteger) index{
    _isNeedUpdate = YES;
    [self addedMaxItem:index + 1];
    if (index + 1 > self.count) {
        _count = index + 1;
    }
    memcpy(_data + (index * self.itemSize), object.rowData, self.itemSize);
}

- (void) replaseObjects:(NSArray<HRGLBaseObject*>*)objects
               forIndex:(NSInteger)index{
    _isNeedUpdate = YES;
    [self addedMaxItem:objects.count + index];
    if (objects.count + index > self.count) {
        _count = objects.count + index;
    }
    for (int i = 0; i < objects.count; i++) {
        HRGLBaseObject* obj = objects[i];
        memcpy(_data + ((i + index) * self.itemSize), obj.rowData, self.itemSize);
    }
}

- (void) addInPopObjects:(NSArray*)objects{
    [self replaseObjects:objects forIndex:self.count];
}

- (void) addInPopObject:(id) object{
    [self replaseObjects:@[object] forIndex:self.count];
}

- (void) addInPopRowObjects:(void*)objects count:(NSInteger) count{
    [self setRowObjects:objects atIndex:self.count withCount:count];
}

- (void) addInPopRowObject:(void*) object{
    [self setRowObjects:object atIndex:self.count withCount:1];
}

#pragma mark - gets
- (void *)rowObjectAtIndex:(NSUInteger)index {
    return _data + index * self.itemSize;
}

- (id)objectAtIndex:(NSUInteger)index{
    return nil;
}
@end

#define IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(TYPE,NAME)\
@implementation NAME : HRGLArray \
- (instancetype)init {\
self = [super initWithItemSize:sizeof(TYPE)];\
if (self) {\
}\
return self;\
}\
- (const TYPE*) rowData {\
    return (const TYPE*)[self rowObjectAtIndex:0];\
}\
- (void) setRows:(TYPE*) objects atIndex:(NSInteger) index withCount:(NSInteger) count{\
 [super setRowObjects:(void*)objects  atIndex:index withCount:count];\
}\
\
- (void) setRow:(TYPE) object atIndex:(NSInteger) index{\
[super setRowObject:(void*)&object atIndex:index];\
}\
\
- (void) setRows:(TYPE*) objects withCount:(NSInteger) count{\
[super setRowObjects:(void*)objects withCount:count];\
}\
\
- (void) addInPopRows:(TYPE*)objects count:(NSInteger) count{\
[super addInPopRowObjects:(void*)objects count:count];\
}\
\
- (void) addInPopRow:(TYPE) object{\
[super addInPopRowObject:(void*)&object];\
}\
\
- (id)objectAtIndex:(NSUInteger)index{\
    return [TYPE##Object objValue:self.rowData[index]];\
}


IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLInt,HRGLArrayI); @end
IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLFloat,HRGLArrayF);@end
IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLBool,HRGLArrayB);@end

IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLVec2f,HRGLArrayVec2f);@end
IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLVec3f,HRGLArrayVec3f);@end
IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLVec4f,HRGLArrayVec4f);@end

IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLVec2b,HRGLArrayVec2b);@end
IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLVec3b,HRGLArrayVec3b);@end
IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLVec4b,HRGLArrayVec4b);@end

IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLVec2i,HRGLArrayVec2i);@end
IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLVec3i,HRGLArrayVec3i);@end
IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLVec4i,HRGLArrayVec4i);@end

IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLMat2,HRGLArrayMat2);
- (void)setTransposition:(BOOL)transposition {
    if (_transposition == transposition) return;
    self.isNeedUpdate = YES;
    _transposition = transposition;
}
@end

IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLMat3,HRGLArrayMat3);
- (void)setTransposition:(BOOL)transposition {
    if (_transposition == transposition) return;
    self.isNeedUpdate = YES;
    _transposition = transposition;
}
@end

IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(HRGLMat4,HRGLArrayMat4);
- (void)setTransposition:(BOOL)transposition {
    if (_transposition == transposition) return;
    self.isNeedUpdate = YES;
    _transposition = transposition;
}
@end

#define IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(TYPE,NAME,GLTYPE)\
IMPLEMENTATION_FOR_GL_ARRAY_OBJECTS(TYPE,NAME)\
- (GLuint) glType { \
return GLTYPE;\
}

IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(HRGLInt,HRGLAttributeI,GL_INT);@end
IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(HRGLFloat,HRGLAttributeF,GL_FLOAT);@end
IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(HRGLBool,HRGLAttributeB,GL_INT);@end

IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec2f,HRGLAttributeVec2f,GL_FLOAT);@end
IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec3f,HRGLAttributeVec3f,GL_FLOAT);@end
IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec4f,HRGLAttributeVec4f,GL_FLOAT);@end

IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec2b,HRGLAttributeVec2b,GL_INT);@end
IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec3b,HRGLAttributeVec3b,GL_INT);@end
IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec4b,HRGLAttributeVec4b,GL_INT);@end

IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec2i,HRGLAttributeVec2i,GL_INT);@end
IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec3i,HRGLAttributeVec3i,GL_INT);@end
IMPLEMENTATION_FOR_GL_ATTRIBUTE_OBJECTS(HRGLVec4i,HRGLAttributeVec4i,GL_INT);@end



































