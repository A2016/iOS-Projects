//
//  SPBListViewController.h
//  Shopping Basket
//
//  Created by Alok on 06/07/15.
//
//

#import <UIKit/UIKit.h>
#import "SPBAddItemViewController.h"
#import "SPBEditItemViewController.h"

@interface SPBListViewController : UITableViewController<SPBAddItemViewControllerDelegate,SPBEditItemViewControllerDelegate>

@end
