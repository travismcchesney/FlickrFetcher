//
//  FlickrFetcherRecentsViewController.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrFetcherRecentsViewController.h"
#import "FlickrFetcher.h"
#import "FlickrFetcherPhotoViewController.h"
#import "MapViewController.h"
#import "RecentPhotos.h"
#import "FlickrPhotoAnnotation.h"

@interface FlickrFetcherRecentsViewController () <MapViewControllerDelegate>
@property (nonatomic, strong) NSArray *recentPhotos;
@end

@implementation FlickrFetcherRecentsViewController

@synthesize recentPhotos = _recentPhotos;

- (void)setRecentPhotos:(NSArray *)recentPhotos
{
    _recentPhotos = recentPhotos;
    
    [[self tableView] reloadData];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowRecentPhoto"]){
        
        NSDictionary *currentPhoto = [self.recentPhotos objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        [segue.destinationViewController setPhoto:currentPhoto];
        
        [RecentPhotos addToRecents:currentPhoto];
    } else if ([segue.identifier isEqualToString:@"ShowMap"]) {
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setAnnotations:[self mapAnnotations]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.recentPhotos = [[[RecentPhotos RecentPhotos] reverseObjectEnumerator] allObjects];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

#pragma mark - MapViewControllerDelegate

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.recentPhotos count]];
    for (NSDictionary *photo in self.recentPhotos) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    return nil;
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
    return [self.recentPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Photos";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[self.recentPhotos objectAtIndex:indexPath.row] objectForKey:@"title"];
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = [self.splitViewController.viewControllers lastObject];
    if ([detail isKindOfClass:[FlickrFetcherPhotoViewController class]]) {
        FlickrFetcherPhotoViewController *photoVC = (FlickrFetcherPhotoViewController *)detail;
        photoVC.photo = [self.recentPhotos objectAtIndex:indexPath.row];
    }
}

@end
