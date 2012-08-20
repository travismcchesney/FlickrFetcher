//
//  Photo+Flickr.h
//  Photomania
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo
               forVacationName:(NSString *)vacationName
        inManagedObjectContext:(NSManagedObjectContext *)context;

@end
