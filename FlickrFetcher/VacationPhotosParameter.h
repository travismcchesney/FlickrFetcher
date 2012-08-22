//
//  VacationPhotosParameter.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/21/12.
//
//

#import <Foundation/Foundation.h>

@interface VacationPhotosParameter : NSObject

@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) NSString *title;

@end
