//
//  BNRItem.m
//  RandomItems
//
//  Created by Brigitte Michau on 2014/07/31.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

#pragma mark - Initializers

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber {
    
    // Call the superclass's designated initializer
    
    self = [super init];
    
    // Did the superclass's designated initializer succeed?
    
    if (self) {
        
        // give the instances variables initial values
        
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        
        // set _dateCreated to the current date and time
        
        _dateCreated = [[NSDate alloc]init];
    }
    
    // Return the address of the newly initialized object
    
    return self;
}

- (instancetype)initWithItemName:(NSString *)name
                    serialNumber:(NSString *)sNumber {
    return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}

- (instancetype)initWithItemName:(NSString *)name {
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}

- (instancetype)init {
    return [self initWithItemName:@"Item"];
}

#pragma mark - Class/Convenience Methods

+ (instancetype)randomItem {
    
    // Create an immutable array of three adjectives
    NSArray *randomAdjectives = @[ @"Fluffy", @"Rusty", @"Shiny"];

    // Create an immutable array of three nouns
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];

    // Get the index of a random adjective/noun from the lists
    // Note: The % operator, called the modulo operator, gives
    // you the remainder. So adjectiveIndex is a random number
    // from 0 to 2 inclusive
    
    NSInteger adjectiveIndex = arc4random() % [randomAdjectives count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    // Note that NSInteger is not an object, but a type definition for long
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            randomAdjectives[adjectiveIndex],
                            randomNounList[nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    'O' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    'O' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    'O' + arc4random() % 10];
    
    BNRItem *newItem = [[self alloc]initWithItemName:randomName
                                      valueInDollars:randomValue
                                        serialNumber:randomSerialNumber];
    return newItem;
}

#pragma mark - Overriding the Description method

- (NSString *)description {
    
    NSString *descriptionString = [[NSString alloc]initWithFormat:@"%@ (%@): Worth $%d",
                                   self.itemName,
                                   self.serialNumber,
                                   self.valueInDollars];
    return descriptionString;
}

- (void)dealloc {
    NSLog(@"Destroyed: %@", self);
}

@end
