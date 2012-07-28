//
//  FlickrFetcherPhotosViewController.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrFetcherPhotosViewController : UITableViewController
@property (nonatomic, strong) NSArray *photos; // Array of NSDictionary photo objects
@end
