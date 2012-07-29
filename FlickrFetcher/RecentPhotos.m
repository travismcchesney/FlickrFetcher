//
//  RecentPhotos.m
//  Calculator
//
//  Created by CS193p Instructor on 5/1/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "RecentPhotos.h"

@implementation RecentPhotos

#define FAVORITES_KEY @"RecentPhotos.RecentssKey"

+ (void)addToRecents:(id)photo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentPhotos = [[defaults objectForKey:FAVORITES_KEY] mutableCopy];
    if (!recentPhotos) recentPhotos = [NSMutableArray array];
    
    int indexForPhoto = [[self class] indexForPhoto:photo inArray:recentPhotos];
    
    if (indexForPhoto > 0){
        [recentPhotos removeObjectAtIndex:indexForPhoto];
    }
    
    [recentPhotos addObject:photo];
    
    if ([recentPhotos count] > 20){
        [recentPhotos removeObjectAtIndex:0];
    }
    
    [defaults setObject:recentPhotos forKey:FAVORITES_KEY];
    [defaults synchronize];
}

+ (NSArray *)RecentPhotos
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
}

+ (int)indexForPhoto:(id)photoToFind inArray:(NSArray *)arr
{
    NSString *keyToFind = [photoToFind objectForKey:@"id"];
    if (!keyToFind) return -1;
    
    NSDictionary *arrPhoto;
    for (int i = 0; i < [arr count]; ++i){
        arrPhoto = [arr objectAtIndex:i];
        NSString *key = [arrPhoto objectForKey:@"id"];
        if ([key isEqualToString:keyToFind])
            return i;
    }
    return -1;
}

@end
