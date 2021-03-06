//
//  MainViewController.m
//  AviaProject
//
//  Created by Kirill Anisimov on 15.05.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import "MainViewController.h"
#import "DataManager.h"
#import "TicketsViewController.h"
#import "MapViewController.h"
#import "ProgressView.h"
#import "FirstViewController.h"


@interface MainViewController () <PlaceViewControllerDelegate>

@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic) SearchRequest searchRequest;
@property (nonatomic, strong) UIView *placeContainerView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *mapButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataManager sharedInstance] loadData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = @"Search";
    
    _placeContainerView = [[UIView alloc] initWithFrame:CGRectMake(20.0, [UIScreen mainScreen].bounds.size.height/2 - 100.0, [UIScreen mainScreen].bounds.size.width - 40.0, 170.0)];
    _placeContainerView.backgroundColor = [UIColor whiteColor];
    _placeContainerView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
    _placeContainerView.layer.shadowOffset = CGSizeZero;
    _placeContainerView.layer.shadowRadius = 20.0;
    _placeContainerView.layer.shadowOpacity = 1.0;
    _placeContainerView.layer.cornerRadius = 6.0;
    
    _departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_departureButton setTitle:@"From" forState: UIControlStateNormal];
    _departureButton.tintColor = [UIColor blackColor];
    _departureButton.frame = CGRectMake(10.0, 20.0, _placeContainerView.frame.size.width - 20.0, 60.0);
    _departureButton.backgroundColor = [[UIColor colorWithRed:168.0f/255.0f green:218.0f/255.0f blue:220.0f/255.0f alpha:1]/*[UIColor lightGrayColor]*/ colorWithAlphaComponent:0.3];
    _departureButton.layer.cornerRadius = 4.0;
    [_departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.placeContainerView addSubview:_departureButton];
    
    _arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_arrivalButton setTitle:@"To" forState: UIControlStateNormal];
    _arrivalButton.tintColor = [UIColor blackColor];
    _arrivalButton.frame = CGRectMake(10.0, CGRectGetMaxY(_departureButton.frame) + 10.0, _placeContainerView.frame.size.width - 20.0, 60.0);
    _arrivalButton.backgroundColor = [[UIColor colorWithRed:168.0f/255.0f green:218.0f/255.0f blue:220.0f/255.0f alpha:1] colorWithAlphaComponent:0.3];
    _arrivalButton.layer.cornerRadius = 4.0;
    [_arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.placeContainerView addSubview:_arrivalButton];
    
    [self.view addSubview:_placeContainerView];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_searchButton setTitle:@"Search" forState:UIControlStateNormal];
    _searchButton.tintColor = [UIColor whiteColor];
    _searchButton.frame = CGRectMake(30.0, CGRectGetMaxY(_placeContainerView.frame) + 30, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    _searchButton.backgroundColor = [UIColor colorWithRed:69.0f/255.0f green:123.0f/255.0f blue:157.0f/255.0f alpha:1];
    _searchButton.layer.cornerRadius = 8.0;
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    [self.view addSubview:_searchButton];
    
//    _mapButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [_mapButton setTitle:@"Price map" forState:UIControlStateNormal];
//    _mapButton.tintColor = [UIColor whiteColor];
//    _mapButton.frame = CGRectMake(30.0, CGRectGetMaxY(_searchButton.frame) + 30, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
//    _mapButton.backgroundColor = [UIColor blackColor];
//    _mapButton.layer.cornerRadius = 8.0;
//    _mapButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
//    [_mapButton addTarget:self action:@selector(mapButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_mapButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    
    [_searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
}

//For ContentViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentFirstViewControllerIfNeeded];
}

- (void)presentFirstViewControllerIfNeeded
{
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"first_start"];
    if (!isFirstStart) {
        FirstViewController *firstViewController = [[FirstViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [self presentViewController:firstViewController animated:YES completion:nil];
    }
}


- (void)searchButtonDidTap:(UIButton *)sender {
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{
                sender.frame = CGRectMake(40.0, CGRectGetMaxY(self->_placeContainerView.frame) + 40, [UIScreen mainScreen].bounds.size.width - 80.0, 40.0);
                        }
                     completion:^(BOOL finished) {
                         sender.frame = CGRectMake(30.0, CGRectGetMaxY(self->_placeContainerView.frame) + 30, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
                     }];
    
    if (_searchRequest.origin && _searchRequest.destionation) {
        [[ProgressView sharedInstance] show:^{
            [[APIManager sharedInstance] ticketsWithRequest:self->_searchRequest withCompletion:^(NSArray *tickets) {
                [[ProgressView sharedInstance] dismiss:^{
                    if (tickets.count > 0) {
                        TicketsViewController *ticketsViewController = [[TicketsViewController alloc] initWithTickets:tickets];
                        [self.navigationController showViewController:ticketsViewController sender:self];
                    } else {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Увы!" message:@"По данному направлению билетов не найдено" preferredStyle: UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть" style:(UIAlertActionStyleDefault) handler:nil]];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }];
            }];
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Необходимо указать место отправления и место прибытия" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


- (void)placeButtonDidTap:(UIButton *)sender {
    PlaceViewController *placeViewController;
    if ([sender isEqual:_departureButton]) {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeArrival];
    }
    placeViewController.delegate = self;
    [UIView transitionFromView:self.view toView:placeViewController.view duration:0.6 options:UIViewAnimationOptionTransitionCurlDown completion:nil];
    [self.navigationController pushViewController: placeViewController animated:YES];
}

//- (void)mapButtonDidTap:(UIButton *)sender {
//    MapViewController *mapVC = [MapViewController new];
//    [self.navigationController pushViewController: mapVC animated:YES];
//}

#pragma mark - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    [self setPlace:place withDataType:dataType andPlaceType:placeType forButton: (placeType == PlaceTypeDeparture) ? _departureButton : _arrivalButton ];
}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button {
    NSString *title;
    NSString *iata;
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    }
    else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    if (placeType == PlaceTypeDeparture) {
        _searchRequest.origin = iata;
    } else {
        _searchRequest.destionation = iata;
    }
    [button setTitle: title forState: UIControlStateNormal];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)dataLoadedSuccessfully {
    [[APIManager sharedInstance] cityForCurrentIP:^(City *city) {
        [self setPlace:city withDataType:DataSourceTypeCity andPlaceType:PlaceTypeDeparture forButton:self->_departureButton];
    }];
}

@end
