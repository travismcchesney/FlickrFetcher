//
//  RecentPhotos.h
//  Calculator
//
//  Created by CS193p Instructor on 5/1/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentPhotos : NSObject

+ (void)addToRecents:(id)photo;
+ (NSArray *)RecentPhotos;
+ (int)indexForPhoto:(id)photoToFind inArray:(NSArray *)arr;

@end
