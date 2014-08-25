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

@interface BNRItemsViewController () <UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation BNRItemsViewController

#pragma mark - Initializers

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {}
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return self.init;
}

#pragma mark - Managing the View
- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *headerView = self.headerView;
    [self.tableView setTableHeaderView:headerView];
}

#pragma mark - Implement HeaderView

- (UIView *)headerView {
    
    // if you not have loaded the header yet
    
    if (!_headerView) {
        
        // load HeaderView.xib
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
    }
    
    return _headerView;
}

#pragma mark - Header Methods

- (IBAction)addNewItem:(id)sender {
    
    // create a new BNRItem
    BNRItem *newItem = [[BNRItemStore sharedStore]createItem];
    
    // figure out where that item is in the array
    NSInteger lastrow = [[[BNRItemStore sharedStore]allItems]indexOfObject:newItem];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastrow inSection:0];
    
    // insert this new row into the table
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
}

- (IBAction)toggleEditingMode:(id)sender {

    if (self.isEditing) {
        
        // change title of the button to inform the user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        // turn off editing mode
        [self setEditing:NO animated:YES];
    } else {
        
        // change title of the button the inform the user of state
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        // enter editing mode
        [self setEditing:YES animated:YES];
  
    }
}


#pragma mark - UITableViewDataSource Protocol Required Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[[BNRItemStore sharedStore]allItems]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    // Get a new or recycled cell
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                    forIndexPath:indexPath];
    
    // Set the text on the cell with the description of item
    // that is at the nth index of items, where n = row this cell
    // will appear on in the tableview
    
    NSArray *items = [[BNRItemStore sharedStore]allItems];
    BNRItem *item = items[indexPath.row];
    
    cell.textLabel.text = [item description];
    
    return cell;
}

#pragma mark - UITableViewDataSource Protocol Methods

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {

    // if the tableview is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore]allItems];
        
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore]removeItem:item];
        
        // also remove that row from the table view with animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}

#pragma mark - UITableViewDelegate Instance Methods

- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

@end
