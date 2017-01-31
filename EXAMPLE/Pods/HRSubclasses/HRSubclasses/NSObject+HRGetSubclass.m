//
//  NSObject+GetSubclass.m
//  HRSubclasses
//
//  Created by Alexander Shipin on 30/09/2016.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import "NSObject+HRGetSubclass.h"
#import <objc/runtime.h>

@implementation HRProperty

@end

@implementation NSObject (HRGetSubclass)

+ (NSArray<NSString*>*)  hr__getDefaultProperty{
    static NSMutableArray* list ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        list = [NSMutableArray new];
        [list addObject:@"hash"];
        [list addObject:@"superclass"];
        [list addObject:@"description"];
        [list addObject:@"debugDescription"];
    });
    return list;
}

+ (NSString*) hr__getSubstring:(NSString*) string
          betweenFirstChar:(NSString*) firstChar
                secondChar:(NSString*) secondChar flag:(BOOL) flag{
    NSRange r1 = [string rangeOfString:firstChar];
    if (r1.location == NSNotFound) {
        return nil;
    }
    
    NSRange r2 = [[string substringFromIndex:r1.location + 1] rangeOfString:secondChar options:flag?NSBackwardsSearch:0] ;
    if (r2.location == NSNotFound) {
        return  nil;
    } else {
        r2.location += r1.location + 1;
    }
    NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
    NSString *sub = [string substringWithRange:rSub];
    return sub;
}

+ (NSArray<HRProperty*>*) hrPropertys{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    NSMutableArray* list = [NSMutableArray new];
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = property_getAttributes(property);
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            NSString *propertyType = [NSString stringWithCString:propType
                                                        encoding:[NSString defaultCStringEncoding]];
            if (![[self hr__getDefaultProperty] containsObject:propertyName]) {
                HRProperty* property = [HRProperty new];
                property.name = propertyName;
                property.type = propertyType;
                if ([propertyType rangeOfString:@"T@\""].location != NSNotFound) {
                    NSString* allType = [self hr__getSubstring:propertyType
                                              betweenFirstChar:@"\""
                                                    secondChar:@"\""
                                                          flag:NO];
                    NSString* parameters = [self hr__getSubstring:allType
                                                 betweenFirstChar:@"<"
                                                       secondChar:@">"
                                                             flag:YES];
                    if (parameters) {
                        property.type = [self hr__getSubstring:propertyType
                                              betweenFirstChar:@"\""
                                                    secondChar:@"<"
                                                          flag:NO];
                        property.parameters = [parameters componentsSeparatedByString:@"><"];
                    } else {
                        property.type = allType;
                    }
                } else {
                    NSString* allType = [self hr__getSubstring:propertyType
                                              betweenFirstChar:@"{"
                                                    secondChar:@"}"
                                                          flag:NO];
                    NSString* parameters = [self hr__getSubstring:allType
                                                 betweenFirstChar:@"<"
                                                       secondChar:@">"
                                                             flag:YES];
                    if (parameters) {
                        property.type = [self hr__getSubstring:propertyType
                                              betweenFirstChar:@"{"
                                                    secondChar:@"<"
                                                          flag:NO];
                        property.parameters = [parameters componentsSeparatedByString:@"><"];
                    } else {
                        if ([propertyType rangeOfString:@"Tf"].location == 0) {
                             allType = @"float";
                        }
                        if ([propertyType rangeOfString:@"Ti"].location == 0) {
                            allType = @"int";
                        }
                        property.type = allType;
                    }
                }
                [list addObject:property];
            }
        }
    }
    free(properties);
    return list;
}

+ (NSArray<HRProperty*>*) hrAllPropertys{
    NSMutableArray* list = [NSMutableArray new];
    Class obj = self;
    while (obj != [NSObject class]) {
        [list addObjectsFromArray:[obj hrPropertys]];
        obj = class_getSuperclass(obj);
    }
    return list;
}

+ (NSArray*) hrSubclasses{
    NSMutableArray* listSubclass = [NSMutableArray new];
    int count = objc_getClassList(nil, 0);
    Class* listClass = (Class*)malloc(sizeof(Class)*count);
    objc_getClassList(listClass, count);
    for ( int i = 0 ; i < count; i++) {
        Class superClass = class_getSuperclass(listClass[i]);
        while (superClass != nil && superClass != [self class]  ) {
            superClass = class_getSuperclass(superClass);
        }
        if ( superClass == [self class]  ) {
            [listSubclass addObject:listClass[i]];
        }
    }
    free(listClass);
    return listSubclass;
}

@end
