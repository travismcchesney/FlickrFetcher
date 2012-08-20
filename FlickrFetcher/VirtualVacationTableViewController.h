//
//  VirtualVacationTableViewController.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/14/12.
//
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface VirtualVacationTableViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *vacationDatabase;
@end
