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
#import "MapViewController.h"
#import "FlickrPlaceAnnotation.h"

@interface FlickrFetcherPlacesViewController () <MapViewControllerDelegate>
@property (nonatomic, strong) NSArray *places;
@property (strong, nonatomic) UIBarButtonItem *mapButton;

@end

@implementation FlickrFetcherPlacesViewController

@synthesize places = _places;

- (void)setPlaces:(NSArray *)places
{
    if (_places != places){
        _places = places;
        [self.tableView reloadData];
    }
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self startWait];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("places downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *photos = [FlickrFetcher topPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.places = photos;
            [self endWait];
        });
    });
    dispatch_release(downloadQueue);
}

- (void)viewDidUnload
{
    [self setMapButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPlacesPhotos"]) {
        NSDictionary *selectedPlace = [self.places objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        [segue.destinationViewController setPlace:selectedPlace];
    } else if ([segue.identifier isEqualToString:@"ShowMap"]) {
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setAnnotations:[self mapAnnotations]];
    }
}

- (void)startWait
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.mapButton = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
}

- (void)endWait
{
    self.navigationItem.rightBarButtonItem = self.mapButton;
}

#pragma mark - MapViewControllerDelegate

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.places count]];
    for (NSDictionary *place in self.places) {
        [annotations addObject:[FlickrPlaceAnnotation annotationForPlace:place]];
    }
    return annotations;
}

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    return nil;
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
    
    FlickrPlaceAnnotation *annotation = [FlickrPlaceAnnotation annotationForPlace:[self.places objectAtIndex:indexPath.row]];
    
    cell.textLabel.text = [annotation title];
    cell.detailTextLabel.text = [annotation subtitle];
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
