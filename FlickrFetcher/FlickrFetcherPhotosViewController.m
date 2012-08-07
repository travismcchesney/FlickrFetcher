//
//  FlickrFetcherPhotosViewController.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrFetcherPhotosViewController.h"
#import "FlickrFetcherPhotoViewController.h"
#import "FlickrFetcher.h"
#import "RecentPhotos.h"
#import "MapViewController.h"
#import "FlickrPhotoAnnotation.h"

@interface FlickrFetcherPhotosViewController () <MapViewControllerDelegate>
@property (nonatomic, strong) NSArray *photos;
@property (strong, nonatomic) UIBarButtonItem *mapButton;
@end

@implementation FlickrFetcherPhotosViewController

@synthesize photos = _photos;
@synthesize place = _place;

-(void)setPhotos:(NSArray *)photos
{
    if (_photos != photos){
        _photos = photos;
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

    [self startWait];
    dispatch_queue_t downloadQueue = dispatch_queue_create("place photos downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *photosForPlace = [FlickrFetcher photosInPlace:self.place maxResults:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = photosForPlace;
            [self endWait];
        });
    });
    dispatch_release(downloadQueue);
    
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
    if ([segue.identifier isEqualToString:@"ShowPhoto"]){
        NSDictionary *currentPhoto = [self.photos objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        [segue.destinationViewController setPhoto:currentPhoto];
    } else if ([segue.identifier isEqualToString:@"ShowMap"]) {
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setAnnotations:[self mapAnnotations]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            UIInterfaceOrientationIsLandscape(interfaceOrientation));
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
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    return nil;
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
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photos";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSString *title = [[self.photos objectAtIndex:indexPath.row] objectForKey:FLICKR_PHOTO_TITLE];
    NSString *description = [[self.photos objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    cell.textLabel.text = title ? title : description ? description : @"Unknown";
    cell.detailTextLabel.text = description ? description : @"";
    //NSLog(@"%@", [self.photos objectAtIndex:indexPath.row]);
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
    id detail = [self.splitViewController.viewControllers lastObject];
    if ([detail isKindOfClass:[FlickrFetcherPhotoViewController class]]) {
        FlickrFetcherPhotoViewController *photoVC = (FlickrFetcherPhotoViewController *)detail;
        photoVC.photo = [self.photos objectAtIndex:indexPath.row];
    }
}

@end
