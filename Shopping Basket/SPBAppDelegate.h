//
//  SPBAppDelegate.h
//  Shopping Basket
//
//  Created by Alok on 06/07/15.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SPBListViewController.h"

@interface SPBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

