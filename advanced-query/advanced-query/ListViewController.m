//
//  ListViewController.m
//  advanced-query
//
//  Created by Matt Vaznaian on 9/29/12.
//  Copyright (c) 2012 StackMob. All rights reserved.
//

#import "ListViewController.h"
#import "AppDelegate.h"
#import "StackMob.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.managedObjectContext = [[self.appDelegate coreDataStore] contextForCurrentThread];
    
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Todo" inManagedObjectContext:self.managedObjectContext];
    
    [newManagedObject setValue:@"Hello World" forKey:@"title"];
    [newManagedObject setValue:[NSNumber numberWithInt:5] forKey:@"count"];
    [newManagedObject setValue:[newManagedObject assignObjectId] forKey:[newManagedObject primaryKeyField]];
    
    [self.managedObjectContext saveOnSuccess:^{
        NSLog(@"You created a new object!");
    } onFailure:^(NSError *error) {
        NSLog(@"There was an error! %@", error);
    }];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Todo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // EQUAL EXAMPLE
    NSPredicate *equalPredicate =[NSPredicate predicateWithFormat:@"title == %@", @"Hello World"];
    [fetchRequest setPredicate:equalPredicate];
    
    // LESS THAN EXAMPLE
    NSPredicate *lessThanPredicate =[NSPredicate predicateWithFormat:@"count > %d", 2];
    [fetchRequest setPredicate:lessThanPredicate];
    
    // COMPOUND PREDICATE using AND
    NSArray *predicates = [[NSArray alloc]initWithObjects:equalPredicate,lessThanPredicate,nil];
    NSPredicate *compoundPredicate =[NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    [fetchRequest setPredicate:compoundPredicate];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"An error %@, %@", error, [error userInfo]);
	}
    
    return _fetchedResultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [object valueForKey:@"title"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
