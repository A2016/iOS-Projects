//
//  SPBAddItemViewController.m
//  Shopping Basket
//
//  Created by Alok on 06/07/15.
//
//

#import "SPBAddItemViewController.h"

@interface SPBAddItemViewController ()

@end

@implementation SPBAddItemViewController

#pragma mark -
#pragma mark Actions
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    // Extract User Input
    NSString *name = [self.nameTextField text];
    float price = [[self.priceTextField text] floatValue];
    
    // Notify Delegate
    [self.delegate controller:self didSaveItemWithName:name andPrice:price];
    
    // Dismiss View Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
