//
//  Place+Create.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/18/12.
//
//

#import "Place+Create.h"

@implementation Place (Create)

+ (Place *)placeWithName:(NSString *)name
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *places = [context executeFetchRequest:request error:&error];
    
    if (!places || ([places count] > 1)) {
        // handle error
    } else if (![places count]) {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place"
                                              inManagedObjectContext:context];
        place.name = name;
        place.dateAdded = [[NSDate alloc] init];
    } else {
        place = [places lastObject];
    }
    
    return place;
}


@end
