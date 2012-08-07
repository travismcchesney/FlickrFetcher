//
//  FlickrPlaceAnnotation.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/5/12.
//
//

#import "FlickrPlaceAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPlaceAnnotation

@synthesize place = _place;

+ (FlickrPlaceAnnotation *)annotationForPlace:(NSDictionary *)place
{
    FlickrPlaceAnnotation *annotation = [[FlickrPlaceAnnotation alloc] init];
    annotation.place = place;
    return annotation;
}

#pragma mark - MKAnnotation

- (NSString *)title
{
    NSString *place = [self.place objectForKey:FLICKR_PLACE_NAME];
    NSArray *parts = [place componentsSeparatedByString:@", "];
    NSString *placePart1;
    
    if ([parts count] > 0) placePart1 = [parts objectAtIndex:0];

    return placePart1;
}

- (NSString *)subtitle
{
    NSString *place = [self.place objectForKey:FLICKR_PLACE_NAME];
    NSArray *parts = [place componentsSeparatedByString:@", "];
    NSString *placePart2;
    NSString *placePart3;
    
    if ([parts count] > 1) placePart2 = [parts objectAtIndex:1];
    if ([parts count] > 2) placePart3 = [parts objectAtIndex:2];

    return [NSString stringWithFormat:@"%@, %@", placePart2, placePart3, nil];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.place objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end
