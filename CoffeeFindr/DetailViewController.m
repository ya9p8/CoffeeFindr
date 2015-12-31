//
//  DetailViewController.m
//  CoffeeFindr
//
//  Created by Yemi Ajibola on 12/30/15.
//  Copyright © 2015 Yemi Ajibola. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.coffeePlace.mapItem.name;
    [self getPathDirections:self.currentLocation.coordinate withDestitination:self.coffeePlace.mapItem.placemark.location.coordinate];
    
}

- (void)getPathDirections:(CLLocationCoordinate2D)source withDestitination:(CLLocationCoordinate2D)destination
{
    MKPlacemark *placemarkSrc = [[MKPlacemark alloc] initWithCoordinate:source addressDictionary:nil];
    MKMapItem *mapItemSrc = [[MKMapItem alloc] initWithPlacemark:placemarkSrc];
    
    MKPlacemark *placemarkDest = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
    MKMapItem *mapItemDest = [[MKMapItem alloc] initWithPlacemark:placemarkDest];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:mapItemSrc];
    [request setDestination:mapItemDest];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    request.requestsAlternateRoutes = NO;
    
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error)
    {
        MKRoute *route = response.routes.lastObject;
        
        NSString *allSteps = [NSString new];
        
        for(int i=0; i < route.steps.count; i++)
        {
            MKRouteStep *step = [route.steps objectAtIndex:i];
            NSString *newStepString = step.instructions;
            
            allSteps = [allSteps stringByAppendingString:newStepString];
            allSteps = [allSteps stringByAppendingString:@"\n\n"];
            
        }
        self.textView.text = allSteps;
    }];
}

@end
