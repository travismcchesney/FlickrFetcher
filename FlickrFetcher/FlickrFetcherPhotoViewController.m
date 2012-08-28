//
//  FlickrFetcherPhotoViewController.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrFetcherPhotoViewController.h"
#import "FlickrFetcher.h"
#import "FlickrFetcherCache.h"
#import "DejalActivityView.h"
#import "SplitViewBarButtonItemPresenter.h"
#import "VacationHelper.h"
#import "Photo+Flickr.h"
#import "Vacation.h"
#import "Place.h"

@interface FlickrFetcherPhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic) BOOL visited;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *visitUnvisitButton;

@end

@implementation FlickrFetcherPhotoViewController
@synthesize visitUnvisitButton = _visitUnvisitButton;
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize vacationPhoto = _vacationPhoto;
@synthesize photoImage = _photoImage;
@synthesize spinner = _spinner;
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize onVacation = _onVacation;

#define DEFAULT_VACATION_NAME @"My Vacation"

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
    [self.splitViewController setPresentsWithGesture:NO];
}

- (UIActivityIndicatorView *)spinner
{
    if (!_spinner){
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _spinner;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setPhoto:(NSDictionary *)photo
{
    if (_photo != photo){
        _photo = photo;
        
        if (_photo) {
            self.vacationPhoto = nil;
            [self determineVisitedforVacationName:DEFAULT_VACATION_NAME];
            [self updatePhotoImageWithPhoto:self.photo];
            self.onVacation = NO;
        }
    }
}

- (void)setVacationPhoto:(Photo *)vacationPhoto
{
    if (_vacationPhoto != vacationPhoto){
        _vacationPhoto = vacationPhoto;
        
        if (_vacationPhoto) {
            [self determineVisitedforVacationName:_vacationPhoto.place.vacation.name];
            if (!self.photo)
                [self updatePhotoImageWithVacationPhoto:_vacationPhoto];
            
            self.photo = nil;
        }
    }
}

- (void)setPhotoImage:(UIImage *)photoImage
{
    if (_photoImage != photoImage){
        _photoImage = photoImage;
        [self updateView];
    }
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Photos";
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

- (void)determineVisitedforVacationName:(NSString *)vacationName
{
    self.visited = NO;
    self.visitUnvisitButton.title = @"Visit";

    self.visitUnvisitButton.enabled = NO;
    
    if (self.photo){
        NSString *uniqueId = [self.photo objectForKey:FLICKR_PHOTO_ID];
        
        // Determine if the current photo has been visited and set button title accordingly
        [[VacationHelper instance] openVacation:vacationName usingBlock:^(UIManagedDocument *vacation){
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
            request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",uniqueId];
            request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
            
            NSError *error;
            NSArray *photos = [vacation.managedObjectContext executeFetchRequest:request error:&error];
            
            if (!photos)
                NSLog(@"Error fetching photos: %@", [error localizedDescription]);
            
            if ([photos count] >= 1) {
                self.visited = YES;
                self.visitUnvisitButton.title = @"Unvisit";
            }
            else {
                self.visited = NO;
                self.visitUnvisitButton.title = @"Visit";
            }
            
            if (self.photo) {
                self.visitUnvisitButton.enabled = YES;
                //self.vacationPhoto = [photos lastObject];
            }
                
        }];
    } else if (self.vacationPhoto) {
        self.visited = YES;
        self.visitUnvisitButton.title = @"Unvisit";
        self.visitUnvisitButton.enabled = YES;
    }
}

- (void)updatePhotoImageWithPhoto:(NSDictionary *)photo
{
    [self startWait];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("photo downloader", NULL);
    dispatch_async(downloadQueue, ^{
        UIImage *image;
        
        image = [FlickrFetcherCache imageForPhoto:photo];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.photo == photo && self.imageView.window){
                self.photoImage = image;
            } else{
                NSLog(@"PhotoChanged");
            }
            [self endWait];
        });
    });
    dispatch_release(downloadQueue);
}

- (void)updatePhotoImageWithVacationPhoto:(Photo *)photo
{
    [self startWait];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("photo downloader", NULL);
    dispatch_async(downloadQueue, ^{
        UIImage *image;

        NSData *urlData;
        
        urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.imageURL]];
        image = [UIImage imageWithData:urlData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.vacationPhoto == photo && self.imageView.window){
                self.photoImage = image;
            } else{
                NSLog(@"PhotoChanged");
            }
            [self endWait];
        });
    });
    dispatch_release(downloadQueue);
}

- (void)updateView
{
    self.scrollView.zoomScale = 1.0;
    
    CGSize size = CGSizeMake(self.photoImage.size.width, self.photoImage.size.height);
    //CGSize size = CGSizeMake(self.photoImage.size.height, self.photoImage.size.width);
    self.scrollView.contentSize = size;
    self.imageView.frame = CGRectMake(0, 0, self.photoImage.size.width, self.photoImage.size.height);
    
    self.imageView.image = self.photoImage;
    self.title = [self titleForPhoto:self.photo];
    CGFloat photoHeight = self.imageView.image.size.height;
    CGFloat photoWidth = self.imageView.image.size.width;
    
    if (photoWidth >= photoHeight && !(self.scrollView.frame.size.width > self.scrollView.frame.size.height)){
        [self.scrollView zoomToRect:CGRectMake(0, 0, 1.0, photoHeight) animated:YES];
    } else{
        [self.scrollView zoomToRect:CGRectMake(0, 0, photoWidth, 1.0) animated:YES];
    }
    
    [self.scrollView flashScrollIndicators];
}

- (IBAction)visitUnvisit:(UIBarButtonItem *)sender
{
    if (self.visited) {
        if (self.vacationPhoto) {
            [[VacationHelper instance] openVacation:DEFAULT_VACATION_NAME usingBlock:^(UIManagedDocument *vacation){
                [vacation.managedObjectContext deleteObject:self.vacationPhoto];
                sender.title = @"Unvisit";
                self.visited = YES;
                [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
                    if (!success)
                        NSLog(@"Could not save photo to vacation");
                }];
                if (self.onVacation) {
                    self.vacationPhoto = nil;
                    self.photoImage = nil;
                }
            }];
        }
        
        sender.title = @"Visit";
        self.visited = NO;
        
        if (self.onVacation)
            sender.enabled = NO;
    } else {
        // Open the default "My Vacation" vacation since there is no mechanism to choose a different vacation.
        [[VacationHelper instance] openVacation:DEFAULT_VACATION_NAME usingBlock:^(UIManagedDocument *vacation){
            self.vacationPhoto = [Photo photoWithFlickrInfo:self.photo
                                            forVacationName:DEFAULT_VACATION_NAME
                                     inManagedObjectContext:vacation.managedObjectContext];
            sender.title = @"Unvisit";
            self.visited = YES;
            [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
                if (!success)
                    NSLog(@"Could not save photo to vacation");
            }];
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.splitViewController.delegate = self;
    [self.splitViewController setPresentsWithGesture:NO];
    
    [self updatePhotoImageWithPhoto:self.photo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateView];
    
    [self determineVisitedforVacationName:DEFAULT_VACATION_NAME];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [self setToolbar:nil];
    [self setVisitUnvisitButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

- (NSString *)titleForPhoto:(id)photo
{
    NSString *title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    
    return title ? title : [self descriptionForPhoto:photo];
}

- (NSString *)descriptionForPhoto:(id)photo
{
    NSString *description = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return description ? description : @"Unknown";
}

- (void)startWait
{
    [DejalBezelActivityView activityViewForView:self.scrollView];
}

- (void)endWait
{
    [DejalBezelActivityView removeViewAnimated:YES];
}

@end
