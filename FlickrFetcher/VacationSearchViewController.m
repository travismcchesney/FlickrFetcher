//
//  VacationSearchViewController.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/16/12.
//
//

#import "VacationSearchViewController.h"
#import "SearchItemTableViewController.h"
#import "SearchItemParameter.h"

@interface VacationSearchViewController ()

@end

@implementation VacationSearchViewController

@synthesize vacationName = _vacationName;

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
    
    self.title = @"Search";

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Search"]) {
        NSString *searchOption = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].textLabel.text;
        
        SearchItemParameter *param = [[SearchItemParameter alloc] init];
        param.searchOption = [searchOption isEqualToString:@"Itinerary"] ? @"Place" : searchOption;
        param.vacationName = self.vacationName;
        ((SearchItemTableViewController *)segue.destinationViewController).searchParameter = param;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VacationSearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Itinerary";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Tag";
    } else {
        cell.textLabel.text = nil;
    }
    
    return cell;
}

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
