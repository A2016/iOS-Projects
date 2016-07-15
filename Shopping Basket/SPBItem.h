//
//  SPBItem.h
//  Shopping Basket
//
//  Created by Alok on 06/07/15.
//
//

#import <Foundation/Foundation.h>

@interface SPBItem : NSObject<NSCoding>
{
    
}
@property NSString *uuid;
@property NSString *name;
@property float price;
@property BOOL inShoppingList;

#pragma mark -
#pragma mark Initialization
+ (SPBItem *)createItemWithName:(NSString *)name andPrice:(float)price;

@end
