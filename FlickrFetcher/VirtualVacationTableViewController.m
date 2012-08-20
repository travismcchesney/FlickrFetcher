//
//  VirtualVacationTableViewController.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/14/12.
//
//

#import "VirtualVacationTableViewController.h"
#import "VacationHelper.h"

@interface VirtualVacationTableViewController ()

@property (nonatomic, strong) NSArray *vacations;

@end

@implementation VirtualVacationTableViewController

@synthesize vacations = _vacations;

- (void)setVacations:(NSArray *)vacations
{
    if (_vacations != vacations)
        _vacations = vacations;
    
    [self.tableView reloadData];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSError *error;
    
    NSArray *vacationFileURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    
    NSMutableArray *vacationNames = [[NSMutableArray alloc] initWithCapacity:[vacationFileURLs count]];
    
    for (NSURL *vacationFileURL in vacationFileURLs) {
        [vacationNames addObject:[vacationFileURL lastPathComponent]];
    }
    
    if (error)
        NSLog(@"Couldn't get vacation files: %@", [error localizedDescription]);
    else
        self.vacations = vacationNames;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.vacations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VacationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.vacations objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
