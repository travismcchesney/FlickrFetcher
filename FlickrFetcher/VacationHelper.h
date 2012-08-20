//
//  VacationHelper.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/16/12.
//
//

#import <Foundation/Foundation.h>

typedef void (^completion_block_t)(UIManagedDocument *vacation);

@interface VacationHelper : NSObject

+ (VacationHelper *)instance;

- (void)openVacation:(NSString *)vacationName
          usingBlock:(completion_block_t)completionBlock;

@end