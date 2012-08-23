//
//  Photo+Flickr.m
//  Photomania
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Tag+Create.h"
#import "Place+Create.h"
#import "Vacation+Create.h"
#import "Tag.h"

@implementation Photo (Flickr)

// 9. Query the database to see if this Flickr dictionary's unique id is already there
// 10. If error, handle it, else if not in database insert it, else just return the photo we found
// 11. Create a category to Photographer to add a factory method and use it to set whoTook
// (then back to PhotographersTableViewController)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo
               forVacationName:(NSString *)vacationName
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if ([matches count] == 0) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
        
        NSArray *flickrTags = [[flickrInfo objectForKey:FLICKR_TAGS] componentsSeparatedByString:@" "];
        NSMutableSet *tags = [[NSMutableSet alloc] initWithCapacity:[flickrTags count]];
        for (NSString *tag in flickrTags) {
            // Exclude any tags containing a colon
            NSRange range = [tag rangeOfString:@":"
                                       options:NSCaseInsensitiveSearch];
            if(range.location == NSNotFound) {
                Tag *toAdd = [Tag tagWithName:[tag capitalizedString] inManagedObjectContext:context];
                toAdd.occurs = [NSNumber numberWithInt:[toAdd.occurs intValue] + 1];
                [tags addObject:toAdd];
            }
        }
        photo.tags = tags;
        
        photo.place = [Place placeWithName:[flickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME] inManagedObjectContext:context];
        photo.place.vacation = [Vacation vacationWithName:vacationName inManagedObjectContext:context];
    } else {
        photo = [matches lastObject];
    }
    
    return photo;
}

- (void)prepareForDeletion
{
    // If we're the last photo for this tag, delete the tag
    for (Tag *tag in self.tags) {
        tag.occurs = [NSNumber numberWithInt:[tag.occurs intValue] - 1];
        if ([tag.occurs intValue] <= 0) {
            [self.managedObjectContext deleteObject:tag];
        }
    }
    
    // If we're the last photo in this place, delete the place
    if (self.place && [self.place.photos count] <= 1)
        [self.managedObjectContext deleteObject:self.place];
}

@end
