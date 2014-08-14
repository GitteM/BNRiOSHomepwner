//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Brigitte Michau on 2014/08/11.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNRItem;

@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

@property (nonatomic, readonly) NSArray *expensiveItems;
@property (nonatomic, readonly) NSArray *economicalItems;

#pragma mark - Class/Convenience Methods

// To get the singleton of BNRItemStore
+ (instancetype)sharedStore;

- (BNRItem *)createItem;

@end
