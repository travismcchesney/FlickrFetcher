//
//  Place.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/21/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Vacation;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) Vacation *vacation;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
