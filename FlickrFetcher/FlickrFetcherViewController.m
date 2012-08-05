//
//  FlickrFetcherViewController.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrFetcherViewController.h"
#import "FlickrFetcher.h"
#import "FlickrFetcherPlacesViewController.h"

@interface FlickrFetcherViewController ()

@end

@implementation FlickrFetcherViewController

#define RECENT_KEY @"FlickrFetcherViewController.Recent"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //NSLog(@"%@", [FlickrFetcher topPlaces]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
