//
//  Tag+Create.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/18/12.
//
//

#import "Tag.h"

@interface Tag (Create)

+ (Tag *)tagWithName:(NSString *)name
    inManagedObjectContext:(NSManagedObjectContext *)context;

@end
