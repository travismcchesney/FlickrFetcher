//
//  FlickrFetcherPhotoViewController.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrFetcherPhotoViewController.h"
#import "FlickrFetcher.h"

@interface FlickrFetcherPhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *photoImage;

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

- (void)setPhoto:(NSDictionary *)photo
{
    if (_photo != photo){
        _photo = photo;

        NSURL *photoUrl;
        NSData *urlData;
        
        photoUrl = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
        urlData = [NSData dataWithContentsOfURL:photoUrl];
        self.photoImage = [UIImage imageWithData:urlData];
        
        [self updateView];
    }
}

- (void)updateView
{
    self.scrollView.zoomScale = 1.0;
    //self.scrollView.contentSize = CGSizeZero;
    //self.scrollView.contentOffset = CGPointZero;
    
    NSLog(@"ScrollView bounds size height: %f, width: %f", self.scrollView.bounds.size.height, self.scrollView.bounds.size.width);
    
    NSLog(@"ScrollView bounds origin x: %f, y: %f", self.scrollView.bounds.origin.x, self.scrollView.bounds.origin.y);
    
    CGRect bounds = self.scrollView.bounds ;
    CGPoint scrollLoc = self.scrollView.contentOffset ;
    
    NSLog(@"bounds: %@ offset:%@"
          ,   NSStringFromCGRect(bounds)
          ,   NSStringFromCGPoint(scrollLoc)) ;
    

    
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
    NSString *title = [photo objectForKey:@"title"];
    
    return title ? title : [self descriptionForPhoto:photo];
}

- (NSString *)descriptionForPhoto:(id)photo
{
    NSString *description = [photo valueForKeyPath:@"description._content"];
    
    return description ? description : @"Unknown";
}

@end
