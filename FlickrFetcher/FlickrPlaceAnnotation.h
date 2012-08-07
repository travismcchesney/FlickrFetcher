//
//  FlickrPlaceAnnotation.h
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/5/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPlaceAnnotation : NSObject <MKAnnotation>

+ (FlickrPlaceAnnotation *)annotationForPlace:(NSDictionary *)place; // Flickr place dictionary

@property (nonatomic, strong) NSDictionary *place;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
