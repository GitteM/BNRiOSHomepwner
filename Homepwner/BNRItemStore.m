//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Brigitte Michau on 2014/08/11.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation BNRItemStore

#pragma mark - Initializers

// If someone calls init, throw an exception
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BNRItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Here is the real secret initializer
- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - Class/Convenience Methods

+ (instancetype)sharedStore {

    static BNRItemStore *sharedStore = nil;

    // Do I need to create a sharedStore
    if (!sharedStore) {
        sharedStore = [[self alloc]initPrivate];
    }
    return sharedStore;
}

- (NSArray *)allItems {
    return self.privateItems;
}

- (BNRItem *)createItem {
    BNRItem *item = [BNRItem randomItem];
    [self.privateItems addObject:item];
    return item;
}

- (void)removeItem:(BNRItem *)item {
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    
    // get pointer to object being moved so that you can reinsert it
    BNRItem *item = self.privateItems[fromIndex];
    
    // remove item from the array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    // insert item in the array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
}

@end
