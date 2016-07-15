//
//  SPBShoppingListTableViewController.h
//  Shopping Basket
//
//  Created by Alok Pandey on 07/07/15.
//
//

#import <UIKit/UIKit.h>
#import "SPBItem.h"


@interface SPBShoppingListTableViewController : UITableViewController
{
    
}
@property (nonatomic) NSArray *items;
@property (nonatomic) NSMutableArray *shoppingList;
@property IBOutlet UISwitch *autoSyncSwitch;

- (IBAction)AutoSyncButtonClicked:(id)sender;

@end
