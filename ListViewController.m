//
//  ListViewController.m
//  CoffeeFindr
//
//  Created by Yemi Ajibola on 12/30/15.
//  Copyright © 2015 Yemi Ajibola. All rights reserved.
//

#import "ListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CoffeePlace.h"
#import "DetailViewController.h"

@interface ListViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property NSArray *coffeePlacesArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    
    //NSLog(@"Accessing viewDidLoad method");
    
    [self updateCurrentLocation];
}

- (void)updateCurrentLocation
{
    // Request authorization to get location
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    //NSLog(@"Accessing updateCurrentLocation method");
    
    
}

- (void)findCoffeePlaces:(CLLocation *)location
{
    //NSLog(@"Accessing findCoffeePlaces method");
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"coffee";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.05, .05));
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error)
    {
        NSArray *mapItems = response.mapItems;
        NSMutableArray *temporaryArray = [NSMutableArray new];
        
        for (int i=0; i < 5; i++)
        {
            MKMapItem *mapItem = [mapItems objectAtIndex:i];
            
            CLLocationDistance metersAway = [mapItem.placemark.location distanceFromLocation:location];
            float milesDifference = metersAway/1609.34;
            
            CoffeePlace *coffeePlace = [CoffeePlace new];
            coffeePlace.mapItem = mapItem;
            coffeePlace.milesDifference = milesDifference;
            
            [temporaryArray addObject:coffeePlace];
        }
        
        //NSLog(@"Exited for loop");
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"milesDifference" ascending:true];
        NSArray *sortedArray = [temporaryArray sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        self.coffeePlacesArray = [NSArray arrayWithArray:sortedArray];
        
        [self.tableView reloadData];
        
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
   //NSLog(@"Entered didUpdateLocations method");
    
    self.currentLocation = locations.firstObject;
    //NSLog(@"%@", locations.firstObject);
   
    [self.locationManager startUpdatingLocation];
    [self findCoffeePlaces:self.currentLocation];
    [self.locationManager stopUpdatingLocation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.coffeePlacesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"coffeeCell"];
    cell.textLabel.text = [[[self.coffeePlacesArray objectAtIndex:indexPath.row] mapItem] name];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"Entered prepareForSegue method");
    
    DetailViewController *detailVC = [segue destinationViewController];
    detailVC.coffeePlace = [self.coffeePlacesArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailVC.currentLocation = self.currentLocation;
}

@end
