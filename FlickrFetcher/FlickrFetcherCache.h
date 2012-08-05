//
//  FlickrFetcherCache.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/4/12.
//
//

#import <Foundation/Foundation.h>

@interface FlickrFetcherCache : NSObject

+ (void)saveImageToCache:(UIImage *)image forKey:(NSString *)key;
+ (UIImage *)imageForPhoto:(NSDictionary *)photo;

@end
