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

@interface FlickrFetcherPhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation FlickrFetcherPhotoViewController
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize photoImage = _photoImage;
@synthesize spinner = _spinner;

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

        [self updatePhotoImageWithPhoto:photo];
    }
}

- (void)setPhotoImage:(UIImage *)photoImage
{
    if (_photoImage != photoImage){
        _photoImage = photoImage;
        [self updateView];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    [self.spinner startAnimating];
    if (self.splitViewController != nil){
        self.spinner.frame = CGRectMake(0, 0, 100, 100);
        [self.scrollView addSubview:self.spinner];

    } else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    }
}

- (void)endWait
{
    if (self.splitViewController != nil){
        [self.spinner removeFromSuperview];

    } else{
        self.navigationItem.rightBarButtonItem = nil;
    }

}

@end
