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

@property (nonatomic) NSMutableArray *privateExpensiveItems;
@property (nonatomic) NSMutableArray *privateEconomicalItems;

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
        _privateExpensiveItems = [[NSMutableArray alloc]init];
        _privateEconomicalItems = [[NSMutableArray alloc]init];
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

- (NSArray *)expensiveItems {
    NSArray *sortedArray = [self sortArrayWith:self.privateExpensiveItems];
    return sortedArray;
}

- (NSArray *)economicalItems {
    NSArray *sortedArray = [self sortArrayWith:self.privateEconomicalItems];
    return sortedArray;
}

- (NSArray *)sortArrayWith:(NSArray *)a {
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"valueInDollars"
                                                                    ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray *sortedArray = [a sortedArrayUsingDescriptors:descriptors];
    return sortedArray;
}

- (BNRItem *)createItem {
    BNRItem *item = [BNRItem randomItem];
    [self.privateItems addObject:item];
    
    if (item.valueInDollars > 50) {
        [self.privateExpensiveItems addObject:item];
    } else {
        [self.privateEconomicalItems addObject:item];
    }
    
    return item;
}

@end
