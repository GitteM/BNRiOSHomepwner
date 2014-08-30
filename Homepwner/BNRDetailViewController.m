//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Brigitte Michau on 2014/08/26.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface BNRDetailViewController ()
< UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate >

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trash;

@end

@implementation BNRDetailViewController

#pragma mark - Managing the View

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    BNRItem *item = self.item;
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    // You need an NSDateFormatter that will turn a date into a simple date string
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateFormat = NSDateFormatterNoStyle;
    }
    
    // Use filtered NSDate to set the date label contents
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *imageKey = self.item.itemKey;
    // Get the image for the image key from the image store
    UIImage *imageToDisplay = [[BNRImageStore sharedStore]imageForKey:imageKey];
    
    // Use that image to put on to the screen in the image view
    self.imageView.image = imageToDisplay;
    
    
    // Enable the trash can only if there is an image attached to the item
    self.trash.enabled = (imageToDisplay) ? YES : NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

#pragma mark - Set Navigation bar title

- (void)setItem:(BNRItem *)item {
    _item = item;
    self.navigationItem.title = _item.itemName;
}

#pragma mark - Resign first responder

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Image processing

- (IBAction)takePicture:(id)sender {
    
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    
    NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    if ([availableTypes containsObject:(__bridge NSString*)kUTTypeMovie]) {
        [imagePickerController setMediaTypes:@[(__bridge NSString*)kUTTypeMovie]];
    }
    
    imagePickerController.mediaTypes = availableTypes;
    
    // If the device has a camera, take a picture. Otherwise select an image from the photo library
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.cameraOverlayView = [self crosshairOverlay];
    } else {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // Enable editing
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.delegate = self;
    
    // place image picker on the screen
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Get picked image from info dictionary
    // UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Get edited image form the info dictionary
    // UIImage *image = info[UIImagePickerControllerEditedImage];
    
    // Store the image in the BNRImageStore with a UUID key
    // [[BNRImageStore sharedStore] setImage:image
    //                               forKey:self.item.itemKey];
    
    // Put that image onto the screen in our UIImageView
    //self.imageView.image = image;
        
    NSURL *mediaURL = info[UIImagePickerControllerMediaURL];

    // Make sure the device supports video
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([mediaURL path])) {
    // save the video to the photo album
        UISaveVideoAtPathToSavedPhotosAlbum([mediaURL path], nil, nil, nil);
        
        //remove the video from the temporary directory
        [[NSFileManager defaultManager]removeItemAtPath:[mediaURL path] error:nil];
    }
    
    // Take image picker off the screen NB
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)removeImage:(id)sender {
    
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:@"Delete Image"
                               message:@"Select OK to delete the image"
                              delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Ok", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        self.imageView.image = nil;
        [[BNRImageStore sharedStore]deleteImageForKey:self.item.itemKey];
        self.trash.enabled = NO;
    }
}

#pragma mark -  Camera overlay
- (UIView *)crosshairOverlay {
    UIImage * crosshair = [UIImage imageNamed:@"crosshair.png"];
    
    CGRect frame;
    frame.origin.x = (self.view.frame.size.width - crosshair.size.width) / 2;
    frame.origin.y = (self.view.frame.size.height - crosshair.size.height) / 2;
    frame.size.width = crosshair.size.width;
    frame.size.height = crosshair.size.height;
    
    UIView *overlay = [[UIView alloc]initWithFrame:frame];
    overlay.backgroundColor = [UIColor colorWithPatternImage:crosshair];
    overlay.layer.opaque = NO;
    overlay.opaque = NO;
    
    return overlay;
}

@end

