//
//  SPBEditItemViewController.h
//  Shopping Basket
//
//  Created by Alok Pandey on 07/07/15.
//
//

#import <UIKit/UIKit.h>
#import "SPBItem.h"

@class SPBItem;
@protocol SPBEditItemViewControllerDelegate;

@interface SPBEditItemViewController : UIViewController
{
    
}

@property IBOutlet UITextField *nameTextField;
@property IBOutlet UITextField *priceTextField;

@property(nonatomic,strong) SPBItem *item;
@property (weak) id<SPBEditItemViewControllerDelegate> delegate;

@end

@protocol SPBEditItemViewControllerDelegate <NSObject>
- (void)controller:(SPBEditItemViewController *)controller didUpdateItem:(SPBItem *)item;
@end