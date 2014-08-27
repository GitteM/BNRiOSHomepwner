//
//  BNRDateViewController.m
//  Homepwner
//
//  Created by Brigitte Michau on 2014/08/27.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRDateViewController.h"
#import "BNRItem.h"

@interface BNRDateViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *dateCreated;

@end

@implementation BNRDateViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationItem.title = @"Change Date";
    
    [self.dateCreated setDate:self.item.dateCreated
                     animated:YES];
}

- (IBAction)modifyDateCreated:(id)sender {
    self.item.dateCreated = [sender date];
}

@end
