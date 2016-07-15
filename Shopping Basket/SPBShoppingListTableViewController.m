//
//  SPBShoppingListTableViewController.m
//  Shopping Basket
//
//  Created by Alok Pandey on 07/07/15.
//
//

#import "SPBShoppingListTableViewController.h"

@interface SPBShoppingListTableViewController ()

@end

@implementation SPBShoppingListTableViewController

static NSString *CellIdentifier = @"Cell Identifier";

#pragma mark -
#pragma mark Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Set Title
        self.title = @"Shopping List";
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"SPBAutoSyncStatusForShoppingList"])
        {
            [self.autoSyncSwitch setSelected:YES];
            // Add Observer
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShoppingList:) name:@"SPBShoppingListDidChangeNotification" object:nil];
        }else{
            [self.autoSyncSwitch setSelected:NO];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"SPBShoppingListDidChangeNotification"
                                                          object:nil];
        }
    }
    
    return self;
}

#pragma mark -
#pragma mark View Life Cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load Items
    [self loadItems];
    // Register Class for Cell Reuse
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Setters & Getters
- (void)setItems:(NSArray *)items {
    if (_items != items) {
        _items = items;
        
        // Build Shopping List
        [self buildShoppingList];
    }
}
- (void)setShoppingList:(NSMutableArray *)shoppingList {
    if (_shoppingList != shoppingList) {
        _shoppingList = shoppingList;
        
        // Reload Table View
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.shoppingList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue Reusable Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Fetch Item
    SPBItem *item = [self.shoppingList objectAtIndex:[indexPath row]];
    
    // Configure Cell
    [cell.textLabel setText:[item name]];
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    // Show/Hide Checkmark
    if ([item inShoppingList]) {
        [cell.imageView setImage:[UIImage imageNamed:@"checkmark"]];
    } else {
        [cell.imageView setImage:nil];
    }
    
    return cell;
}

#pragma mark -
#pragma mark Notification Handling
- (void)updateShoppingList:(NSNotification *)notification {
    // Load Items
    [self loadItems];
}
#pragma mark -
#pragma mark Actions
- (IBAction)AutoSyncButtonClicked:(id)sender {

    BOOL isAutoSyncEnabled = YES;
    if ([sender isOn]) {
        NSLog(@"AutoSync ENABLED");
        isAutoSyncEnabled = YES;
    }
    else {
        NSLog(@"AutoSync DISABLED");
        isAutoSyncEnabled = NO;
        
        [self.shoppingList removeAllObjects];
        // Post Notification
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SPBAutoSyncDisabledNotification" object:self];
    }
    
    //stroring the auto sync flag so that items can be validated in prodcts list and basket list
    [[NSUserDefaults standardUserDefaults] setBool:isAutoSyncEnabled forKey:@"SPBAutoSyncStatusForShoppingList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];

}
#pragma mark -
#pragma mark Helper Methods
- (void)buildShoppingList {
    
    NSMutableArray *buffer = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.items count]; i++) {
        SPBItem *item = [self.items objectAtIndex:i];
        
        if ([item inShoppingList]) {
            // Add Item to Buffer
            [buffer addObject:item];
        }
    }
    
    // Set Shopping List
    self.shoppingList = [NSMutableArray arrayWithArray:buffer];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"SPBAutoSyncStatusForShoppingList"])
    {
        [self.autoSyncSwitch setSelected:YES];
    }else{
       [self.autoSyncSwitch setSelected:NO];
    }
}

- (void)loadItems {
    NSString *filePath = [self pathForItems];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {

        self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        self.items = [NSMutableArray array];
    }
}

- (NSString *)pathForItems {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}
@end
