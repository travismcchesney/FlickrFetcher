//
//  FlickrFetcherPlacesViewController.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrFetcherPlacesViewController.h"
#import "FlickrFetcher.h"
#import "FlickrFetcherPhotosViewController.h"

@interface FlickrFetcherPlacesViewController ()
@property (nonatomic, strong) NSArray *places;
@end

@implementation FlickrFetcherPlacesViewController

@synthesize places = _places;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.places = [FlickrFetcher topPlaces];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPlacesPhotos"]){
        NSDictionary *selectedPlace = [self.places objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        NSArray *photosForPlace = [FlickrFetcher photosInPlace:selectedPlace maxResults:50];
        [segue.destinationViewController setPhotos:photosForPlace];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSString *place = [[self.places objectAtIndex:indexPath.row] objectForKey:@"_content"];
    NSArray *parts = [place componentsSeparatedByString:@", "];
    NSString *placePart1;
    NSString *placePart2;
    NSString *placePart3;
    
    if ([parts count] > 0) placePart1 = [parts objectAtIndex:0];
    if ([parts count] > 1) placePart2 = [parts objectAtIndex:1];
    if ([parts count] > 2) placePart3 = [parts objectAtIndex:2];
    
    cell.textLabel.text = placePart1;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", placePart2, placePart3, nil];
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
