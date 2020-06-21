//
//  TabBarController.m
//  AviaProject
//
//  Created by Kirill Anisimov on 20.06.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "CollectionViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor = [UIColor blackColor];
    }
    return self;
}


- (NSArray<UIViewController*> *)createViewControllers {
    NSMutableArray<UIViewController*> *controllers = [NSMutableArray new];
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:[UIImage imageNamed:@"search"] selectedImage:[UIImage imageNamed:@"search_selected"]];
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [controllers addObject:mainNavigationController];
    
    MapViewController *mapViewController = [[MapViewController alloc] init];
    mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Price map" image:[UIImage imageNamed:@"map"] selectedImage:[UIImage imageNamed:@"map_selected"]];
    UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    [controllers addObject:mapNavigationController];
    
    CollectionViewController *collectionViewController = [[CollectionViewController alloc] init];
    collectionViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Images" image:[UIImage imageNamed:@"picture"] selectedImage:[UIImage imageNamed:@"picture-2"]];
    UINavigationController *collectionNavigationController = [[UINavigationController alloc] initWithRootViewController:collectionViewController];
    [controllers addObject:collectionNavigationController];
    
    return controllers;
}


@end
