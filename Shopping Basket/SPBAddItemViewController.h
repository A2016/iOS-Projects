//
//  SPBAddItemViewController.h
//  Shopping Basket
//
//  Created by Alok on 06/07/15.
//
//

#import <UIKit/UIKit.h>

@class SPBAddItemViewController;
@protocol SPBAddItemViewControllerDelegate<NSObject>
- (void)controller:(SPBAddItemViewController *)controller didSaveItemWithName:(NSString *)name andPrice:(float)price;
@end


@interface SPBAddItemViewController : UIViewController
{
    
}

@property (weak) id<SPBAddItemViewControllerDelegate> delegate;
@property IBOutlet UITextField *nameTextField;
@property IBOutlet UITextField *priceTextField;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
