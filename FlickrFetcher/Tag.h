//
//  Tag.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/16/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Photo *photo;

@end
