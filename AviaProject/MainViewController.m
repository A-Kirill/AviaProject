//
//  MainViewController.m
//  AviaProject
//
//  Created by Kirill Anisimov on 15.05.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import "MainViewController.h"
#import "DataManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];

    [[DataManager sharedInstance] loadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)loadDataComplete {
    self.view.backgroundColor = [UIColor greenColor];
}

@end
