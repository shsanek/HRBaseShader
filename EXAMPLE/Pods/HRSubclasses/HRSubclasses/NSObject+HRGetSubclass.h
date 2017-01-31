//
//  NSObject+GetSubclass.h
//  HRSubclasses
//
//  Created by Alexander Shipin on 30/09/2016.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRProperty : NSObject

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* type;
@property (nonatomic,strong) NSArray<NSString*>* parameters;

@end

@interface NSObject (HRGetSubclass)

+ (NSArray*) hrSubclasses;

+ (NSArray<HRProperty*>*) hrPropertys;

+ (NSArray<HRProperty*>*) hrAllPropertys;

@end
