//
//  FlickrFetcherCache.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/4/12.
//
//

#import "FlickrFetcherCache.h"
#import "FlickrFetcher.h"
#import "RecentPhotos.h"

#define FILENAME_PREFIX @"FlickrFetcher.Cache."
#define CACHE_DIR @"FlickrFetcher"
#define MAX_BYTES 10000000

@interface FlickrFetcherCache()

@end

@implementation FlickrFetcherCache

+ (void)saveImageToCache:(UIImage *)image forKey:(NSString *)key
{
    NSString *fileName = [self cacheFileForName:key];
    
    if (fileName){
        NSData *jpg = UIImageJPEGRepresentation(image, 1);
        
        [jpg writeToFile:fileName atomically:YES];
    }
    
    NSString *cacheDirectory = [self cacheDirectory];
    NSError *error;
    NSArray* filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDirectory error:&error];
    
    if(error) {
        NSLog(@"Error in reading files: %@", [error localizedDescription]);
        return;
    }
    
    int totalFileSize = 0;
    // sort by creation date
    NSMutableArray* filesAndProperties = [NSMutableArray arrayWithCapacity:[filesArray count]];
    for(NSString *file in filesArray) {
        NSString *filePath = [cacheDirectory stringByAppendingPathComponent:file];
        NSDictionary *properties = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:filePath
                                    error:&error];
        NSDate *modDate = [properties objectForKey:NSFileModificationDate];
        
        if(!error)
        {
            int fileSize = [[properties objectForKey:NSFileSize] intValue];
            totalFileSize += fileSize;
            
            [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                           file, @"path",
                                           modDate, @"lastModDate",
                                           nil]];
        }
    }

    if (totalFileSize > MAX_BYTES) {
        NSArray *sortedFiles = [filesAndProperties sortedArrayUsingComparator:
                                ^(id path1, id path2)
                                {
                                    // compare
                                    NSComparisonResult comp = [[path1 objectForKey:@"lastModDate"] compare:
                                                               [path2 objectForKey:@"lastModDate"]];
                                    // invert ordering
                                    if (comp == NSOrderedDescending) {
                                        comp = NSOrderedAscending;
                                    }
                                    else if(comp == NSOrderedAscending){
                                        comp = NSOrderedDescending;
                                    }
                                    return comp;
                                }];
        
        NSDictionary *fileToRemove = [sortedFiles lastObject];
        NSString *pathToRemove = [[self cacheDirectory] stringByAppendingPathComponent:[fileToRemove objectForKey:@"path"]];
        error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:pathToRemove error:&error];
        
        if (error) {
            NSLog(@"Could not delete file %@: %@", pathToRemove, [error localizedDescription]);
        }
        else {
            NSLog(@"Successfully removed file %@", pathToRemove);
        }
    }
}

+ (UIImage *)imageForKey:(NSString *)key
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *imageFilePath = [self cacheFileForName:key];
    
    UIImage *cachedImage;
    
    if ([manager fileExistsAtPath:[self cacheFileForName:key]]) {
        cachedImage = [UIImage imageWithContentsOfFile:imageFilePath];
    }
    return cachedImage;
}

+ (UIImage *)imageForPhoto:(NSDictionary *)photo
{
    UIImage *image;
    NSString *key = [photo objectForKey:FLICKR_PHOTO_ID];
    
    image = [self imageForKey:key];
    
    if (!image){
        NSURL *photoUrl;
        NSData *urlData;

        
        photoUrl = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
        urlData = [NSData dataWithContentsOfURL:photoUrl];
        image = [UIImage imageWithData:urlData];
        
        [self saveImageToCache:image forKey:key];
    }
    
    [RecentPhotos addToRecents:photo];
    
    return image;
}

+ (NSString *)cacheFileForName:(NSString *)name
{
    NSString *path = [self cacheDirectory];

    if (path){
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", FILENAME_PREFIX, name, nil]];
        return path;
    }    
    return nil;
}

+ (NSString *)cacheDirectory
{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent: [NSString stringWithFormat:@"Library/Caches/%@", CACHE_DIR, nil]];
    
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSError *error = nil;
    
    if([manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error])
        return directory;
    else
        NSLog(@"Error occurred creating directory %@:%@", directory, [error localizedDescription], nil);
    
    return nil;
}

@end
