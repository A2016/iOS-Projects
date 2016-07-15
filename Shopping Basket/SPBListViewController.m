//
//  SPBListViewController.m
//  Shopping Basket
//
//  Created by Alok on 06/07/15.
//
//
#import "SPBAddItemViewController.h"
#import "SPBEditItemViewController.h"
#import "SPBListViewController.h"
#import "SPBItem.h"

@interface SPBListViewController ()

    @property NSMutableArray *items;
    @property SPBItem *selection;

@end

@implementation SPBListViewController

static NSString *CellIdentifier = @"Cell Identifier";

#pragma mark -
#pragma mark Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Set Title
        self.title = @"Items";
        // Load Items
        [self loadItems];
        // Add Observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateItemsList:) name:@"SPBAutoSyncDisabledNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadItemsList:) name:@"SPBItemsSeedsNotification" object:nil];
    }
    
    return self;
}

#pragma mark -
#pragma mark Notification Handling
- (void)reloadItemsList:(NSNotification *)notification {
    
    // Load Items
    [self loadItems];
    
    //Refreshing the items list
    [self.tableView reloadData];
}
- (void)updateItemsList:(NSNotification *)notification {
    
    for (int i = 0; i < [self.items count]; i++) {
        SPBItem *item = [self.items objectAtIndex:i];
        
        if ([item inShoppingList]) {
            // Update Item
            [[self.items objectAtIndex:i] setInShoppingList:NO];
        }
    }
    NSString *filePath = [self pathForItems];
    [NSKeyedArchiver archiveRootObject:self.items toFile:filePath];
    
    //Refreshing the items list
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register Class for Cell Reuse
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    // Create Add Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    // Create Edit Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editItems:)];
}
- (void)editItems:(id)sender {
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Actions
- (void)addItem:(id)sender {
    NSLog(@"Button was tapped.");
    [self performSegueWithIdentifier:@"AddItemViewController" sender:self];
}

#pragma mark -
#pragma mark Add Item View Controller Delegate Methods
- (void)controller:(SPBAddItemViewController *)controller didSaveItemWithName:(NSString *)name andPrice:(float)price {
    // Create Item
    SPBItem *item = [SPBItem createItemWithName:name andPrice:price];
    
    // Add Item to Data Source
    [self.items addObject:item];
    
    // Add Row to Table View
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.items count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // Save Items
    [self saveItems];
}

#pragma mark -
#pragma mark Edit Item View Controller Delegate Methods
- (void)controller:(SPBEditItemViewController *)controller didUpdateItem:(SPBItem *)item {
    // Fetch Item
    for (int i = 0; i < [self.items count]; i++) {
        SPBItem *anItem = [self.items objectAtIndex:i];
        
        if ([[anItem uuid] isEqualToString:[item uuid]]) {
            // Update Table View Row
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    // Save Items
    [self saveItems];
}

#pragma mark -
#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddItemViewController"]) {
       
        // Destination View Controller
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        
        // Fetch Add Item View Controller
        SPBAddItemViewController *vc = [nc.viewControllers firstObject];
        
        // Set Delegate
        [vc setDelegate:self];
    }else if ([segue.identifier isEqualToString:@"EditItemViewController"]) {
        
        // Fetch Edit Item View Controller
        SPBEditItemViewController *vc = (SPBEditItemViewController *)segue.destinationViewController;
        
        // Set Delegate
        [vc setDelegate:self];
        [vc setItem:self.selection];
    }
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Dequeue Reusable Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Fetch Item
    SPBItem *item = [self.items objectAtIndex:[indexPath row]];
    
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

// Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
     
     if ([indexPath row] == 1) {
     return NO;
     }
     
     return YES;
 }

// Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
     // Delete Item from Items
     [self.items removeObjectAtIndex:[indexPath row]];
     
     // Update Table View
     [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
     
     // Save Changes to Disk
     [self saveItems];
     }
 }

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Fetch Item
    SPBItem *item = [self.items objectAtIndex:[indexPath row]];
    
    // Update Item
    [item setInShoppingList:![item inShoppingList]];
    
    // Update Cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([item inShoppingList]) {
        [cell.imageView setImage:[UIImage imageNamed:@"checkmark"]];
    } else {
        [cell.imageView setImage:nil];
    }
    
    // Save Items
    [self saveItems];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // Fetch Item
    SPBItem *item = [self.items objectAtIndex:[indexPath row]];
    
    if (item) {
        // Update Selection
        [self setSelection:item];
        
        // Perform Segue
        [self performSegueWithIdentifier:@"EditItemViewController" sender:self];
    }
}

#pragma mark -
#pragma mark Helper Methods
- (void)loadItems {
    NSString *filePath = [self pathForItems];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        self.items = [NSMutableArray array];
    }
}
- (void)saveItems {
    NSString *filePath = [self pathForItems];
    [NSKeyedArchiver archiveRootObject:self.items toFile:filePath];
    
    // Post Notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SPBShoppingListDidChangeNotification" object:self];
}

- (NSString *)pathForItems {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}

@end
