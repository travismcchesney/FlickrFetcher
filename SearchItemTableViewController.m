//
//  SearchItemTableViewController.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/20/12.
//
//

#import "SearchItemTableViewController.h"
#import "VacationHelper.h"
#import "Tag.h"
#import "Place.h"
#import "VacationPhotosParameter.h"
#import "VacationPhotosTableViewController.h"

@interface SearchItemTableViewController ()

@property (nonatomic, strong) UIManagedDocument *vacation;

@end

@implementation SearchItemTableViewController

@synthesize searchParameter = _searchParameter;
@synthesize vacation = _vacation;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.searchParameter.searchOption];
    if ([self.searchParameter.searchOption isEqualToString:@"Tag"]) {
        request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"occurs"
                                                                                          ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)],
                                                            [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                          ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)], nil];
    } else if ([self.searchParameter.searchOption isEqualToString:@"Place"]) {
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dateAdded" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]];
    } else {
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    }
    // no predicate because we want ALL the search items
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.vacation.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)setSearchParameter:(SearchItemParameter *)searchParameter
{
    if (_searchParameter != searchParameter) {
        _searchParameter = searchParameter;
        self.title = _searchParameter.searchOption;
        
        [[VacationHelper instance] openVacation:_searchParameter.vacationName usingBlock:^(UIManagedDocument *vacation){
            self.vacation = vacation;
                [self setupFetchedResultsController];
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (void)viewWillAppear:(BOOL)animated
{
    //[self setupFetchedResultsController];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    id result = [self.fetchedResultsController objectAtIndexPath:indexPath]; // ask NSFRC for the NSMO at the row in question
    if ([result respondsToSelector:@selector(name)]) {

        NSString *objectTitle;
        
        objectTitle = [result valueForKey:@"name"];

        cell.textLabel.text = objectTitle;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *objectTitle;
    NSPredicate *predicate;
    id result = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    if ([result respondsToSelector:@selector(name)]) {
        objectTitle = [result valueForKey:@"name"];
    }
    VacationPhotosParameter *param = [[VacationPhotosParameter alloc] init];
    
    if ([self.searchParameter.searchOption isEqualToString:@"Place"]) {
        predicate = [NSPredicate predicateWithFormat:@"place.name = %@", objectTitle];
        
        param.predicate = predicate;
    } else if ([self.searchParameter.searchOption isEqualToString:@"Tag"]) {
        predicate = [NSPredicate predicateWithFormat:@"ANY tags.name = %@", objectTitle];
    }
    
    param.document = self.vacation;
    param.predicate = predicate;
    param.title = objectTitle;
    
    [(VacationPhotosTableViewController *)segue.destinationViewController setParameter:param];
}

@end
