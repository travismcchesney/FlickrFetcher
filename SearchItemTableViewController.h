//
//  SearchItemTableViewController.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/20/12.
//
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "SearchItemParameter.h"

@interface SearchItemTableViewController : CoreDataTableViewController

@property (nonatomic, strong) SearchItemParameter *searchParameter;

@end
