//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Brigitte Michau on 2014/08/28.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation BNRImageStore

#pragma mark - Initializers

+ (instancetype)sharedStore {
    
    static BNRImageStore * sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc]initPrivate];
    }
    
    return sharedStore;
}

// No one should call init
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BNRImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc]init];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {

    // short hand syntax
    self.dictionary[key] = image;
    
    // to replace
    // [self.dictionary setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key {
    
    // short hand syntax
     return self.dictionary[key];
    
    // to replace
    // return [self.dictionary objectForKey:key];
}

- (void)deleteImageForKey:(NSString *)key {
    if (!key) {
        return;
    }
    
    [self.dictionary removeObjectForKey:key];
}

@end
