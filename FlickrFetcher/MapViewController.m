//
//  MapViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "MapViewController.h"
#import "FlickrPlaceAnnotation.h"
#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcherPhotoViewController.h"

@interface MapViewController() <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;

#pragma mark - Synchronize Model and View

- (NSArray *)annotations
{
    return _annotations;
}

+ (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations
{
    CLLocationDegrees maxLatitude = MAXFLOAT * -1;
    CLLocationDegrees maxLongitude = MAXFLOAT * -1;
    CLLocationDegrees minLatitude = MAXFLOAT;
    CLLocationDegrees minLongitude = MAXFLOAT;
    
    for (int i = 0; i < [annotations count]; i++) {
        CLLocationCoordinate2D coordinate = [[annotations objectAtIndex:i] coordinate];
        if (coordinate.latitude > maxLatitude) maxLatitude = coordinate.latitude;
        if (coordinate.longitude > maxLongitude) maxLongitude = coordinate.longitude;
        if (coordinate.latitude < minLatitude) minLatitude = coordinate.latitude;
        if (coordinate.longitude < minLongitude) minLongitude = coordinate.longitude;
    }
    
    CLLocationDegrees centerLatitude = ((maxLatitude + minLatitude) / 2.0);
    CLLocationDegrees centerLongitude = ((maxLongitude + minLongitude) / 2.0);
    CLLocationDegrees spanLatitude = maxLatitude - minLatitude;
    CLLocationDegrees spanLongitude = maxLongitude - minLongitude;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(centerLatitude, centerLongitude), MKCoordinateSpanMake(spanLatitude + (spanLatitude * .25), spanLongitude + (spanLongitude * .25)));
    return region;
}

- (void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) {
        [self.mapView addAnnotations:self.annotations];
        [self.mapView setRegion:[[self class] regionForAnnotations:self.annotations] animated:YES];
    }
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowPlacesPhotos"]) {
        [segue.destinationViewController setPlace:[sender place]];
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aView.rightCalloutAccessoryView = disclosureButton;
    }

    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
    if ([view.annotation isKindOfClass:[FlickrPlaceAnnotation class]]) {
        NSLog(@"callout accessory tapped for Place annotation %@", [view.annotation title]);
        [self performSegueWithIdentifier:@"ShowPlacesPhotos" sender:view.annotation];
    } else if ([view.annotation isKindOfClass:[FlickrPhotoAnnotation class]]) {
        NSLog(@"callout accessory tapped for Photo annotation %@", [view.annotation title]);
        id detail = [self.splitViewController.viewControllers lastObject];
        if ([detail isKindOfClass:[FlickrFetcherPhotoViewController class]]) {
            FlickrFetcherPhotoViewController *photoVC = (FlickrFetcherPhotoViewController *)detail;
            photoVC.photo = [(FlickrPhotoAnnotation *)view.annotation photo];
        }

    }
    
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark - Autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
