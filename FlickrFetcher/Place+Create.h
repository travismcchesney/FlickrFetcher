//
//  Place+Create.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/18/12.
//
//

#import "Place.h"

@interface Place (Create)

+ (Place *)placeWithName:(NSString *)name
        inManagedObjectContext:(NSManagedObjectContext *)context;

@end
