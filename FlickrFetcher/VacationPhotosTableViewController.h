//
//  VacationPhotosTableViewController.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/21/12.
//
//

#import "CoreDataTableViewController.h"
#import "Place.h"
#import "VacationPhotosParameter.h"

@interface VacationPhotosTableViewController : CoreDataTableViewController

@property (nonatomic, strong) VacationPhotosParameter *parameter;

@end
