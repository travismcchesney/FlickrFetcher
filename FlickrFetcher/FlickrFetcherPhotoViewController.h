//
//  FlickrFetcherPhotoViewController.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"
#import "Photo.h"

@interface FlickrFetcherPhotoViewController : UIViewController <UISplitViewControllerDelegate, SplitViewBarButtonItemPresenter>
@property (nonatomic, strong) NSDictionary *photo;
@property (nonatomic, strong) Photo *vacationPhoto;
@property (nonatomic) BOOL onVacation;
@end
