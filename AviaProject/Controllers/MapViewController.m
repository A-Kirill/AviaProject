//
//  MapViewController.m
//  AviaProject
//
//  Created by Kirill Anisimov on 14.06.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import "MapViewController.h"
#import "LocationService.h"
#import "APIManager.h"
#import "MapPrice.h"
#import "CoreDataHelper.h"


@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.title = @"Price map";
    
    _mapView = [[MKMapView alloc] initWithFrame:frame];
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    [self.mapView setDelegate:self];
    
    [[DataManager sharedInstance] loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    _locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    [self addressFromLocation:currentLocation];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
    
    if (currentLocation) {
        _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (_origin) {
            [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                [self setPrices: prices];
            }];
        }
    }
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
    
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld RUB.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            [self.mapView addAnnotation: annotation];
        });
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSString *originDest = view.annotation.title;
    MapPrice* curPrice = nil;
    if (_prices != nil) {
        for (MapPrice* price in _prices) {
            if ([originDest isEqualToString:[NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code]]) {
                curPrice = price;
                break;
            }
        }
    }
    if (curPrice != nil) {
        NSString *title = [NSString stringWithFormat:@"%@\n%@", view.annotation.title, view.annotation.subtitle];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"Что необходимо сделать?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *favoriteAction;
        if ([[CoreDataHelper sharedInstance] isFavoriteMapPrice:curPrice]) {
            favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] removeFromFavoriteMapPrice:curPrice];
            }];
        } else {
            favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] addToFavoriteMapPrice:curPrice];
            }];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:favoriteAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

// CLGeocoder
- (void)addressFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            NSMutableString *address = [[NSMutableString alloc] initWithString:@""];
            for (MKPlacemark *placemark in placemarks) {
                [address appendString:placemark.name];
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Your location address" message:address preferredStyle: UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:(UIAlertActionStyleDefault) handler:nil]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

@end
