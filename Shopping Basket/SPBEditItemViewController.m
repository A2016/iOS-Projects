//
//  SPBEditItemViewController.m
//  Shopping Basket
//
//  Created by Alok Pandey on 07/07/15.
//
//

#import "SPBEditItemViewController.h"
#import "SPBItem.h"

@interface SPBEditItemViewController ()
   
@end

@implementation SPBEditItemViewController

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Create Save Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    
    // Populate Text Fields
    if (self.item) {
        [self.nameTextField setText:[self.item name]];
        [self.priceTextField setText:[NSString stringWithFormat:@"%f", [self.item price]]];
    }
}

#pragma mark -
#pragma mark Actions
- (void)save:(id)sender {
    NSString *name = [self.nameTextField text];
    float price = [[self.priceTextField text] floatValue];
    
    // Update Item
    [self.item setName:name];
    [self.item setPrice:price];
    
    // Notify Delegate
    [self.delegate controller:self didUpdateItem:self.item];
    
    // Pop View Controller
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
