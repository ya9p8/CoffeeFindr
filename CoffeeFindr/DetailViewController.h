//
//  DetailViewController.h
//  CoffeeFindr
//
//  Created by Yemi Ajibola on 12/30/15.
//  Copyright © 2015 Yemi Ajibola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoffeePlace.h"

@interface DetailViewController : UIViewController

@property CoffeePlace *coffeePlace;
@property CLLocation *currentLocation;

@end
