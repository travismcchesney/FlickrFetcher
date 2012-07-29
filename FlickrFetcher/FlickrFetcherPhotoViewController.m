//
//  FlickrFetcherPhotoViewController.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrFetcherPhotoViewController.h"

@interface FlickrFetcherPhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation FlickrFetcherPhotoViewController
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize photoImage = _photoImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.photoImage.size;
    self.imageView.frame = CGRectMake(0, 0, self.photoImage.size.width, self.photoImage.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.imageView.image = self.photoImage;
    self.title = [self titleForPhoto:self.photo];
    CGFloat photoHeight = self.imageView.image.size.height;
    CGFloat photoWidth = self.imageView.image.size.width;
    if (photoWidth >= photoHeight){
        [self.scrollView zoomToRect:CGRectMake(0, 0, 1.0, photoHeight) animated:YES];
        //[self.scrollView zoomToRect:CGRectMake(0, 0, self.photoImage.size.width, self.scrollView.bounds.size.height) animated:YES];
    } else{
        //[self.scrollView zoomToRect:CGRectMake(0, 0, self.scrollView.bounds.size.width, self.photoImage.size.height) animated:YES];
        [self.scrollView zoomToRect:CGRectMake(0, 0, photoWidth, 1.0) animated:YES];
    }//[self.scrollView zoomToRect:self.imageView.bounds animated:YES];
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{



}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

- (NSString *)titleForPhoto:(id)photo
{
    NSString *title = [photo objectForKey:@"title"];
    
    return title ? title : [self descriptionForPhoto:photo];
}

- (NSString *)descriptionForPhoto:(id)photo
{
    NSString *description = [photo valueForKeyPath:@"description._content"];
    
    return description ? description : @"Unknown";
}

@end
