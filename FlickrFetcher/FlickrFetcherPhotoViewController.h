//
//  FlickrFetcherPhotoViewController.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface FlickrFetcherPhotoViewController : UIViewController <UISplitViewControllerDelegate, SplitViewBarButtonItemPresenter>
@property (nonatomic, strong) NSDictionary *photo;
@end
