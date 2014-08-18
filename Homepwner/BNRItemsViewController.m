//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by Brigitte Michau on 2014/08/11.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation BNRItemsViewController

#pragma mark - Initializers

- (instancetype)init {
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[BNRItemStore sharedStore]createItem];
        }
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return self.init;
}

#pragma mark - Managing the View
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImageView *backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg640x1136.png"]];
    self.tableView.backgroundView = backgroundImage;
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
    self.tableView.rowHeight = 60.0;
    
    
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];

    
}

#pragma mark - UITableViewDataSource Protocol Required Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    cell.userInteractionEnabled = NO;
    cell.backgroundColor = [UIColor clearColor];
    
    // Set the text on the cell with the description of item
    // that is at the nth index of items, where n = row this cell
    // will appear on in the tableview
    
    switch (indexPath.section) {
        case 0: // Expensive Items
            if (indexPath.row == [[[BNRItemStore sharedStore]expensiveItems] count]) {
                [self lastRowOfTableView:cell];
            } else {
                NSArray *items = [[BNRItemStore sharedStore]expensiveItems];
                BNRItem *item = items[indexPath.row];
                cell.textLabel.text = [item description];
                [self itemsFontForCell:cell];
            } break;
        case 1: // Economical Items
            if (indexPath.row == [[[BNRItemStore sharedStore]economicalItems] count]) {
                [self lastRowOfTableView:cell];
            } else {
                NSArray *items = [[BNRItemStore sharedStore]economicalItems];
                BNRItem *item = items[indexPath.row];
                cell.textLabel.text = [item description];
                [self itemsFontForCell:cell];
            } break;
        default:
            break;
    }
    
    return cell;
}

- (void) itemsFontForCell:(UITableViewCell *)cell {
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 18.0 ]; // asking for 20.0 but it is too big
    cell.textLabel.font  = myFont;
    cell.textLabel.textColor = [UIColor darkGrayColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float rowHeight = 60;
    
    switch (indexPath.section) {
        case 0: // Expensive Items
            if (indexPath.row == [[[BNRItemStore sharedStore]expensiveItems] count]) {
                rowHeight = 44.0;
            } break;
        case 1: // Economical Items
            if (indexPath.row == [[[BNRItemStore sharedStore]economicalItems] count]) {
                rowHeight = 44.0;
            } break;
        default: break;
    }
    
    return rowHeight;
}

- (void)lastRowOfTableView:(UITableViewCell *)cell {
    
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 14.0 ];
    cell.textLabel.font  = myFont;
    cell.textLabel.text = @"No More Items";
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return [[[BNRItemStore sharedStore]economicalItems]count] + 1;
    } else {
        return [[[BNRItemStore sharedStore]expensiveItems]count] + 1;
    }
}

#pragma mark - UITableViewDataSource Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return @"Item value more than $50";
    } else {
        return @"Item value less than $50";
    }
}

@end
