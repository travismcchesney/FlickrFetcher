//
//  Vacation+Create.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/16/12.
//
//

#import "Vacation.h"

@interface Vacation (Create)

+ (Vacation *)vacationWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context;

@end
