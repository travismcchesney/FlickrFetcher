//
//  Vacation+Create.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/16/12.
//
//

#import "Vacation+Create.h"

@implementation Vacation (Create)

+ (Vacation *)vacationWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    Vacation *vacation = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vacation"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *vacations = [context executeFetchRequest:request error:&error];
    
    if (!vacations || ([vacations count] > 1)) {
        // handle error
    } else if (![vacations count]) {
        vacation = [NSEntityDescription insertNewObjectForEntityForName:@"Vacation"
                                                     inManagedObjectContext:context];
        vacation.name = name;
        vacation.dateAdded = [[NSDate alloc] init];
    } else {
        vacation = [vacations lastObject];
    }
    
    return vacation;
}

@end
